# Inception User Guide

## 1. Services
This project runs three main services using Docker:
- Nginx: A web server that only allows HTTPS connections.
- WordPress: The website where you can post and manage content.
- MariaDB: The database that stores all the WordPress data.

## 2. How to start and stop
You can control the project using the Makefile in the root directory.

To start everything:
```bash
make
```

To stop everything:
```bash
make down
```

## 3. How to access the website
You can access the website through a web browser. Make sure your domain is set up in `/etc/hosts`.

- Main website: https://jisokim2.42.fr
- Admin panel: https://jisokim2.42.fr/wp-admin

*Note: Since the SSL certificate is self-signed, your browser will probably show a security warning. You can just click "proceed" or "advanced" to bypass it.*

## 4. Credentials
The passwords and database users are set using environment variables. 
You can find them in the `.env` file located in the `srcs/` folder. This file contains the root passwords and admin credentials, so don't commit it to your repository.

## 5. Checking the status
If you want to check if the services are running, go to the `srcs` folder and run:
```bash
docker-compose ps
```
You should see nginx, wordpress, and mariadb running.
