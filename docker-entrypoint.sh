#!/bin/bash

LOGS_DIR="/dmoj/logs"
echo -e "\n --- starting up  ---\n"
{
	echo "------------------------ check -----------------------------------------"
	python manage.py check
	echo "------------------------ makestyle -----------------------------------------"
	./make_style.sh
	echo "------------------------ collectstatic -----------------------------------------"
	echo "yes" | python manage.py collectstatic
	echo "------------------------ compilemessages -----------------------------------------"
	python manage.py compilemessages
	echo "------------------------ compilejsil8n -----------------------------------------"
	python manage.py compilejsi18n
	echo "------------------------ migrate -----------------------------------------"
	python manage.py migrate
	echo "------------------------ loaddata navbar -----------------------------------------"
	python manage.py loaddata navbar
	echo "------------------------ loaddata language_small -----------------------------------------"
	python manage.py loaddata language_small
	echo "------------------------ loaddata demo -----------------------------------------"
	python manage.py loaddata demo
	#echo "------------------------ create superuser -----------------------------------------"
	#python manage.py createsuperuser
	#echo "------------------------ runserver -----------------------------------------"
	#python manage.py runserver 0.0.0.0:8000 #should not be used in production
	chown dmoj-uwsgi -R /dmoj/site
	service nginx reload
	service nginx start
	service supervisor start
} >> "$LOGS_DIR/entrypoint.log"
echo "------------------------ all done -----------------------------------------"
while true ; do continue ; done #in order to prevent container from stopping after executing the script
