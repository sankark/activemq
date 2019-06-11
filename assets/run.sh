#!/bin/sh

python /app/init.py
#exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
IP=$(hostname -i)
/opt/activemq/bin/activemq console -Djava.rmi.server.hostname=$IP -Dcom.sun.management.jmxremote.rmi.port=1098 -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote
