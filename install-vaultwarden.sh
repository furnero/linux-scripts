#!/bin/bash

# #######

# Installation von Vaultwarden auf Linux/Debian

# #######


sudo apt update 
sudo apt upgrade -y

sudo apt install apt-transport-https ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


sudo systemctl start docker
sudo systemctl enable docker

docker --version

mkdir ~/vaultwarden
cd ~/vaultwarden

cat <<EOF > docker-compose.yml
version: '3'

services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: always
    environment:
      WEBSOCKET_ENABLED: "true"
      ADMIN_TOKEN: "changeme!"
    volumes:
      - ./vw-data:/data
    ports:
      - "8080:80"
      - "3012:3012"
EOF

sudo docker compose up -d

echo "Vaultwarden wurde gestartet!"
