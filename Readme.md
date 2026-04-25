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

## DNS
docker network inspect inception_intra

Docker automatically registers containers as DNS entries when they are attached to the same network.
Service name → internal DNS resolution
Docker DNS works based on the service name.

## DNS process
1. docker-compose up
2. Docker creates a network
3. Services are registered as DNS names
4. Containers communicate using service names instead of IP addresses

## health check test
https://jisookim2.42.fr/health

## SSL
  Security protocol
  encrypt internet communication
  HTTP doesn't encrypt data so data can be exposed to others.
  HTTPS encrypt data so data can't be exposed to others.

## Dockerfile
schematic for container image.

### Dockerfile Instruction
- **FROM** : base Image, OS
- **RUN** : Image build
- **ADD** : to Add a File or Directory from Host to Image
- **COPY** : to Copy a File or Directory from Host to Image (preferred),
    COPY just only copy as same as a file/directory, but ADD can extract tar, zip compressed file automatically.
- **EXPOSE** : to define port on host
- **ENV** : to define environment variables
- **CMD** : to Define a default command to run when the container starts available easy to change.
- **ENTRYPOINT** : same with CMD but Default command, static command to define main function in container
- **WORKDIR** : Set the working directory for the subsequent instructions
- **VOLUME** : to define a path to save persistent data, for non-volatile data


## Troubleshooting
### 1.MariaDB vs Wordpress race condition
  Solution : 
    echo "waiting for mariadb..."
    until mysqladmin ping -h "$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
        sleep 1
    done
    echo "mariadb is ready"

### 2.MariaDB user redefine problem
  Solution : CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; -> CREATED USER IF NOT EXISTS.

### 3. Service Security (Least Privilege)
To enhance security, PHP-FPM process is configured to run with the least privileged user, nobody.
user = nobody
group = nobody
By using the nobody account, which has minimal system permissions, the potential damage is strictly limited to the WordPress directory.

### 4. PHP-FPM Network Connectivity
A Connection Refused error occurred when the Nginx container attempted to connect to the WordPress container. The Nginx error log indicated a failure to connect to the upstream: "fastcgi://172.18.0.3:9000".

Cause:
The default PHP-FPM configuration (www.conf) was set to listen = 127.0.0.1:9000.
127.0.0.1 : Loopback

Problem: the default is Loopback so PHP-FPM ignored the request coming from Nginx container.

Solution:
The listen directive was updated to bind to all network interfaces (0,0,0,0), allowing PHP-FPM to accept requests from other containers.

After: listen = 9000 