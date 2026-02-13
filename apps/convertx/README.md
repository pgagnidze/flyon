# ConvertX

Self-hosted file converter supporting 1000+ formats.

## Setup

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

## Deploy

```bash
make deploy app=convertx
```

## Commands

| Command | Purpose |
|---------|---------|
| `make logs app=convertx` | View logs |
| `make status app=convertx` | Check status |
| `make stop app=convertx` | Stop ConvertX |
