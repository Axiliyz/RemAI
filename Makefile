include .env
export

.PHONY: docker-build docker-up docker-down docker-restart docker-logs
.PHONY: migrate-create migrate-up migrate-down migrate-action

APP_NAME := RemAI
DOCKER_COMPOSE := docker compose -f deployments/docker-compose.yml

# INFRA

docker-build:
	@$(DOCKER_COMPOSE) build
	@$(DOCKER_COMPOSE) up -d

docker-up:
	@$(DOCKER_COMPOSE) up -d

docker-down:
	@$(DOCKER_COMPOSE) down

docker-restart:
	@$(DOCKER_COMPOSE) restart

docker-logs:
	@$(DOCKER_COMPOSE) logs -f

# GOLANG

run:
	@set -a; . ./.env; set +a; go run ./cmd/api

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

# MIGRATIONS

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "отсутствует параметр seq, пример: make migrate-create seq=init"; \
		exit 1; \
	fi
	@$(DOCKER_COMPOSE) run --rm migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq $(seq)

migrate-up:
	@$(MAKE) migrate-action action=up
migrate-down:
	@$(MAKE) migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "отсутствует параметр action, пример: make migrate-action action=up"; \
		exit 1; \
	fi
	@$(DOCKER_COMPOSE) run --rm migrate \
		-path /migrations \
		-database "postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@postgres:5432/$(POSTGRES_DB)?sslmode=disable" \
		$(action)