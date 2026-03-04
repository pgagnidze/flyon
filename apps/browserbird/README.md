# BrowserBird

AI assistant with Slack integration, a real browser, and a scheduler. Uses Claude CLI under the hood.

## Setup

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

Generate a Claude OAuth token: `claude setup-token` (requires Claude Max subscription).

For Slack tokens, see [Create a Slack app](#create-a-slack-app).

All secrets are passed from GitHub Actions on deploy. Add them to your repo (Settings > Secrets and variables > Actions):

- `BB_SLACK_BOT_TOKEN`
- `BB_SLACK_APP_TOKEN`
- `BB_CLAUDE_CODE_OAUTH_TOKEN`

### Create a Slack app

1. Go to [api.slack.com/apps](https://api.slack.com/apps) > Create New App > From an app manifest
2. Paste the contents of [manifest.json](https://github.com/owloops/browserbird/blob/main/manifest.json)
3. Install to Workspace > copy Bot Token (`xoxb-...`)
4. Go to Basic Information > App-Level Tokens > Generate Token with `connections:write` scope (gives `xapp-...`)
5. In Slack, invite the bot: `/invite @BrowserBird`

## Deploy

```bash
make deploy app=browserbird
```

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=browserbird` | View logs |
| `make status app=browserbird` | Check status |
| `make stop app=browserbird` | Stop BrowserBird |
