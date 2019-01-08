#!/bin/bash

LOGS_DIR="/dmoj/logs"

mkdir -p /dmoj/files
cd /dmoj/files
cp /dmoj-site-docker/files/* .
curl -s http://uwsgi.it/install | bash -s default "$PWD/uwsgi" >> "$LOGS_DIR/uwsgi.log"

echo -e "\n --- Setup Supervisor and nginx ---\n"
{
	touch /dmoj/bridge.log
	chmod 666 /dmoj/bridge.log

	cp site.conf /etc/supervisor/conf.d/site.conf
	cp bridged.conf /etc/supervisor/conf.d/bridged.conf
	cp nginx.conf /etc/nginx/conf.d/nginx.conf
	#sed -i 's|# server_names_hash_bucket_size 64;|server_names_hash_bucket_size 265;|g' /etc/nginx/nginx.conf

	systemctl restart supervisor
	systemctl restart nginx
} >> "$LOGS_FILE/setup-supervisor-nginx.log"
