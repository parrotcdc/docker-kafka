FROM parrotstream/centos-openjdk:8

MAINTAINER Matteo Capitanio <matteo.capitanio@gmail.com>

USER root

ENV SCALA_VER 2.11

ENV CONFLUENT_PLATFORM_MAJOR_VER 3.2

# Install Confluent Repo
RUN rpm --import https://packages.confluent.io/rpm/${CONFLUENT_PLATFORM_MAJOR_VER}/archive.key
COPY confluent.repo /etc/yum.repos.d/

# Install needed packages
RUN yum update -y
RUN yum install -y git python-setuptools
RUN easy_install supervisor
RUN yum clean all

# All Kafka Stuff
RUN yum install -y confluent-kafka-$SCALA_VER confluent-kafka-rest confluent-kafka-connect-hdfs confluent-kafka-connect-jdbc confluent-kafka-connect-elasticsearch confluent-kafka-connect-s3 confluent-schema-registry confluent-libserdes confluent-cli

WORKDIR /

COPY *.sh /

RUN chmod +x *.sh

COPY etc/ /etc/

EXPOSE 9092 8081 8082 8083

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
