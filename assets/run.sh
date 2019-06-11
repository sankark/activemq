#!/bin/sh

python /app/init.py
#exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
IP=$(hostname -i)
/opt/activemq/bin/activemq console -Djava.rmi.server.hostname=$IP
