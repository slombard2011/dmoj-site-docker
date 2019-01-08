#!/bin/bash

LOGS_DIR="/dmoj/logs"

cd /dmoj/site

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
