#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install apache2 -y
echo "<h1>Hello world from highly available group of ec2 instances</h1>" | sudo tee -a /var/www/html/index.html
sudo chmod 777 /var
sudo systemctl start apache2
sudo systemctl enable apache2


sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce