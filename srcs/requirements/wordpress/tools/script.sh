#!/bin/bash

# Install WP-CLI (Since it's not in the Dockerfile)
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Configure PHP-FPM (CRITICAL FIX)
# Debian Bookworm uses PHP 8.2. We must listen on port 9000, not a socket.
sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf
mkdir -p /run/php

# Navigate to volume
cd /var/www/html

sleep 5

# Main Installation Logic
if [ ! -f wp-config.php ]; then
    
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating Config..."
    # Note: Using standard .env variable names (MYSQL_...)
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_LOGIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    # Create Author User
    wp user create $WP_USER_LOGIN $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root
fi

# Start PHP-FPM
echo "Starting PHP-FPM 8.2..."
exec /usr/sbin/php-fpm8.2 -F
