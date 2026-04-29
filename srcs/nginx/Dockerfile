FROM alpine:3.18

WORKDIR /var/www/html


RUN addgroup -g 82 -S www-data && \
    adduser -u 82 -D -S -G www-data www-data
RUN apk update && \
    apk add --no-cache nginx openssl

# SSL certificate generation
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/CN=jisokim2.42.fr"

# Nginx configuration file copy
COPY tools/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx && \
    chown -R www-data:www-data /var/www/html /run/nginx /var/lib/nginx 

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]



