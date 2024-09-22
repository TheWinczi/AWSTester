#!/bin/bash

sudo apt install --update
sudo apt install mysql-server

sudo systemctl start mysql

sudo mysql_secure_installation -Y
sudo mysql -e "CREATE DATABASE mysite"

echo "Creating local user"
sudo mysql -e "CREATE USER 'django'@'localhost' IDENTIFIED BY 'django123#'"
sudo -e "GRANT ALL PRIVILEGES ON mysite.* TO 'django'@'localhost' WITH GRANT OPTION"
sudo mysql -e "FLUSH PRIVILEGES"

echo "Creating remote user"
sudo mysql -e "CREATE USER 'django'@'%' IDENTIFIED BY 'Django123#'"
sudo -e "GRANT ALL PRIVILEGES ON mysite.* TO 'django'@'%' WITH GRANT OPTION"
sudo mysql -e "FLUSH PRIVILEGES"

echo "Changing configuration"
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql