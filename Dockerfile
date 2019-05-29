FROM webcenter/activemq 

RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y iputils-ping
RUN apt-get install -y dnsutils
RUN apt-get install -y mysql-client-core-5.6


# Copy the app setting
COPY assets/config/activemq.xml /opt/activemq/conf/activemq.xml
COPY assets/config/log4j.properties /opt/activemq/conf/log4j.properties
COPY assets/init.py /app/init.py
COPY assets/run.sh /app/run.sh
RUN chmod +x /app/init.py
RUN chmod +x /app/run.sh

# Copy the Kubernetes discovery agent
COPY assets/activemq-k8s-discovery-1.0.2-jar-with-dependencies.jar /opt/activemq/lib/
RUN cd /opt/activemq/lib/optional && { curl -O http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.14/mysql-connector-java-8.0.14.jar ; cd -; }
RUN cd /opt/activemq/lib/optional && { curl -O http://central.maven.org/maven2/org/apache/commons/commons-dbcp2/2.1.1/commons-dbcp2-2.1.1.jar ; cd -; }

# Custom plugin
ADD plugins/selectoraware /opt/activemq/lib/extra

# Expose all port
EXPOSE 8161
EXPOSE 61616
EXPOSE 5672
EXPOSE 61613
EXPOSE 1883
EXPOSE 61614

# Expose some folders
VOLUME ["/data/activemq"]
VOLUME ["/var/log/activemq"]
VOLUME ["/opt/activemq/conf"]

WORKDIR /opt/activemq

#ENTRYPOINT ["/app/init"]
CMD ["/app/run.sh"]
