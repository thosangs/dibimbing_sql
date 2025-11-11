FROM postgres:17

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget curl unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY init-dvdrental.sh /docker-entrypoint-initdb.d/init-dvdrental.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-dvdrental.sh

COPY dvdrental.zip /docker/dvdrental.zip

