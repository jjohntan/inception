#!/bin/bash

# prepare the directory for the database socket
# so mysqld can communicate locally
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# check if the database is already exists
# if the mysql folder is missing, the volume is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    
    echo "Initializing database..."

    # install the base database files
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # start mariadb in bootstrap mode to run sql commands directly
    # this runs the commands and exits automatically
    # reload the permissions so changes happen right now
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Set the root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

-- Create the WordPress database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- Create the user and grant permission from ANY host (%)
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;
EOF

    echo "Database configured."
fi

# start the server in the foreground
# bind-address=1.0.0.0 allows connections from other containers(wordpress)
echo "Starting MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0
