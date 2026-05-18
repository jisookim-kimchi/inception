# Inception Developer Guide

## 1. Setup
Before running the project, make sure you have:
- Docker and docker-compose installed.
- Your domain name mapped in your `/etc/hosts` file (add `127.0.0.1 jisokim2.42.fr`) on Hostmachine.
- An `.env` file in the `srcs/` directory.
  You have to create this yourself with variables but make sure it's ignored by git.

```
env variables:
- MYSQL_HOST=
- MYSQL_ROOT_PASSWORD=
- MYSQL_DATABASE=
- MYSQL_USER=
- MYSQL_PASSWORD=
- WP_URL=
- WP_TITLE=
- WP_ADMIN=
- WP_ADMIN_PASSWORD=
- WP_ADMIN_EMAIL=
- DOMAIN_NAME=
```

## 2. Build and run
Everything is managed by the Makefile.
But you can use also docker-compose commands.

To build the images and run the containers:
```
make all
```

To run the containers :
```
make up
```

To see logs
```
make logs
```

To service down:
```
make down
```

To clean up containers:
```
make clean
```

To completely clean everything (including data volumes):
```
make fclean
```

## 3. Useful commands
If you need to debug something:
- `docker logs <container_name>` : shows the logs of a container
- `docker exec -it <container_name> sh` : opens a shell inside the container
- `docker volume ls` : lists all docker volumes
- `docker ps` : lists all currently running containers
- `docker stats` : displays a live stream of container resource usage statistics (CPU, RAM)
- `docker system df` : shows how much disk space Docker is using (images, containers, volumes)
- `docker inspect <container_name>` : shows detailed low-level information (IP addresses, mounts, etc.)
- `docker port <container_name>` : lists port mappings for the container
- `docker network ls` / `docker network inspect <network_name>` : lists networks / shows detailed info about a specific network
- `docker compose -f <path> top` : displays the running processes of all containers in the compose file.
- `docker run --rm --network <network_name> alpine nslookup <service_name>` : tests internal DNS resolution to check if containers can see each other on a specific network

## 4. Data persistence
When containers are deleted, their data is usually lost.  
To prevent this, this project uses Docker bind mounts.

The data is stored on the host machine here:
- `/home/jisokim2/data/mariadb` (for the database)
- `/home/jisokim2/data/wordpress` (for website files)

The `docker-compose.yaml` links these host directories to the local volumes. 
So even if you stop or remove the containers, the actual data stays safe in the `/home/jisokim2/data` folder and will be loaded again next time you start the project.
