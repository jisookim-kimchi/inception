FROM alpine:3.23

WORKDIR /var/www/html

RUN if [ -z "$(getent group www-data)" ]; then addgroup -g 82 -S www-data; fi && \
    if [ -z "$(getent passwd www-data)" ]; then adduser -u 82 -D -S -G www-data www-data; fi

RUN apk update && \
    apk add --no-cache\
    php \
    php-fpm \
    php-mysqli \
    php-json \
    php-curl \
    php-dom \
    php-mbstring \
    php-xml \
    php-phar \
    php-iconv \
    mariadb-client \
    wget

ENV WP_CLI_PHP_ARGS="-d memory_limit=-1"

RUN mkdir -p /etc/php/conf.d && echo "memory_limit = 512M" > /etc/php/conf.d/memory.ini

# Install wp-cli (WordPress automatic installation tool)
# Why change the name? /usr/local/bin is a collection of commands that can be executed from anywhere. 
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /etc/php/php-fpm.d
COPY tools/www.conf /etc/php/php-fpm.d/www.conf
COPY tools/setup.sh /setup.sh
COPY health.php /tmp/health.php

RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["sh", "/setup.sh"]

CMD ["php-fpm", "-F"]
