#!/bin/bash
# please change permission to this file (chmod +x  install.sh) and run it as root user 

# Simply configure the FIWARE Env variables
echo "Configure the FIWARE Env variables"  
MIRROR=https://archive.apache.org/dist
NIFI_VERSION=1.7.0
NIFI_BASE_DIR=/opt/nifi
NIFI_HOME=${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}
NIFI_BINARY_URL=/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz 
NIFI_LOG_DIR=${NIFI_HOME}/logs
  
sudo mkdir ${NIFI_BASE_DIR}
sudo chmod 777 ${NIFI_BASE_DIR}

#install jdk
echo "Install jdk"  
sudo apt-get update
sudo apt-get install default-jdk -y

# Then download and decompress the package in the NIFI_HOME
echo "Download and decompress the package in the NIFI_HOME"
curl -fSL ${MIRROR}/${NIFI_BINARY_URL} -o ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz
cd ${NIFI_BASE_DIR}
echo "$(curl https://archive.apache.org/dist/${NIFI_BINARY_URL}.sha256) *${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz" | sha256sum -c - 
tar -xvzf ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_BASE_DIR} 
rm ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz


# Now, download the last release the fiware-cygnus processors from the git hub repo
echo "Download the last release the fiware-cygnus processors from the git hub repo"
cd $NIFI_HOME
curl -L -o "nifi-ngsi-resources.tar.gz" "https://github.com/ging/fiware-cygnus/releases/download/FIWARE_7.4/nifi-ngsi-resources.tar.gz"
tar -xvzf nifi-ngsi-resources.tar.gz -C ./ 
rm nifi-ngsi-resources.tar.gz 
cp nifi-ngsi-resources/nifi-ngsi-nar-1.0-SNAPSHOT.nar ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}/lib/nifi-ngsi-nar-1.0-SNAPSHOT.nar 
cp -r nifi-ngsi-resources/drivers ./ 
cp -r nifi-ngsi-resources/templates ${NIFI_HOME}/conf
     
# To run NiFi in the background, use bin/nifi.sh start. This will initiate the application to begin running.
echo "To run NiFi in the background, use bin/nifi.sh start" 
cd $NIFI_HOME T
./bin/nifi.sh start

echo "To see status and stop run NiFi ./bin/nifi.sh status ./bin/nifi.sh stop in the $NIFI_HOME folder" 

