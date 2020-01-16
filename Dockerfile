FROM ubuntu:18.04
MAINTAINER Josef Cacek

ENV GRADLE_VERSION=5.6.4

COPY linkcheckerrc /tmp/

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y openjdk-8-jdk python2.7 bash git wget unzip python-pip maven \
    && wget -nv https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
    && unzip gradle-$GRADLE_VERSION-bin.zip -d /opt \
    && ln -s /opt/gradle-$GRADLE_VERSION/bin/gradle /usr/bin/gradle \
    && pip install --no-cache-dir git+https://github.com/linkchecker/linkchecker.git@master \
    && groupadd -r -g 1031 jenkins \
    && groupadd -r -g 989 docker \
    && useradd -d /home/jenkins -ms /bin/bash -u 1030 -g 1031 -G docker jenkins \
    && mkdir /home/jenkins/.linkchecker \
    && mv /tmp/linkcheckerrc /home/jenkins/.linkchecker \
    && chown -R jenkins:jenkins /home/jenkins/.linkchecker \
    && echo "Cleaning up..." \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Location where travis config stored
VOLUME /mnt

USER jenkins
WORKDIR /home/jenkins
