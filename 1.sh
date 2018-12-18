#!/bin/bash

LOGS_DIR="/vagrant/logs"
echo -e "\n --- Find all logs in $LOGS_DIR ---\n"
rm -rf "$LOGS_DIR"
mkdir -p "$LOGS_DIR"
