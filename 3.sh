#!/bin/bash

LOGS_DIR="/vagrant/logs"
echo -e "\n --- Installing Node.js ---\n"
{
	curl -sL https://deb.nodesource.com/setup_6.x | bash -
	apt-get install -y nodejs
} >> "$LOGS_DIR/node.js.log"
