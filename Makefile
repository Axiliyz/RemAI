.PHONY: up down restart ps logs config db-shell test run build fmt vet lint check swagger
APP_NAME := RemAI


# INFRA
COMPOSE := docker compose --env-file .env -f deployments/docker-compose.yml

up:
	@$(COMPOSE) up -d

down:
	@$(COMPOSE) down

restart:
	@$(COMPOSE) restart

ps:
	@$(COMPOSE) ps -a

logs:
	@$(COMPOSE) logs -f

db-shell:
	@$(COMPOSE) exec postgres psql -U rem -d rem_ai

# GOLANG

run:
	@go run ./cmd/api

build:
	@go build -o bin/$(APP_NAME) ./cmd/api

test:
	@go test ./...

fmt:
	@go fmt ./...

vet:
	@go vet ./...

lint:
	@golangci-lint run ./...

check: fmt vet test lint

# SWAGGER

swagger:
	@go run github.com/swaggo/swag/cmd/swag@v1.16.6 init -g cmd/api/main.go -o docs