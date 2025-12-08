FROM debian:bookworm

RUN apt-get update -y && apt-get install -y php-fpm php-mysql curl && rm -rf /var/lib/apt/lists/*

COPY ./tools/script.sh .

RUN chmod +x script.sh

ENTRYPOINT ["bash", "script.sh"]
