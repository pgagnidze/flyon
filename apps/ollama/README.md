# Ollama

Local LLM server for running language models privately.

## Deploy

```bash
make deploy app=ollama
```

## Pull Models

```bash
podman-compose exec ollama ollama pull phi4:14b
podman-compose exec ollama ollama pull deepseek-r1:14b
```

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=ollama` | View logs |
| `make status app=ollama` | Check status |
