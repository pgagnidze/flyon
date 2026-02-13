.DEFAULT_GOAL := help

validate_app = $(if $(app),,$(error Usage: make $@ app=<app>))

.PHONY: help deploy stop up down logs status pull update

help: ## Show usage and commands
	@printf "Flyon - Self-hosted applications with Podman Compose\n\n"
	@printf "Usage: make <command> app=<app>\n\n"
	@printf "Commands:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'
	@printf "\nExamples:\n"
	@printf "  make deploy app=memos       # Deploy a single app\n"
	@printf "  make logs app=memos         # View app logs\n"
	@printf "  make status app=memos       # Check app status\n"
	@printf "  make update                 # Pull and restart all apps\n"

deploy: ## Deploy a single app
	$(call validate_app)
	@echo "Deploying $(app)..."
	@cd apps/$(app) && podman-compose up -d
	@echo "$(app) deployed"

stop: ## Stop a single app
	$(call validate_app)
	@echo "Stopping $(app)..."
	@cd apps/$(app) && podman-compose down
	@echo "$(app) stopped"

up: ## Start all apps
	@for dir in apps/*/; do \
		if [ -f "$$dir/podman-compose.yml" ]; then \
			app=$$(basename "$$dir"); \
			echo "Starting $$app..."; \
			cd "$$dir" && podman-compose up -d && cd ../..; \
		fi; \
	done

down: ## Stop all apps
	@for dir in apps/*/; do \
		if [ -f "$$dir/podman-compose.yml" ]; then \
			app=$$(basename "$$dir"); \
			echo "Stopping $$app..."; \
			cd "$$dir" && podman-compose down && cd ../..; \
		fi; \
	done

logs: ## Show app logs
	$(call validate_app)
	@cd apps/$(app) && podman-compose logs -f

status: ## Show app status
	$(call validate_app)
	@cd apps/$(app) && podman-compose ps

pull: ## Pull latest images for an app
	$(call validate_app)
	@cd apps/$(app) && podman-compose pull

update: ## Pull and restart all apps
	@for dir in apps/*/; do \
		if [ -f "$$dir/podman-compose.yml" ]; then \
			app=$$(basename "$$dir"); \
			echo "Updating $$app..."; \
			cd "$$dir" && podman-compose pull 2>/dev/null; podman-compose up -d && cd ../..; \
		fi; \
	done
