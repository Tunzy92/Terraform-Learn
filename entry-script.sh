#!/bin/bash
mkdir docker
sudo apt update && sudo apt install docker.io -y 
sudo systemctl start docker
sudo usermod -aG docker ubuntu
docker run -p 8080:80 nginx
              
