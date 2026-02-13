# Caddy

Reverse proxy with automatic HTTPS via Cloudflare DNS challenge.

## Setup

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

To get your Tailscale IP: `tailscale ip -4`

To get a Cloudflare API token: Cloudflare dashboard > My Profile > API Tokens > Create Token > Edit zone DNS.

## Deploy

```bash
make deploy app=caddy
```

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=caddy` | View logs |
| `make status app=caddy` | Check status |
| `make stop app=caddy` | Stop Caddy |
