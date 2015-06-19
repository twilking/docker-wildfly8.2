FROM ubuntu:14.04.2
MAINTAINER Tim Wilking (tim.wilking@isst.fraunhofer.de)

# Ubuntu
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl

# Oracle JDK 8
RUN add-apt-repository ppa:webupd8team/java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update
RUN apt-get install -y oracle-java8-installer

# Wildfly
RUN adduser --disabled-password --disabled-login wildfly
RUN echo "wildfly:wildfly" | chpasswd && adduser wildfly sudo
USER wildfly
ENV WILDFLY_VERSION 8.2.0.Final
RUN cd $HOME && curl http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz | tar zx && mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly
RUN /home/wildfly/wildfly/bin/add-user.sh admin admin --silent

#Change User to root
USER root

# Expose WildFly Ports
EXPOSE 8080
EXPOSE 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/home/wildfly/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
