#!/bin/bash

LOGS_DIR="/vagrant/logs"

echo -e "Superuser created!"

mkdir -p /vagrant/files
cd /vagrant/files

curl -s http://uwsgi.it/install | bash -s default "$PWD/uwsgi" >> "$LOGS_DIR/uwsgi.log"

echo -e "\n --- Setup Supervisor and nginx ---\n"
{
	touch /vagrant/bridge.log
	chmod 666 /vagrant/bridge.log

	cp $FILES_DIR/site.conf /etc/supervisor/conf.d/site.conf
	cp $FILES_DIR/bridged.conf /etc/supervisor/conf.d/bridged.conf
	cp $FILES_DIR/nginx.conf /etc/nginx/conf.d/nginx.conf
	sed -i 's|# server_names_hash_bucket_size 64;|server_names_hash_bucket_size 265;|g' /etc/nginx/nginx.conf

	systemctl restart supervisor
	systemctl restart nginx
} >> "$LOGS_FILE/setup-supervisor-nginx.log"
