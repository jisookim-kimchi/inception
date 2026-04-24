

## design
3 tier architecture
```
  Browser <----------> Nginx <---------> WordPress/PHP-FPM <---------> MariaDB
           :443               :9000                          :3306
           HTTPS               FastCGI                        TCP
           (external)         (internal)                    (internal)
```

## Nginx
  reverse proxy: 1.client -> nginx
                  2.nginx -> wordpress
                  3.wordpress -> nginx-> client
  load balancer: distributes incoming requests across multiple servers.
                client1 -> order kimchi request -> A kitchen
                client2 -> order pasta request -> B kitchen
                client3 -> order kimbap request -> C kitchen
                [waiter]
## mariaDB
  Database, smart,large Excel file.
                [food warehouse]
## Wordpress and PHP
  Web template, CMS(content management system)
  depends on mariadb, because Wordpress can't itself store data.
                [chef]
  PHP is a web programming language.
  Wordpress engine.
  it is like a transfer, it check the sender(Wordpress)'s packet number and send it to the receiver(mariaDB).
                [cooking system, cooking infra]


## docker-compose.yaml

```yaml
version: '3'

services:
  # define where are containers (e.g. nginx, wordpress, mariadb, ftp)

networks:
  # define how the containers talk to each other.
  # bridge : most common type of network in docker. It is a private network that is created by Docker.

volumes:
  # persistent storage (data isn't lost when container is deleted or stop)
  # then where is my data? docker will automatically create a hidden folder for it on host machine to store the data.

```

## Alpine vs Debian
* **Alpine** is designed to be tiny. A blank Alpine container is only about 5 MB.
* **Debian** is a full-featured operating system. A blank Debian container is around 115 MB.

Alpine takes up way less hard drive space and downloads instantly. So I will take it.

**Note:** Alpine uses `apk add` instead of `apt-get install`.

## volume
**WordPress** (PHP-FPM) needs the website files so it can execute the PHP code.

**Nginx** needs the exact same website files so it can send images, CSS, and HTML directly to client.
Because they both need access to the exact same files, we create a shared folder (a Docker Volume) and mount it into both containers, in this case at /var/www/html

**MariaDB** uses a separate volume to persist database data independently from the application containers.

**Orders and dishes are continuously created and disappear, while ingredients (data) are permanently stored in the warehouse (MariaDB).**

