#!/bin/bash

LOGS_DIR="/vagrant/logs"
echo -e "\n --- Installing apt-get dependencies ---\n"
{
	apt-get update
	apt-get install -y nano supervisor nginx git gcc g++ make python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev ruby-sass gettext curl

	pip install --upgrade pip
} >> "$LOGS_DIR/dependencies.log"
