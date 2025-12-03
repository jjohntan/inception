FROM debian:bookworm

RUN apt-get update -y && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

COPY ./tools/script.sh /tmp/script.sh

RUN chmod +x /tmp/script.sh

# the entrypoint script will run before mysqld
ENTRYPOINT ["bash", "/tmp/script.sh"]
