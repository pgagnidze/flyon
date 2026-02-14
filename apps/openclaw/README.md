# OpenClaw

Personal AI assistant with chat platform integrations.

## Setup

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

Generate a gateway token: `openssl rand -hex 32`

After first deploy, run the onboarding wizard to configure channels:

```bash
podman exec -it openclaw_openclaw_1 node dist/index.js onboard
```

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
