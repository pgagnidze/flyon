# Flyo

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Last commit](https://img.shields.io/github/last-commit/Owloops/flyo.svg)](https://github.com/Owloops/flyo/commits/main)

Deploy self-hosted applications to Fly.io with a single command. Pre-configured deployments for open-source tools with automated GitHub Actions workflows.

## Getting Started

Fork this repository or use it as a template:

1. Create your repository (fork or template)
2. Add `FLY_API_TOKEN` to repository secrets
3. (Optional) Add `ENVIRONMENT` secret for private environment suffix
4. Deploy via GitHub Actions or command line

The system parallelizes deployments across multiple workers automatically.

## Prerequisites

- [Fly CLI](https://fly.io/docs/flyctl/install/) installed
- `make`, `jq`, and `envsubst` (standard tools)

Run `make doctor` to verify your setup.

**Tip**: Disable analytics warnings with `fly settings analytics disable`

## Available Apps

| App | Description | Dependencies |
|-----|-------------|-------------|
| glance | Personal dashboard | - |
| it-tools | Developer tools collection | - |
| kuma | Uptime monitoring | - |
| librechat | AI chat interface | MongoDB |
| linkding | Bookmark manager | - |
| mattermost | Team messaging platform | PostgreSQL |
| md-to-pdf | Markdown to PDF converter | - |
| memos | Note-taking app | - |
| ollama | Local LLM server | - |
| redlib | Reddit frontend | - |
| searxng | Meta search engine | Valkey |

## Quick Start

```bash
# Authenticate with Fly.io
fly auth login

# Deploy an app
make deploy app=glance

# Deploy with environment suffix
make deploy app=glance environment=staging

# Deploy to specific region
make deploy app=glance region=fra

# Development workflow
make deploy app=memos environment=dev
make logs app=memos environment=dev
make destroy app=memos environment=dev
```

## Commands

| Command | Description | Example |
|---------|-------------|----------|
| `help` | Show all available commands | `make help` |
| `doctor` | Verify prerequisites | `make doctor` |
| `deploy` | Deploy an app | `make deploy app=glance` |
| `status` | Check app status | `make status app=glance` |
| `logs` | View recent logs | `make logs app=glance` |
| `destroy` | Remove an app | `make destroy app=glance` |

**Note**: Apps with dependencies (e.g., `librechat`, `searxng`) automatically deploy required services.

## Adding New Apps

```bash
# Create app structure
mkdir apps/myapp && cd apps/myapp
fly launch --no-deploy

# Deploy
make deploy app=myapp
```

Optional: Add documentation using the [README template](templates/README.template.md).

## Contributing

We encourage contributions to the main repository rather than maintaining separate forks. This helps the community benefit from improvements:

- **Add new apps**: See [Adding New Apps](#adding-new-apps) section
- **Improve existing apps**: Enhance configurations, add features, fix issues
- **Documentation**: Improve clarity, add examples, fix errors

Contributions to this repository benefit everyone using Flyo. Submit pull requests with your improvements!

## License

This project is licensed under the [MIT License](LICENSE).
