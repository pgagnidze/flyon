# Ollama

Local LLM server for running language models privately.

## Deploy

```bash
make deploy app=ollama
```

## Pull Models

```bash
podman-compose exec ollama ollama pull qwen3.5:27b
podman-compose exec ollama ollama pull qwen3-embedding:4b
```

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=ollama` | View logs |
| `make status app=ollama` | Check status |
