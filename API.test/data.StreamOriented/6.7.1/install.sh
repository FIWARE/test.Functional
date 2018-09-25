#!/bin/bash
# please change permission to this file (chmod +x  install.sh) 

VERSION="6.7.1" 

# Define what version of Ubuntu is installed in your system
# KMS for Ubuntu 14.04 (Trusty) or KMS for Ubuntu 16.04 (Xenial)
DISTRO="xenial" # "trusty"
echo "KMS for Ubuntu 16.04 ($DISTRO)"

echo "Add the Kurento repository to your system configuration"   

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83
sudo tee "/etc/apt/sources.list.d/kurento.list" >/dev/null <<EOF
# Kurento Media Server - Release packages
deb [arch=amd64] http://ubuntu.openvidu.io/$VERSION $DISTRO kms6
EOF

echo "Install KMS"
sudo apt-get update -y
sudo apt-get install kurento-media-server -y

echo "Start server"
sudo service kurento-media-server start

echo "To stop the server use 'sudo service kurento-media-server stop' command"


