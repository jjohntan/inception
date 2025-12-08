#!/bin/bash

# create the folder for ssl certificates
mkdir -p /etc/nginx/ssl

# generate the ssl certificate
echo "Generating SSL Certificate..."

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=MY/ST=Selangor/L=SubangJaya/O=42/OU=Student/CN=jetan.42.fr"

echo "SSL Certificate generated."

# start nginx
# daemon off keeps nginx running in the foreground so docker doesn't exit
echo "Starting NGINX..."
exec nginx -g "daemon off;"