#!/bin/bash

echo "------------------------ check -----------------------------------------"
python manage.py check
echo "------------------------ migrate -----------------------------------------"
python manage.py migrate

echo "------------------------ collectstatic -----------------------------------------"
echo "yes" | python manage.py collectstatic
echo "------------------------ compilemessages -----------------------------------------"
python manage.py compilemessages
echo "------------------------ compilejsil8n -----------------------------------------"
python manage.py compilejsi18n
echo "------------------------ loaddata navbar -----------------------------------------"
python manage.py loaddata navbar
echo "------------------------ loaddata language_small -----------------------------------------"
python manage.py loaddata language_small
echo "------------------------ loaddata demo -----------------------------------------"
python manage.py loaddata demo
echo "------------------------ all done -----------------------------------------"

