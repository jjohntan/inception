#!/bin/bash

# 1. Prepare environment
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# 2. Install Base Data (Only if missing)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Installing base MariaDB data..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
    echo "MariaDB data already exists."
fi

# 3. FIX PERMISSIONS (Run this EVERY time)
# We run the bootstrap block every startup to ensure the user 
# and the permissions are always correct (fixes Error 1130).
echo "Updating MariaDB permissions..."

mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- 1. Create the Database (Safe to run multiple times)
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- 2. Create the User (Safe to run multiple times)
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

-- 3. FORCE the password update (In case you changed .env)
ALTER USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

-- 4. FORCE the Root password update
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

-- 5. Grant Privileges (CRITICAL STEP)
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;
EOF

# 4. Start the server
echo "Starting MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0
