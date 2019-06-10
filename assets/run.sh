#!/bin/sh

python /app/init.py
#exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
/opt/activemq/bin/activemq console -Djava.rmi.server.hostname=1098
