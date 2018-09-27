#!/bin/bash
# please change permission to this file (chmod +x  install.sh) 

VERSION="2.4.0" 
STH_GITHUB="https://github.com/telefonicaid/fiware-sth-comet.git"
STH_HOME="fiware-sth-comet"

# Install NodeJS
echo "Install NodeJS" 
sudo apt-get update
sudo apt-get install -y nodejs npm nodejs-legacy

echo "Install mongo db 3.2"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# Update the Ubuntu Packages
sudo apt-get update
# Install MongoDB
sudo apt-get install -y mongodb-org
sudo systemctl start mongod

# Downlaod STH Comet
echo "Downlaod STH Comet $VERSION"
git clone $STH_GITHUB $STH_HOME
cd $STH_HOME
git checkout release/$VERSION
sudo npm install

# Edit config.js - replace localhost in 0.0.0.0 at line 31
echo "Replace localhost in 0.0.0.0 at line 31"
sudo sed -i -e '31s/localhost/0\.0\.0\.0/' config.js

# Start server
./bin/sth


