#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql}" ]; then

 echo "DB init........."
 mysql_install_db --user=mysql --datadir=/var/lib/mysql

#init base db in Database 
    cat << EOF > /tmp/init.sql

-- 방이름 이거는 /var/lib/mysql/mysql
USE mysql;            

-- 권한 새로고침 왜? 프로그램이 켜질 때 하드디스크에 있는 권한표를 복사해서 엄청나게 빠른 RAM(메모리 캐시)에 싹 다 올려놓는데 RAM(메모리)의 기억은 아직 예전 상태에 머물러 있는 경우가 생깁니다.
FLUSH PRIVILEGES;

-- root 비밀번호 변경 '아이디'@'접속위치'
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- 워드프레스 전용으로 쓸 "새로운 방(데이터베이스)" 만들기
 CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- 새로운 손님(사용자) 초대하기 % : 어디서든 다 접속 허용
 CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- 손님에게 "새로운 방(데이터베이스)"에 대한 모든 권한(열쇠) 주기
 GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- 4번에서 바뀐 권한을 즉시 적용하기 (이거 안 하면 적용 안 됨!)
 FLUSH PRIVILEGES;

EOF

mysqld --user=mysql --bootstrap < /tmp/init.sql
rm -f /tmp/init.sql

 fi

# 1. /tmp/init.sql 파일을 읽어서 실행합니다.
# 2. 실행이 끝나면, 원래 MariaDB가 하던 일(실제 DB 서버 구동)을 이어받아서 계속 실행합니다.
#    (이 exec 명령어가 없으면, setup.sh 스크립트만 실행되고 컨테이너가 바로 꺼져버립니다.)
exec mysqld --user=mysql