# Makefile for Laravel Docker Development

# Variables
DOCKER_COMPOSE = docker-compose
APP_CONTAINER = app_1
DB_CONTAINER = mariadb_database

# Colors
GREEN = \033[0;32m
NC = \033[0m # No Color

.PHONY: help setup up down build shell artisan composer logs db-shell

help:
	@echo "$(GREEN)Available commands:$(NC)"
	@echo "  make setup      - First time setup (copy .env, build, up, composer install, key generate)"
	@echo "  make up         - Start containers in detached mode"
	@echo "  make down       - Stop and remove containers"
	@echo "  make build      - Build containers"
	@echo "  make shell      - Access the app container shell"
	@echo "  make artisan    - Run artisan commands (usage: make artisan cmd=\"migrate\")"
	@echo "  make composer   - Run composer commands (usage: make composer cmd=\"install\")"
	@echo "  make logs       - View logs"
	@echo "  make db-shell   - Access the database container shell"

setup:
	@echo "$(GREEN)Setting up the project...$(NC)"
	@if [ ! -f .env ]; then cp .env.example .env; fi
	@$(DOCKER_COMPOSE) build
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Installing dependencies...$(NC)"
	@$(DOCKER_COMPOSE) exec $(APP_CONTAINER) composer install --ignore-platform-req=ext-http --ignore-platform-req=ext-mysql_xdevapi
	@echo "$(GREEN)Generating application key...$(NC)"
	@$(DOCKER_COMPOSE) exec $(APP_CONTAINER) php artisan key:generate
	@echo "$(GREEN)Setup complete! Access the app at http://localhost$(NC)"

up:
	@echo "$(GREEN)Starting containers...$(NC)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Containers started!$(NC)"

down:
	@echo "$(GREEN)Stopping containers...$(NC)"
	@$(DOCKER_COMPOSE) down

build:
	@echo "$(GREEN)Building containers...$(NC)"
	@$(DOCKER_COMPOSE) build

shell:
	@$(DOCKER_COMPOSE) exec $(APP_CONTAINER) bash

artisan:
	@$(DOCKER_COMPOSE) exec $(APP_CONTAINER) php artisan $(cmd)

composer:
	@$(DOCKER_COMPOSE) exec $(APP_CONTAINER) composer $(cmd)

logs:
	@$(DOCKER_COMPOSE) logs -f

db-shell:
	@$(DOCKER_COMPOSE) exec $(DB_CONTAINER) bash
