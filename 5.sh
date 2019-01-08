#!/bin/bash

LOGS_DIR="/dmoj/logs"
echo -e "\n --- Installing and Setting up MySQL ---\n"
{
	#echo "mysql-server mysql-server/root_password password dmoj"       | debconf-set-selections
	#echo "mysql-server mysql-server/root_password_again password dmoj" | debconf-set-selections

	apt-get -y install mysql-server libmysqlclient-dev

# echo -e "\n--- Setting up our MySQL user and db ---\n"
	#mysql -uroot -pdmoj -e "CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci"
	#mysql -uroot -pdmoj -e "grant all privileges on dmoj.* to 'dmoj'@'localhost' identified by 'dmoj'"

	#systemctl restart mysql
} >> "$LOGS_DIR/mysql.log"
