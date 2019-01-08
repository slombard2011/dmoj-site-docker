#!/bin/bash

LOGS_DIR="/dmoj/logs"

{
	cd "$SITE_DIR"

	npm install
	
	#required in order to be run behind corporate proxy
	git config --global url."https://github.com/".insteadOf git@github.com
	git config --global url."https:".insteadOf git:

	pip install -r requirements.txt
	pip install mysqlclient
	pip install websocket-client

	cp $FILES_DIR/local_settings.py /dmoj/site/dmoj/local_settings.py

	

} >> "$LOGS_DIR/setup-app.log"
