FROM alpine:3.18
 
RUN apk update && \                           
    apk add --no-cache mariadb mariadb-client

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

# "Oh, I'm installing DB? I will secretly create a user and group named mysql in the system! And I will match all the configuration file names to this mysql!
# /run/mysqld : socket file directory
# /var/lib/mysql : data storage directory

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

EXPOSE 3306

CMD ["sh", "/setup.sh"]

# run : installation just once when build container
# CMD : excute whenever container starts