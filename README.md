# Flyon

Self-hosted applications on a home server using Podman Compose.

## Apps

| App | Description | Port | Dependencies |
|-----|-------------|------|--------------|
| [Caddy](apps/caddy) | Reverse proxy with HTTPS | 443 | |
| [Uptime Kuma](apps/kuma) | Uptime monitoring | 3001 | |
| [Memos](apps/memos) | Note-taking | 5230 | |
| [IT-Tools](apps/it-tools) | Developer utilities | 8080 | |
| [md-to-pdf](apps/md-to-pdf) | Markdown to PDF | 8000 | |
| [SearXNG](apps/searxng) | Meta search engine | 8888 | Valkey |
| [LibreChat](apps/librechat) | AI chat interface | 3080 | MongoDB |
| [Ollama](apps/ollama) | Local LLM server | 11434 | |
| [ConvertX](apps/convertx) | File converter | 3000 | |

## Usage

```bash
make deploy app=memos       # Deploy a single app
make stop app=memos         # Stop a single app
make up                     # Start all apps
make down                   # Stop all apps
make logs app=memos         # View app logs
make status app=memos       # Check app status
make update                 # Pull latest images and restart all apps
```

## Deployment

Pushing to `main` triggers a GitHub Actions workflow that SSHs into the server via Tailscale and deploys changed apps.

## Access

| Layer | Tool | Purpose |
|-------|------|---------|
| Private access | Tailscale | Access all apps from anywhere via VPN |
| Reverse proxy | Caddy | Route `*.meore.link` subdomains to container ports |
| DNS | NextDNS | Resolve `*.meore.link` to Tailscale IP within tailnet |
| TLS certificates | Cloudflare DNS challenge | HTTPS via Let's Encrypt without exposing ports |

Apps are accessible at `https://<app>.meore.link` from any device on the tailnet.

## Server Setup

Everything below requires a temporary keyboard and monitor (HDMI). Once SSH and Tailscale are working, unplug them.

<details>
<summary><strong>1. BIOS</strong></summary>

Press `DEL` or `F7` during boot to enter BIOS. Configure:

- **Boot order**: set USB drive first (for OS installation)
- **Restore on AC Power Loss**: set to **Power On** (auto-boot after outage)

On some boards this is called "State After G3" under Advanced > PCH-IO Configuration. Set it to S0.

</details>

<details>
<summary><strong>2. Install Fedora Server</strong></summary>

Download the Fedora Server DVD ISO (x86_64) and flash it to a USB stick.

Boot from USB and install with:

- Storage: automatic partitioning, full disk, encrypt my data (LUKS)
- Root account: disabled
- User: create one with administrator privileges

After install, log in and connect to Wi-Fi:

```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "PASSWORD"
```

If Wi-Fi doesn't work out of the box, use ethernet or phone USB tethering to get online, then run `sudo dnf upgrade -y` and reboot. The system update fixes most driver issues on newer hardware.

</details>

<details>
<summary><strong>3. Tailscale</strong></summary>

Tailscale gives you remote access from anywhere without port forwarding, static IPs, or firewall configuration.

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --ssh
```

Open the URL it prints, authenticate, and the machine joins your tailnet. From any other device on the same tailnet:

```bash
ssh username@hostname
```

Cockpit web UI is also available at `https://hostname:9090`.

Install Tailscale on your laptop and phone too. After this, unplug keyboard and monitor.

The GitHub Actions deploy workflow connects to your tailnet via OAuth.

In the Tailscale admin console:

1. Go to Access Controls > Tags and create two tags (owner: `autogroup:admin`):
   - `ci`
   - `server`
2. Go to Machines, find your server, and assign `tag:server` to it
3. In the ACL editor, add the SSH rules:

```json
"ssh": [
    {
        "action": "check",
        "src":    ["autogroup:member"],
        "dst":    ["tag:server"],
        "users":  ["autogroup:nonroot", "root"]
    },
    {
        "action": "check",
        "src":    ["autogroup:member"],
        "dst":    ["autogroup:self"],
        "users":  ["autogroup:nonroot", "root"]
    },
    {
        "action": "accept",
        "src":    ["tag:ci"],
        "dst":    ["tag:server"],
        "users":  ["deploy"]
    }
]
```

4. Go to Settings > OAuth clients > Generate OAuth client
   - Scope: `auth_keys` (writable)
   - Tag: `tag:ci`
5. Add the following secrets to your GitHub repo (Settings > Secrets and variables > Actions):
   - `TS_OAUTH_CLIENT_ID` - OAuth client ID
   - `TS_OAUTH_SECRET` - OAuth client secret (shown only once)
   - `SSH_USER` - `deploy`
   - `SSH_HOST` - your server's Tailscale hostname

