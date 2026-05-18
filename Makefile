name = inception

all:
	@echo "----------------------setup config----------------------\n"
	@mkdir -p /home/jisokim2/data/mariadb
	@mkdir -p /home/jisokim2/data/wordpress
	@docker-compose -f srcs/docker-compose.yaml up -d --build

up:
	@echo "----------------------starting----------------------\n"
	@docker-compose -f srcs/docker-compose.yaml up -d

down:
	@echo "----------------------stopping----------------------\n"
	@docker-compose -f srcs/docker-compose.yaml down

logs:
	@echo "---------------------showing logs ----------------------\n"
	@docker-compose -f srcs/docker-compose.yaml logs

clean: down
	@echo "----------------------cleaning----------------------\n"
	@docker system prune -a --force

fclean: clean
	@echo "----------------------fclean----------------------\n"
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@sudo rm -rf /home/jisokim2/data/mariadb/*
	@sudo rm -rf /home/jisokim2/data/wordpress/*

re: fclean all

.PHONY: all up down clean fclean re
