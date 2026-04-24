FROM alpine:3.18

RUN apk update && \
    apk add --no-cache nginx openssl

# SSL certificate generation
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/CN="
# Nginx configuration file copy
COPY tools/nginx.conf /etc/nginx/nginx.conf

# HTTPS port for encrypted communication
EXPOSE 443

# Nginx execution
CMD ["nginx", "-g", "daemon off;"]

