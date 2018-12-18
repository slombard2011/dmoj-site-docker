#!/bin/bash

LOGS_DIR="/vagrant/logs"
echo -e "\n --- Installing and Setting up MySQL ---\n"
{
	echo "mysql-server mysql-server/root_password password vagrant"       | debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password vagrant" | debconf-set-selections

	apt-get -y install mysql-server libmysqlclient-dev

# echo -e "\n--- Setting up our MySQL user and db ---\n"
	mysql -uroot -pvagrant -e "CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci"
	mysql -uroot -pvagrant -e "grant all privileges on dmoj.* to 'vagrant'@'localhost' identified by 'vagrant'"

	systemctl restart mysql
} >> "$LOGS_DIR/mysql.log"
