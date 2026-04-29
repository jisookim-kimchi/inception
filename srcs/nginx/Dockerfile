FROM alpine:3.18

WORKDIR /var/www/html

ARG DOMAIN_NAME

RUN if ! getent group www-data; then addgroup -g 82 -S www-data; fi && \
    if ! getent passwd www-data; then adduser -u 82 -D -S -G www-data www-data; fi && \
    apk update && \
    apk add --no-cache nginx openssl

# SSL certificate generation
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/CN=${DOMAIN_NAME}"

# Nginx configuration file copy
COPY tools/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx && \
    chown -R www-data:www-data /var/www/html /run/nginx /var/lib/nginx 

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]



