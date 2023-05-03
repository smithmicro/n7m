#!/bin/bash

# setup Amazon Linux 2023 for Docker and Docker Compose
set -e

# Docker
sudo yum update
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
newgrp docker

# Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Pull data required for North America
docker-compose run feed download --wiki --grid
docker run -v /data/data:/tileset openmaptiles/openmaptiles-tools download-osm north-america

# Setup
docker-compose up -d

# bail out here 
exit

# to download and execute this:
N7M_VERSION=v0.9.5 \
 && curl -O -L https://github.com/smithmicro/n7m/archive/refs/tags/$N7M_VERSION.tar.gz \
 && tar xvf $N7M_VERSION.tar.gz --strip-components=1 \
 && cd deploy \
./setup-al.sh
