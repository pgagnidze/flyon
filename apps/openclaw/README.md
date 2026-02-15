# OpenClaw

Personal AI assistant with Slack integration.

## Setup

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

Generate a gateway token: `openssl rand -hex 32`

For Slack tokens, see [Create a Slack app](#create-a-slack-app).

All secrets are passed from GitHub Actions on deploy. Add them to your repo (Settings > Secrets and variables > Actions):

- `OPENCLAW_GATEWAY_TOKEN`
- `ANTHROPIC_API_KEY`
- `SLACK_BOT_TOKEN`
- `SLACK_APP_TOKEN`

### Create a Slack app

1. Go to [api.slack.com/apps](https://api.slack.com/apps) > Create New App > From scratch
2. OAuth & Permissions > add bot token scopes:
   - `chat:write`, `channels:history`, `channels:read`
   - `groups:history`, `groups:read`
   - `im:history`, `im:read`, `im:write`, `users:read`
3. Socket Mode > enable > create App-Level Token with `connections:write` scope (gives `xapp-...`)
4. Event Subscriptions > Enable Events > Subscribe to bot events:
   - `message.channels`, `message.im`, `app_mention`
5. Install to Workspace > copy Bot Token (`xoxb-...`)
6. Reinstall the app after adding event subscriptions
7. In Slack, invite the bot: `/invite @OpenClaw`

## Post-deployment (first time only)

### Approve dashboard device

1. Open `openclaw.meore.link` in browser
2. It will ask for pairing approval
3. Approve from inside the container:

```bash
podman-compose exec openclaw node dist/index.js devices list
podman-compose exec openclaw node dist/index.js devices approve <requestId>
```

If you get "device token mismatch", clear browser local storage for that domain and retry.

## Deploy

```bash
make deploy app=openclaw
```

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=openclaw` | View logs |
| `make status app=openclaw` | Check status |
| `make stop app=openclaw` | Stop OpenClaw |
