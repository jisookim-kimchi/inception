#!/bin/sh

if [ ! -f "/var/www/html/wp-config.php" ]; then

echo "wordpress init........."
wp core download --allow-root --path=/var/www/html

# 2. DB 연결 설정 파일(wp-config.php) 생성
 wp config create \
    --allow-root \
    --path=/var/www/html \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=mariadb

# 3. WordPress 설치 (관리자 계정 생성)
wp core install \
    --allow-root \
    --path=/var/www/html \
    --url=${WP_URL} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}
fi
# PHP-FPM 서버 계속 실행 (이거 없으면 컨테이너 꺼짐!)
exec php-fpm82 -F
    
    


