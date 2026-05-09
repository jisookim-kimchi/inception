## design
3 tier architecture

```
  Browser <----------> Nginx <---------> WordPress/PHP-FPM <---------> MariaDB
           :443               :9000                          :3306
           HTTPS               FastCGI                        TCP
           (external)         (internal)                    (internal)
```

## Container
I did practice making a Container without Docker.  
[container-build](https://github.com/jisookim-kimchi/container-build)


## Nginx(Waiter)
  reverse proxy: 1.client -> nginx  
                  2.nginx -> wordpress  
                  3.wordpress -> nginx-> client  
  
  load balancer: distributes incoming requests across multiple servers.  
                client1(waiter1) -> order kimchi request -> A kitchen  
                client2(waiter2) -> order pasta request -> B kitchen  
                client3(waiter3) -> order kimbap request -> C kitchen  

## mariaDB(Food Storage)
  Database, smart,large Excel file.

## Wordpress(Chef) and PHP(Cooking System, Cooking infra)
  Web template, CMS(content management system)
  depends on mariadb, because Wordpress can't itself store data.  
  PHP is a web programming language.  
  Wordpress is a engine.
  it is like a transfer, it check the sender(Wordpress)'s packet number and send it to the receiver(mariaDB).


## docker-compose.yaml

```yaml
version: '3'

services:
  define where are containers (e.g. nginx, wordpress, mariadb, ftp)

networks:
  define how the containers talk to each other.
  bridge : most common type of network in docker. It is a private network that is created by Docker.

volumes:
  persistent storage (data isn't lost when container is deleted or stop)
  then where is my data? docker will automatically create a hidden folder for it on host machine to store the data.

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
curl -k https://jisookim2.42.fr/health

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

### 1. MariaDB init.sql file 
  Why create a temporary file(init.sql) and pass it to bootstrap?

  In order to connect, the root password must already be set.  
  But at the time of initial installation, there is no password.  
  So i take the method of setting the password and user in advance before the server opens its doors to the outside (bootstrap)
  
### 2.MariaDB vs Wordpress race condition
Solution : 
  echo "waiting for mariadb..."
  until mysqladmin ping -h "$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
  sleep 1
  done
  echo "mariadb is ready"

### 3.MariaDB user redefine problem
  Solution : CREATE USER '{MYSQL_USER}'@'%' IDENTIFIED BY '{MYSQL_PASSWORD}'; -> CREATED USER IF NOT EXISTS.  

### 4. Service Security (Least Privilege)
 To enhance security, PHP-FPM process is configured to run with the least privileged user, www-data.  
 which is the standard user for running web applications in Linux.  
 user = www-data  
 group = www-data  
 By using the www-data account, which has minimal system permissions, the potential damage is strictly limited to the WordPress directory.  

### 5. PHP-FPM Network Connectivity
 A Connection Refused error occurred when the Nginx container attempted to connect to the WordPress container.  
 The Nginx error log indicated a failure to connect to the upstream: "fastcgi://172.18.0.3:9000".  

Cause:
 The default PHP-FPM configuration (www.conf) was set to listen = 127.0.0.1:9000.  
 127.0.0.1 : Loopback

Problem:
 the default is Loopback so PHP-FPM ignored the request coming from Nginx container.

Solution:
 The listen directive was updated to bind to all network interfaces (0,0,0,0), allowing PHP-FPM to accept requests from other containers.

After: listen = 9000 

### 6. env variable reading issue
Cause :
 PHP-FPM's default setting is clearing all environment variables.

Solution :
 Add 'clear_env = no' in /etc/php82/php-fpm.d/www.conf

### 7. Domain Mismatch
Issue :
  The WordPress installation fails.
  
Cause :
  i tried to test on my laptop so i set to allow localhost in nginx.conf, but not in wordpress config.  
  the browser URL (localhost) does not match the {WP_URL}, which is a env Variable in .env file and defined in the setup script.  
  i can see wordpress pagewhen i go with localhost, it works fine.  
  but when i go to Wordpress installation page, it fails because in wordpress config, i set the URL to ${WP_URL} which is https://jisokim2.42.fr

Solution:
  i add also localhost for testing.(currently i change to jisokim2.42.fr)

## !!!IMPORTANT Principle of Least Privilege!!!
### 8.User management and permission.

#### Why UID 82 (www-data) Synchronization is important
Ownership management of shared volumes is the most critical part of this project.  

Preventing 'Permission Denied': The Linux identifies permissions by UID (User ID).  
Since Nginx and WordPress share a 'volume', their UIDs must be same to 82 to ensure seamless file access.  
Container default's User is root (UID 0), so when Nginx or WordPress tries to write files as root, it is   
really dangerous.  
It is dangerous because files created by root inside the container are also owned by root on the host machine.

### 9. Port Forwarding.
Since the VM uses a virtual NIC in NAT mode, the host and VM are in different network Area.  
To expose services running in the VM to the host, VirtualBox performs NAT port forwarding (destination port translation).  
1. [L7] browser requests https://localhost:8080.  
2. Port Forwarding VirtualBox NAT rewrites : Localhost:8080 -> VM:443.  
3. [L4] TCP segment is created with 443 Port.  
4. [L3] IP packet is forwarded with VM as destination IP.  
5. VM receives Packet.  
6. [L7] nginx accepts and processes request.