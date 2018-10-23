#!/bin/bash
# please change permission to this file (chmod +x  install.sh) 

KEYROCK_VERSION="7.3.1"
echo "KeyRock $KEYROCK_VERSION installation" 

# Update package manager
echo "Update package manager" 
sudo apt-get update -y

# Install dependencies
echo "Install dependencies" 
sudo apt-get install curl git build-essential -y

# Install nodejs 6
echo "Install nodejs 6"
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get update -y
sudo apt-get install nodejs -y
sudo npm install npm -g

# Install MySQL
echo "Install MySQL" 
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password idm'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password idm'
sudo apt-get -y install mysql-server

# Install Postfix
echo "Install Postfix"
debconf-set-selections <<< "postfix postfix/mailname string localdomain"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install postfix

# Download and install KeyRock
echo "Download and install KeyRock"
git clone https://github.com/ging/fiware-idm.git --branch $KEYROCK_VERSION
cd fiware-idm
cp config.js.template config.js
npm install

# Provide data in to database
echo "Provide data in to database"
npm run-script create_db
npm run-script migrate_db
npm run-script seed_db

# Start the server
echo "Start the server"
# npm start  # simple start with localhost and port 3000
# use public ip to configure the activation via email
PUBLIC_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
IDM_HOST=http://$PUBLIC_IP:3000 npm start
