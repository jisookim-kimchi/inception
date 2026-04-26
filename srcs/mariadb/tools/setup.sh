#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then

 echo "DB init........."
 mysql_install_db --user=mysql --datadir=/var/lib/mysql

#init base db in Database 
    cat << EOF > /tmp/init.sql
USE mysql;            
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;

EOF

mysqld --user=mysql --bootstrap < /tmp/init.sql
rm -f /tmp/init.sql

fi

exec "$@"