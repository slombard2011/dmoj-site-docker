#!/bin/bash

LOGS_DIR="/dmoj/logs"

echo -e "\n --- Installing PhantomJS ---\n"
{
	cd /opt
	wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
	tar xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
} >> "$LOGS_DIR/phantomjs.log"
