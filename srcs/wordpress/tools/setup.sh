#!/bin/sh

if [ ! -f "/var/www/html/wp-config.php" ]; then

echo "waiting for mariadb..."
until mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 1
done
echo "mariadb is ready"


echo "wordpress init........."

php -d memory_limit=-1 /usr/local/bin/wp core download --allow-root --path=/var/www/html

php -d memory_limit=-1 /usr/local/bin/wp config create \
    --allow-root \
    --path=/var/www/html \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=${MYSQL_HOST}

sed -i "/table_prefix = 'wp_';/a \
define( 'WP_HOME', 'https://${DOMAIN_NAME}' );\n\
define( 'WP_SITEURL', 'https://${DOMAIN_NAME}' );\n\
define( 'FORCE_SSL_ADMIN', true );" /var/www/html/wp-config.php

echo "creating wordpress admin.........\n"
php -d memory_limit=-1 /usr/local/bin/wp core install \
    --allow-root \
    --path=/var/www/html \
    --url=${WP_URL} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}

echo "creating regular wordpress user.........\n"
php -d memory_limit=-1 /usr/local/bin/wp user create "${WP_USER}" "${WP_USER_EMAIL}"\
    --allow-root \
    --path=/var/www/html \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=author

fi

echo "--- CHECKPOINT: START COPYING ---"
cp -v /tmp/health.php /var/www/html/health.php
echo "--- CHECKPOINT: END COPYING ---"

chown -R www-data:www-data /var/www/html

REAL_FPM=$(which php-fpm || which php-fpm8 || ls /usr/sbin/php-fpm* | head -n 1)

echo "Starting WordPress FPM with: $REAL_FPM"

exec $REAL_FPM -F
