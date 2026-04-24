FROM alpine:3.18

RUN apk update && \
    apk add --no-cache nginx openssl

# SSL 인증서 생성
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/CN="
# Nginx 설정 파일 복사
COPY tools/nginx.conf /etc/nginx/nginx.conf

# HTTPS port 암호화된 통신을 위한 포트
EXPOSE 443

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]

