# Mattermost

Self-hosted team messaging platform. Open-source Slack alternative with channels, direct messaging, file sharing, and integrations.

## Quick Deploy

```bash
make deploy app=mattermost environment=prod region=fra
```

## Initial Configuration

```bash
# Access the app to create your first admin account
# Navigate to https://mattermost-prod.fly.dev
# Follow the setup wizard to create your team and admin user
```

## Architecture

- **Main app**: Mattermost web interface and API (port 8065)
- **PostgreSQL**: User data, messages, and channel storage

The Makefile automatically creates and deploys both services.

## Useful Commands

| Command | Purpose |
|---------|---------|
| `fly logs --app mattermost-prod` | View main app logs |
| `fly status --app mattermost-prod` | Check app status |
| `fly logs --app mattermost-prod-postgres` | View PostgreSQL logs |
| `fly ssh console --app mattermost-prod` | Access main app |
| `fly dashboard --app mattermost-prod` | Open web dashboard |
