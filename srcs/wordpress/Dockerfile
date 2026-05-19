FROM alpine:3.23

WORKDIR /var/www/html

RUN if [ -z "$(getent group www-data)" ]; then addgroup -g 82 -S www-data; fi && \
    if [ -z "$(getent passwd www-data)" ]; then adduser -u 82 -D -S -G www-data www-data; fi

RUN apk update && \
    apk add --no-cache\
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-mbstring \
    php82-xml \
    php82-phar \
    php82-iconv \
    mariadb-client \
    wget

# Link php82 command to php (wp-cli(WordPress command-line tool) uses php command!)
# Alpine installs php82, but wp-cli looks for php command, so we create a link.
RUN ln -s /usr/bin/php82 /usr/bin/php

RUN echo "memory_limit = 256M" > /etc/php82/conf.d/memory.ini

# Install wp-cli (WordPress automatic installation tool)
# Why change the name? /usr/local/bin is a collection of commands that can be executed from anywhere. 
# So if it's there, wp core download 처럼 바로 실행 경로를 지정하지 않아도 돼.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY tools/www.conf /etc/php82/php-fpm.d/www.conf
COPY tools/setup.sh /setup.sh
COPY health.php /tmp/health.php

RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["sh", "/setup.sh"]

CMD ["php-fpm82", "-F"]