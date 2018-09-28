#!/bin/bash
# please change permission to this file (chmod +x  install.sh) 

WILMA_VERSION="7.0.1"
echo "PEP Proxy $WILMA_VERSION installation" 

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

# Download and install PepProxy
echo "Download and install PepProxy"
git clone https://github.com/ging/fiware-pep-proxy.git
cd fiware-pep-proxy
cp config.js.template config.js
npm install

echo "Please go in the 'fiware-pep-proxy' folder edit config.js file and start using 'sudo node server' command"
