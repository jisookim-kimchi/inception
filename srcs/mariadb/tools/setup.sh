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

# 1. /tmp/init.sql 파일을 읽어서 실행합니다.
# 2. 실행이 끝나면, 원래 MariaDB가 하던 일(실제 DB 서버 구동)을 이어받아서 계속 실행합니다.
#    (이 exec 명령어가 없으면, setup.sh 스크립트만 실행되고 컨테이너가 바로 꺼져버립니다.)
exec mysqld --user=mysql --bind-address=0.0.0.0 --skip-networking=0