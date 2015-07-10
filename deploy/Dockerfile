FROM ubuntu

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# Define working directory.
WORKDIR /opt/docker

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update
RUN pip install awscli
ADD start.sh /opt/docker/
ADD ci.jar /opt/docker/

RUN ["chown", "-R", "daemon", "."]

USER daemon
EXPOSE 7777

CMD sh /opt/docker/start.sh

