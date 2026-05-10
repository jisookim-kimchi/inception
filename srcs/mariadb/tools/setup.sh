#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql/$MYSQL_DATABASE" ]; then

 echo "DB init........."
 mysql_install_db --user=mysql --datadir=/var/lib/mysql

#init base db in Database 
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$');
FLUSH PRIVILEGES;

EOF


rm -f /tmp/init.sql

fi

exec "$@"