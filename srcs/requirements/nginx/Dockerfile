FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

COPY ./tools/script.sh .

RUN chmod +x script.sh 

ENTRYPOINT ["bash", "script.sh"]
