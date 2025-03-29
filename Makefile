# Используем переменную в нижнем регистре, но присваиваем её в верхнюю
name ?= my-app
NAME := $(name)

# Создание нового Laravel-проекта
new:
	docker compose run --rm laravel create-project --prefer-dist laravel/laravel $(NAME)
