#!/bin/bash

LOGS_DIR="/vagrant/logs"


echo -e "\n --- Setup virtualenv ---\n"
{
	pip install virtualenv
	rm -rf "$VIRTUALENV_PATH"
	mkdir -p "$VIRTUALENV_PATH"

	virtualenv -p python "$VIRTUALENV_PATH"

	chown -R vagrant:vagrant "$VIRTUALENV_PATH"
} >> "$LOGS_DIR/virtualenv-setup.log"
