#!/bin/bash

LOGS_DIR="/dmoj/logs"

echo -e "\n --- Checkout web app --- \n"
{
	git clone https://github.com/DMOJ/site.git "$SITE_DIR"
	cd "$SITE_DIR"
	git pull
	git submodule init
	git submodule update
} >> "$LOGS_DIR/checkout-app.log"

#echo -e "\n --- Setup web app ---\n"
#source "$VIRTUALENV_PATH/bin/activate"
