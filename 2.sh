#!/bin/bash

LOGS_DIR="/vagrant/logs"
echo -e "\n --- Installing apt-get dependencies ---\n"
{
	apt-get update
	apt-get install -y nano supervisor nginx wget git build-essential python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev ruby-sass gettext curl libldap2-dev libsasl2-dev




	pip install --upgrade pip
} >> "$LOGS_DIR/dependencies.log"
