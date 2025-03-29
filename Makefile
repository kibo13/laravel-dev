# Load variables from .env.make if it exists
-include .env.make
export $(shell sed 's/=.*//' .env.make)

# Set project name (default: PROJECT_NAME from .env.make)
NAME := $(or $(name), $(PROJECT_NAME))
NAME ?= laravel

# Create a new Laravel project
sail-new:
	docker compose run --rm laravel composer create-project --prefer-dist laravel/laravel $(NAME)

# Open a shell inside the container (optionally run Sail installation)
sail-sh:
	@if [ -z "$(NAME)" ]; then \
		echo "❌ Project name is required. Use: make sail-sh name=your_project [install=1]"; \
		exit 1; \
	fi
	docker run --rm -it -v $(PWD)/$(NAME):$(CONTAINER_PATH) -w $(CONTAINER_PATH) $(DOCKER_IMAGE) bash -c "$(if $(install),php artisan sail:install &&) bash"
