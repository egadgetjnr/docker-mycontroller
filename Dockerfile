FROM openjdk:8-jdk-slim
ENV VERSION=1.4.0
ENV MYCONTROLLER_URL="https://github.com/mycontroller-org/mycontroller/releases/download/${VERSION}.Final/mycontroller-dist-standalone-${VERSION}.Final-bundle.tar.gz"

LABEL \
	org.label-schema.maintainer="egadgetjnr" \
	org.label-schema.name="mycontroller" \
	org.label-schema.description="Mycontroller running on OpenJDK" \
	org.label-schema.version="${VERSION}" \
	org.label-schema.vcs-url="https://github.com/egadgetjnr/docker-mycontroller" \
	org.label-schema.schema-version="1.0"

# pin to /tmp
WORKDIR /tmp

# dependencies
RUN apt-get update && apt-get install wget procps -y 

# install
RUN wget $MYCONTROLLER_URL -O mycontroller.tar.gz \
    && tar zxf mycontroller.tar.gz -C /usr/local \
    && rm -fR /tmp/*

# add files
COPY files/root/ /

# expose mqtt and web
EXPOSE 1883/tcp 8443/tcp

WORKDIR /usr/local/mycontroller

# fixes
#RUN	chmod +x bin/start.sh

ENTRYPOINT ["java","-Xms8m","-Xmx150m","-Dlogback.configurationFile=conf/logback.xml","-Dmc.conf.file=conf/mycontroller.properties","-cp","lib/*","org.mycontroller.standalone.StartApp",">> logs/mycontroller.log 2>&1"]
