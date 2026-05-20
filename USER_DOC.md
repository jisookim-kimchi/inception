# Inception User Guide

## 1. Services
This project runs three main services using Docker:
- Nginx: A web server that only allows HTTPS connections.
- WordPress: The website where you can post and manage content.
- MariaDB: The database that stores all the WordPress data.

## 2. How to start and stop
You can control the project using the Makefile in the `Inception` directory.

To build the images and run the containers:
```
make all
```

To run the containers :
```
make up
```

To service down:
```
make down
```

## 3. How to access the website
You can access the website through a web browser.  
Make sure your domain is set up in `/etc/hosts` on host machine.  

- Main website: https://jisokim2.42.fr
- Admin panel: https://jisokim2.42.fr/wp-admin

*Note: Since the SSL certificate is self-signed, your browser will probably show a security warning.  
You can just click "proceed" or "advanced" to bypass it.  

## 4. Credentials
The passwords and database users are set using environment variables. 
You must set up your own `.env` file in the `srcs/` folder.
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
- WP_USER=
- WP_USER_EMAIL=
- WP_USER_PASSWORD=
- DOMAIN_NAME=
```

## 5. Checking the status
If you want to check if the services are running, go to the `srcs` folder and run:
```bash
docker-compose ps
```
You should see nginx, wordpress, and mariadb running.
