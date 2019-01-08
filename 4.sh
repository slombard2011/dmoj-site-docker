#!/bin/bash

LOGS_DIR="/dmoj/logs"
{
	echo -e "pleeease-cli is not installed\n"
	npm install -g pleeease-cli
} >> "$LOGS_DIR/node.js-packages.log"
