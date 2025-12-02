FROM debian:bookworm

RUN apt-get update -y && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

#COPY ./tools/script.sh /tmp/script.sh

#RUN chmod +x /tmp/script.sh

# allow other containers to connect(wordpress)
# default mariadb listen only to itself
# replace 127.xxx with 0.xxx
#RUN sed -i "s/127.0.0.1/0.0.0.0" /etc/mysql/mariadb.conf.d/50-server.cnf

# the entrypoint script will run before mysqld
#ENTRYPOINT ["bash", "/tmp/script.sh"]

#CMD ["mysqld"]
