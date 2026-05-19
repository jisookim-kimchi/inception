#!/bin/sh

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

 echo "DB init........."
 mysql_install_db --user=mysql --datadir=/var/lib/mysql

cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
ALTER USER 'kimchi'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; 
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

chown mysql:mysql /tmp/init.sql

mysqld --user=mysql --bootstrap < /tmp/init.sql
 
rm -f /tmp/init.sql


fi

exec "$@"