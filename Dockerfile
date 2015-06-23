# docker - miso
#
# VERSION	0.1

FROM ubuntu

MAINTAINER Devon P. Ryan, dpryan79@gmail.com

RUN apt-get -qq update && apt-get install --no-install-recommends -y maven2 \
    tomcat7 mysql-server openjdk-7-jdk git wget libmysql-java

#Add miso user/group
RUN groupadd miso && \
    useradd -g miso -c "Miso user" miso && \
    mkdir /home/miso && \
    chown miso:miso /home/miso

#Set up mysql databases
ADD ./setup_sql.sql /tmp/setup_sql.sql
RUN cd /tmp && \
    wget --quiet https://repos.tgac.ac.uk/miso/latest/sql/lims-schema.sql && \
    wget --quiet https://repos.tgac.ac.uk/miso/latest/sql/miso_type_data.sql && \
    service mysql start && \
    mysql < /tmp/setup_sql.sql && \
    mysql -D lims < /tmp/lims-schema.sql && \
    mysql -D lims < /tmp/miso_type_data.sql && \
    wget https://repos.tgac.ac.uk/miso/latest/ROOT.war && \
    mv /tmp/ROOT.war /var/lib/tomcat7/webapps/ && \
    git clone https://github.com/TGAC/miso-lims.git && \
    cd miso-lims && \
    wget http://repos.tgac.bbsrc.ac.uk/maven/miso/snapshots/uk/ac/bbsrc/tgac/miso/runstats-client/0.2.0-SNAPSHOT/runstats-client-0.2.0-20131017.230351-75.jar && \
    mvn install:install-file -DgroupId=uk.ac.bbsrc.tgac.qc -DartifactId=run -Dversion=0.2.0-SNAPSHOT -Dpackaging=jar -Dfile=runstats-client-0.2.0-20131017.230351-75.jar

ADD ./ROOT.xml /var/lib/tomcat7/conf/Catalina/localhost/ROOT.xml
RUN ln -s /usr/share/tomcat7/bin /var/lib/tomcat7/bin && \
    ln -s /usr/share/tomcat7/lib /var/lib/tomcat7/lib && \
    mkdir -p /storage/miso/ && \
    mkdir -p /storage/.miso/ && \
    cd /storage/miso && \
    wget --quiet https://repos.tgac.ac.uk/miso/latest/miso_userspace_properties.tar.gz && \
    tar xf miso_userspace_properties.tar.gz && \
    cp /storage/miso/* /storage/.miso/ && \
    cd /storage && chown -R tomcat7:tomcat7 . && \
    ln -s /tmp /var/lib/tomcat7/temp

RUN cd /var/lib/tomcat7/webapps && \
    wget --quiet https://repos.tgac.ac.uk/miso/latest/ROOT.war && \
    rm -rf ROOT && \
    chown tomcat7:tomcat7 * && \
    cd ../lib && \
    wget --quiet https://repos.tgac.ac.uk/miso/common/mysql-connector-java-5.1.10.jar && \
    wget --quiet https://repos.tgac.ac.uk/miso/common/jndi-file-factory-1.0.jar

ADD ./startup.sh /usr/local/bin/startup.sh

EXPOSE :8080

VOLUME ["/storage/miso"]

CMD ["/usr/local/bin/startup.sh"]
