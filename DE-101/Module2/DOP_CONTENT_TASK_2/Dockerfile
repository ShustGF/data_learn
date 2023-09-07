FROM postgres:14

RUN apt-get update && apt-get install -y nano vim curl wget

COPY ./table ./table


ENV POSTGRES_PASSWORD=gfh0km
ENV POSTGRES_USER=dl_user
ENV POSTGRES_DB=superstore


EXPOSE 5432

COPY ./Commands.sql /docker-entrypoint-initdb.d/Commands.sql


