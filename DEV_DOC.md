# Inception Developer Guide

## 1. Setup
Before running the project, make sure you have:
- Docker and docker-compose installed.
- Your domain name mapped in your `/etc/hosts` file (e.g., add `127.0.0.1 jisokim2.42.fr`).
- An `.env` file in the `srcs/` directory. You have to create this yourself with variables like database name, passwords, and domain name. Make sure it's ignored by git.

## 2. Build and run
Everything is managed by the Makefile.

To build the images and run the containers:
```bash
make
```
This command automatically creates the data folders on the host if they don't exist and runs `docker-compose up`.

To clean up containers:
```bash
make clean
```

To completely wipe everything (including data volumes):
```bash
make fclean
```

## 3. Useful commands
If you need to debug something:
- `docker logs <container_name>` : shows the logs of a container
- `docker exec -it <container_name> sh` : opens a shell inside the container
- `docker volume ls` : lists all docker volumes

## 4. Data persistence
When containers are deleted, their data is usually lost. To prevent this, this project uses Docker bind mounts.

The data is stored on the host machine here:
- `/home/jisokim2/data/mariadb` (for the database)
- `/home/jisokim2/data/wordpress` (for website files)

The `docker-compose.yaml` links these host directories to the local volumes. So even if you stop or remove the containers, the actual data stays safe in the `/home/jisokim2/data` folder and will be loaded again next time you start the project.
