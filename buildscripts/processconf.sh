#!/bin/bash

LOGS_DIR="/dmoj/logs"
echo -e "\n --- Configuring nginx and supervisor ---\n"
{
	cp /dmoj-site-docker/files/site.conf /etc/supervisor/conf.d/site.conf
	cp /dmoj-site-docker/files/bridged.conf /etc/supervisor/conf.d/bridged.conf
	cp /dmoj-site-docker/files/wsevent.conf /etc/supervisor/conf.d/wsevent.conf
	cp /dmoj-site-docker/files/config.js /dmoj/site/websocket/

	cp /dmoj-site-docker/files/nginx.conf /etc/nginx/conf.d/
	rm /etc/nginx/sites-available/default
	rm /etc/nginx/sites-enabled/default
	cp /dmoj-site-docker/files/default /etc/nginx/sites-available/
	cp /dmoj-site-docker/files/default /etc/nginx/sites-enabled/
} >> "$LOGS_DIR/processconf.log"
