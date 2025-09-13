.PHONY: help postgres postgres-down clean seed

help:
	@echo "Commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Setup env file
	@echo "Making env file..."
	cp .env.example .env

up: ## Run a Postgres container
	@echo "Starting Postgres container..."
	docker-compose -f docker/docker-compose.yml --env-file .env up -d

down: ## Stop Postgres container
	@echo "Stopping Postgres container..."
	docker-compose -f docker/docker-compose.yml down

clean: ## Cleanup all running containers related to the challenge.
	@echo "Cleaning up Docker containers and volumes..."
	docker-compose -f docker/docker-compose.yml down --volumes --remove-orphans
