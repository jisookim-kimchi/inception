FROM alpine:3.18
 
RUN apk update && \
    apk add --no-cache mariadb mariadb-client

# 2. 호스트(내 컴퓨터)에 짜둔 스크립트 파일을 컨테이너 내부로 복사합니다.
COPY tools/setup.sh /setup.sh

# 3. 스크립트가 실행될 수 있게 권한을 부여합니다 (+x)
RUN chmod +x /setup.sh

# 4. MariaDB가 통신할 때 사용하는 소켓 파일이 들어갈 폴더를 미리 만들어줍니다.
#"오, DB를 설치하는구나? 내가 은밀하게 시스템에 mysql 이라는 이름의 유저와 그룹을 만들게! 그리고 모든 설정 파일 명의를 이 mysql한테 다 맞춰둘게!"
# /run/mysqld : 소켓 파일이 들어갈 폴더
# /var/lib/mysql : 데이터가 저장될 폴더

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# 5. MariaDB의 기본 포트인 3306번을 열어둡니다. (문서화 용도)
EXPOSE 3306

CMD ["sh", "/setup.sh"]


# run : installation just once when build container
# CMD : excute whenever container starts