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
    wget

# php82 명령어를 php 로 링크 걸기 (wp-cli(워드프레스 전용 명령어 도구)가 php 명령어를 씁니다!)
# alpine 은 php82로 설치되는데, wp-cli는 php 명령어를 찾기 때문에 링크를 걸어줍니다.
RUN ln -s /usr/bin/php82 /usr/bin/php

# wp-cli 설치 (WordPress 자동 설치 도구)
# 왜 애름을 바꿔주냐? /usr/local/bin 폴더는 어디서든 실행할수 있는 명령어들의 집합소야. 그래서 거기있으면
# wp core download 처럼 바로 실행 경로를 지정하지 않아도 돼.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# setup.sh 스크립트 복사 및 권한 부여
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

# PHP-FPM 기본 포트
EXPOSE 9000

CMD ["sh", "/setup.sh"]