# SearXNG

Meta search engine that aggregates results from multiple search engines.

## Deploy

```bash
make deploy app=searxng
```

Starts SearXNG with Valkey for caching and rate limiting.

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=searxng` | View logs |
| `make status app=searxng` | Check status |
