FROM ubuntu:20.04
MAINTAINER Josef Cacek

ENV GRADLE_VERSION=6.7.1 \
    MAVEN_VERSION=3.6.3 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

COPY linkcheckerrc /tmp/

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk python3 bash git wget unzip python3-pip curl \
    && wget -nv https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
    && unzip gradle-$GRADLE_VERSION-bin.zip -d /opt \
    && ln -s /opt/gradle-$GRADLE_VERSION/bin/gradle /usr/bin/gradle \
    && curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /opt \
    && ln -s /opt/apache-maven-$MAVEN_VERSION/bin/mvn /usr/bin/mvn \
    && pip3 install --no-cache-dir git+https://github.com/linkchecker/linkchecker.git@master \
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
