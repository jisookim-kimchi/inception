FROM alpine:3.18

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
# Why change the name? /usr/local/bin is a collection of commands that can be executed from anywhere. So if it's there,
# wp core download 처럼 바로 실행 경로를 지정하지 않아도 돼.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY tools/setup.sh /setup.sh
COPY /health.php /tmp/health.php
COPY tools/www.conf /etc/php82/php-fpm.d/www.conf

RUN chmod +x /setup.sh

user = nobody
group = nobody

listen = 9000

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3

clear_env = no
EXPOSE 9000

CMD ["sh", "/setup.sh"]