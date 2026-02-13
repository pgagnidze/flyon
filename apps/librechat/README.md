# LibreChat

AI chat interface with support for multiple language models.

## Deploy

```bash
make deploy app=librechat
```

Starts LibreChat with MongoDB. First user to register becomes admin.

Ollama integration is pre-configured in `librechat.yaml`. Ollama must be running on the host (`make deploy app=ollama`).

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=librechat` | View logs |
| `make status app=librechat` | Check status |
