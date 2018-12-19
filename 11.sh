#!/bin/bash

LOGS_DIR="/vagrant/logs"

cd /vagrant/site

{
	python manage.py check
	python manage.py migrate

	./make_style.sh

	echo "yes" | python manage.py collectstatic
	python manage.py compilemessages
	python manage.py compilejsi18n
	python manage.py loaddata navbar
	python manage.py loaddata language_small
	python manage.py loaddata demo
} >> "$LOGS_FILE/manage.py.log"
