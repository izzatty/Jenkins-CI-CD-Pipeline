# Dockerfile
FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get install -y curl git unzip tar gzip
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

USER jenkins