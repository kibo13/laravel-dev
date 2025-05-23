# Load variables from .env.make if it exists
-include .env.make
export $(shell sed 's/=.*//' .env.make)

# Set project name (default: PROJECT_NAME from .env.make)
NAME := $(or $(name), $(PROJECT_NAME))
NAME ?= laravel

# Create a new Laravel project
po-new:
	docker compose run --rm laravel composer create-project --prefer-dist laravel/laravel $(NAME)
	@echo "✅ Laravel project $(NAME) created successfully!"

# Add WWWUSER and WWWGROUP to the .env of a specific project
po-env:
	@if [ -z "$(name)" ]; then \
		echo "❌ Project name is required. Use: make po-env name=your_project"; \
		exit 1; \
	fi
	@if [ ! -f "$(name)/.env" ]; then \
		echo "❌ .env file not found in $(name)! Run 'cp $(name)/.env.example $(name)/.env' first."; \
		exit 1; \
	fi
	@if [ -s "$(name)/.env" ] && [ "$(shell tail -c 1 $(name)/.env)" != "" ]; then \
		echo "" >> "$(name)/.env"; \
	fi
	@if ! grep -q "^WWWUSER=" $(name)/.env; then echo "\nWWWUSER=$(shell id -u)" >> $(name)/.env; fi
	@if ! grep -q "^WWWGROUP=" $(name)/.env; then echo "WWWGROUP=$(shell id -g)" >> $(name)/.env; fi
	@echo "✅ Added WWWUSER and WWWGROUP to $(name)/.env!"

# Install Sail with predefined services and exit after installation
po-install:
	@if [ -z "$(name)" ]; then \
		echo "❌ Project name is required. Use: make po-install name=your_project"; \
		exit 1; \
	fi
	docker run --rm -i -v $(PWD)/$(name):$(CONTAINER_PATH) -w $(CONTAINER_PATH) $(DOCKER_IMAGE) bash -c "php artisan sail:install --no-interaction --with=$(SAIL_SERVICES)"
	@echo "✅ Sail installed with services: $(SAIL_SERVICES)."

# Open a shell inside the container
po-sh:
	@if [ -z "$(name)" ]; then \
		echo "❌ Project name is required. Use: make po-sh name=your_project"; \
		exit 1; \
	fi
	docker run --rm -it -v $(PWD)/$(name):$(CONTAINER_PATH) -w $(CONTAINER_PATH) $(DOCKER_IMAGE) bash
	@echo "✅ Opened shell inside $(name) container."

# Initialize a Laravel project (run po-new, po-env, po-install sequentially)
po-init:
	@$(MAKE) po-new name=$(NAME)
	@$(MAKE) po-env name=$(NAME)
	@$(MAKE) po-install name=$(NAME)
	@echo "✅ Laravel project $(NAME) fully initialized!"