</details>

<details>
<summary><strong>4. LUKS + TPM auto-unlock</strong></summary>

With LUKS enabled, the server asks for a passphrase on every boot. This prevents unattended restarts after power loss. Binding the LUKS key to the TPM chip fixes this.

```bash
# install tools
sudo dnf install -y tpm2-tools tpm2-tss

# verify TPM works
tpm2_pcrread

# find the LUKS partition
lsblk -f  # look for crypto_LUKS, e.g. /dev/nvme0n1p3

# enroll TPM with PCRs 1+7
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=1+7 /dev/nvme0n1p3
```

Edit `/etc/crypttab`, change:

```
luks-xxxxxx  UUID=xxxxxx  none  luks
```

to:

```
luks-xxxxxx  UUID=xxxxxx  -  tpm2-device=auto
```

Rebuild initramfs and reboot:

```bash
sudo dracut --regenerate-all --force
sudo reboot
```

The server should now boot without prompting for a passphrase. The original LUKS password still works as a fallback if TPM unlock ever fails.

</details>

<details>
<summary><strong>5. System packages</strong></summary>

```bash
sudo dnf upgrade -y
sudo dnf install -y podman-compose git make micro btop
```

</details>

<details>
<summary><strong>6. Deploy user</strong></summary>

Create a dedicated user for CI deployments:

```bash
sudo useradd -m -s /bin/bash deploy
sudo usermod -aG systemd-journal deploy
```

The repo is cloned automatically on the first deploy via GitHub Actions.

</details>

<details>
<summary><strong>7. Firewall and ports</strong></summary>

Open port 443 for HTTPS:

```bash
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload
```

Allow rootless Podman to bind privileged ports (needed for Caddy on 443):

```bash
echo "net.ipv4.ip_unprivileged_port_start=80" | sudo tee /etc/sysctl.d/caddy.conf
sudo sysctl -p /etc/sysctl.d/caddy.conf
```

</details>

<details>
<summary><strong>8. NextDNS rewrite</strong></summary>

NextDNS resolves `*.meore.link` to your server's Tailscale IP so the domain works within your tailnet.

1. Go to [NextDNS](https://my.nextdns.io) and open the profile used by your tailnet
2. Go to Settings > Rewrites
3. Add a rewrite: `*.meore.link` -> your server's Tailscale IP (`100.x.x.x`)
4. In the Tailscale admin console, go to DNS > Nameservers and add NextDNS with your profile endpoint ID
5. Enable "Override local DNS"

Verify from any tailnet device:

```bash
dig +short memos.meore.link
# should return your server's Tailscale IP
```

</details>

## Troubleshooting

<details>
<summary><strong>TPM auto-unlock stopped working</strong></summary>

Happens after BIOS or firmware updates. Need temporary keyboard and monitor.

1. Type LUKS password at the boot prompt
2. Re-enroll TPM:

   ```bash
   sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=1+7 /dev/nvme0n1p3
   sudo dracut --regenerate-all --force
   sudo reboot
   ```

</details>

<details>
<summary><strong>Wi-Fi connects but no internet</strong></summary>

Common with newer Intel Wi-Fi chips on fresh Fedora installs. The card associates with the access point but cannot route traffic.

1. Use phone USB tethering or a different Wi-Fi network (hotspot) as a workaround
2. Run `sudo dnf upgrade -y` to update kernel and firmware
3. Reboot, reconnect to the original Wi-Fi

Disabling Wi-Fi power save can also help:

```bash
sudo iw dev wlp173s0f0 set power_save off
```

</details>

<details>
<summary><strong>Server does not auto-boot after power loss</strong></summary>

Two possible causes:

- BIOS: "Restore on AC Power Loss" is not set to Power On
- LUKS passphrase prompt is waiting for input (set up TPM auto-unlock to fix this)

</details>

<details>
<summary><strong>Cannot reach Cockpit</strong></summary>

```bash
sudo systemctl status cockpit.socket
sudo firewall-cmd --add-service=cockpit --permanent
sudo firewall-cmd --reload
```

Access via Tailscale hostname: `https://hostname:9090`

</details>

## Todo

- [ ] Selective deploy (only changed apps instead of all)
- [ ] Cleanup removed apps (stop containers for deleted app directories)
- [ ] UPS for power outage protection
- [ ] Backup strategy (3-2-1 rule)

> [!NOTE]
> Current hardware: Beelink GTi14 Ultra. Intel Core Ultra 9 185H, 32GB DDR5, 1TB NVMe.

## License

This project is licensed under the [MIT License](LICENSE).
