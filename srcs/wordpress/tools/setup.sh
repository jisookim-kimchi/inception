#!/bin/sh

if [ ! -f "/var/www/html/wp-config.php" ]; then

echo "waiting for mariadb..."
until mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 1
done
echo "mariadb is ready"


echo "wordpress init........."
wp core download --allow-root --path=/var/www/html

 wp config create \
    --allow-root \
    --path=/var/www/html \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=${MYSQL_HOST}

wp core install \
    --allow-root \
    --path=/var/www/html \
    --url=${WP_URL} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}
wp config set WP_HOME "https://${DOMAIN_NAME}" --allow-root --path=/var/www/html
wp config set WP_SITEURL "https://${DOMAIN_NAME}" --allow-root --path=/var/www/html
fi

echo "--- CHECKPOINT: START COPYING ---"
cp -v /tmp/health.php /var/www/html/health.php
echo "--- CHECKPOINT: END COPYING ---"

chown -R www-data:www-data /var/www/html

exec "$@"
    
    


