name = inception

all:
	@printf "----------------------setup config----------------------\n"
	@mkdir -p /home/jisokim2/data/mariadb
	@mkdir -p /home/jisokim2/data/wordpress
	@docker-compose -f srcs/docker-compose.yaml up -d --build

up:
	@printf "----------------------starting----------------------\n"
	@docker-compose -f srcs/docker-compose.yaml up -d

down:
	@printf "----------------------stopping----------------------\n"
	@docker-compose -f srcs/docker-compose.yaml down

logs:
	@printf "---------------------showing logs ----------------------\n"
	@docker-compose -f srcs/docker-compose.yaml logs

clean: down
	@printf "----------------------cleaning----------------------\n"
	@docker system prune -a --force

fclean: clean
	@printf "----------------------fclean----------------------\n"
	@docker volume rm $$(docker volume ls -q) || true
	@rm -rf /home/jisokim2/data/mariadb/*
	@rm -rf /home/jisokim2/data/wordpress/*

re: fclean all

.PHONY: all up down clean fclean re
