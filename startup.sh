#!/bin/bash

#Start mysqld
service mysql start

#Start tomcat
JAVA_OPTS="$JAVA_OPTS -Dsecurity.method=jdbc -Xmx768M" /var/lib/tomcat7/bin/startup.sh

#So docker doesn't immediately quit
tail -f /var/lib/tomcat7/logs/*
