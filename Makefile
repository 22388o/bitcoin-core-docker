# Bitcoin core on Docker

compose := docker compose

build: ## Build Bitcoin core on Docker
	$(compose) build
up: ## Start the stack
	$(compose) up
down: ## Stop the stack
	$(compose) down
help: ## Print this help
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
