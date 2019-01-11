#!/bin/bash

LOGS_DIR="/dmoj/logs"
echo -e "\n --- Installing dependencies ---\n"
{
	apt-get update
	apt-get install -y nano supervisor nginx wget git build-essential python-ldap python-django-auth-ldap python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev ruby-sass gettext curl libldap2-dev libsasl2-dev

	git clone https://github.com/ajaxorg/ace-builds
	chmod 755 -R /dmoj-site-docker/*


	pip install --upgrade pip
} >> "$LOGS_DIR/dependencies.log"
