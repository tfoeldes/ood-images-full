#!/bin/bash
set -e
echo -n root | passwd --stdin root


yum install -y yum-utils device-mapper-persistent-data lvm2


yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo


yum install -y docker-ce docker-ce-cli containerd.io

if [[ ! -f /usr/local/bin/docker-compose ]]
then
    curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

mkdir -p /etc/docker/compose/keycloak/
cp /vagrant/auth/docker-compose.yml /etc/docker/compose/keycloak/
