COMPOSE=./srcs/docker-compose.yml
VOLUME_PATH=/home/jetan/data

all: up

build_dirs:
	@mkdir -p $(VOLUME_PATH)/wordpress
	@mkdir -p $(VOLUME_PATH)/database


up: build_dirs
	docker compose -f $(COMPOSE) up --build
   
down:
	docker compose -f $(COMPOSE) down

re: fclean all

clean: down
	@docker system prune --all --force

fclean: clean
	@sudo rm -rf $(VOLUME_PATH)/wordpress/*
	@sudo rm -rf $(VOLUME_PATH)/database/*

.PHONY: all up down re clean fclean