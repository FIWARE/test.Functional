#!/bin/bash
# please change permission to this file (chmod +x  perseo-core.sh)

PERSEO_CORE_VERSION="1.2.0"
MVN_VERSION="3.5.4"
TOMCAT_VERSION="8.5.34"

# Install JDK
echo "Install JDK" 
sudo yum -y install tar nc which git java-1.8.0-openjdk-devel
sudo yum clean all
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk 


# Install Maven
echo "Install Maven" 
curl --remote-name --location --insecure --silent --show-error "http://www.eu.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz"
tar xzvf apache-maven-$MVN_VERSION-bin.tar.gz

export MVN_HOME=/opt/apache-maven
sudo mv apache-maven-$MVN_VERSION/ $MVN_HOME
sudo rm -f apache-maven-$MVN_VERSION-bin.tar.gz


# Install Tomcat
echo "Install Tomcat" 
wget http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
tar xzvf apache-tomcat-$TOMCAT_VERSION.tar.gz

export TOMCAT_HOME=/opt/tomcat
sudo mv apache-tomcat-$TOMCAT_VERSION/ $TOMCAT_HOME
sudo rm -f apache-tomcat-$TOMCAT_VERSION.tar.gz


# Downlaod Perseo Core
echo "Downlaod Perseo Core" 
export PERSEO_HOME=/opt/perseo-core
sudo git clone https://github.com/telefonicaid/perseo-core.git $PERSEO_HOME
cd $PERSEO_HOME
git checkout release/$PERSEO_CORE_VERSION
sudo $MVN_HOME/bin/mvn package -Dmaven.test.skip=true


# Deploy Perseo Core WAR
echo "Deploy Perseo Core WAR"
cp target/perseo-core-*.war $TOMCAT_HOME/webapps/perseo-core.war 
sudo mkdir -p /var/log/perseo
sudo chmod 777 /var/log/perseo


# This file should be copied by deployment process into /etc/perseo-core.properties, with the appropiate permissions
echo "Create perseo-core.properties file in the /etc/ folder"
sudo bash -c 'echo -e "# URL for invoking actions when a rule is fired\naction.url = http://127.0.0.1:9090/actions/do\n# Time in milliseconds (long) to expire a dangling rule\nrule.max_age=60000" >> /etc/perseo-core.properties'
sudo chmod 777 /etc/perseo-core.properties


# Start Perseo Core
echo "Start Perseo Core"
$TOMCAT_HOME/bin/catalina.sh run && tail -f /var/log/tomcat/catalina.out


