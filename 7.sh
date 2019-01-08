#!/bin/bash

LOGS_DIR="/dmoj/logs"


echo -e "\n --- Setup virtualenv ---\n"
{
	pip install virtualenv
	rm -rf "$VIRTUALENV_PATH"
	mkdir -p "$VIRTUALENV_PATH"

	virtualenv -p python "$VIRTUALENV_PATH"

	chown -R dmoj:dmoj "$VIRTUALENV_PATH"
} >> "$LOGS_DIR/virtualenv-setup.log"
