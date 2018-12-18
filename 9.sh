#!/bin/bash

LOGS_DIR="/vagrant/logs"

{
	cd "$SITE_DIR"

	npm install
	
	#required in order to be run behind corporate proxy
	git config --global url."https://github.com/".insteadOf git@github.com
	git config --global url."https:".insteadOf git:

	pip install -r requirements.txt
	pip install mysqlclient
	pip install websocket-client

	cp $FILES_DIR/local_settings.py /vagrant/site/dmoj/local_settings.py

	python manage.py check
	python manage.py migrate

	./make_style.sh

	echo "yes" | python manage.py collectstatic
	python manage.py compilemessages
	python manage.py compilejsi18n
	python manage.py loaddata navbar
	python manage.py loaddata language_small
	python manage.py loaddata demo

} >> "$LOGS_DIR/setup-app.log"
