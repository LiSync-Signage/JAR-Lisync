
FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=urubu100     MYSQL_DATABASE=lisyncDB     MYSQL_USER=Ubuntu     MYSQL_PASSWORD=urubu100

COPY ./arquivos-sql/ /docker-entrypoint-initdb.d/
COPY ./arquivos-sql/ /tabelas/

EXPOSE 3306

