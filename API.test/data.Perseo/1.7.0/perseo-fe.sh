#!/bin/bash
# please change permission to this file (chmod +x  perseo-fe.sh) 

PERSEO_FE_VERSION="1.7.0"

# Install NodeJS
echo "Install NodeJS" 
curl -sL https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum install -y nodejs

echo "Install mongo db 3.4"
sudo bash -c 'echo -e "[mongodb-org-3.4]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.4/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc" >> /etc/yum.repos.d/mongodb-org.repo'
sudo yum repolist -y
sudo yum install -y mongodb-org
sudo systemctl start mongod

# Downlaod Perseo Front End
echo "Downlaod Perseo Front End $PERSEO_FE_VERSION" 
export PERSEO_FE_HOME=/opt/perseo-fe
sudo git clone https://github.com/telefonicaid/perseo-fe.git $PERSEO_FE_HOME
cd $PERSEO_FE_HOME
git checkout release/$PERSEO_FE_VERSION
sudo npm install --production

# Start Perseo Front End
echo "Start Perseo Front End"
sudo node bin/perseo
