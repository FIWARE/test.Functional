#!/bin/bash
# please change permission to this file (chmod +x  install.sh) and run it as root user 

# Install JDK
echo "Install JDK" 
yum -y install tar nc which git java-1.8.0-openjdk-devel
yum clean all
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk 


# Install Maven
echo "Install Maven" 
curl --remote-name --location --insecure --silent --show-error "http://www.eu.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz"
tar xzvf apache-maven-3.5.3-bin.tar.gz

export MVN_HOME=/opt/apache-maven
mv apache-maven-3.5.3/ $MVN_HOME
rm -f apache-maven-3.5.3-bin.tar.gz

# Install Flume
echo "Install Flume" 
curl --remote-name --location --insecure --silent --show-error "http://archive.apache.org/dist/flume/1.4.0/apache-flume-1.4.0-bin.tar.gz"
tar zxf apache-flume-1.4.0-bin.tar.gz
export FLUME_HOME=/usr/cygnus
mv apache-flume-1.4.0-bin $FLUME_HOME 
rm -f apache-flume-1.4.0-bin.tar.gz

mkdir -p $FLUME_HOME/plugins.d/cygnus
mkdir -p $FLUME_HOME/plugins.d/cygnus/lib
mkdir -p $FLUME_HOME/plugins.d/cygnus/libext


# Downlaod Cygnus
echo "Downlaod Cygnus" 
export CYGNUS_HOME=/opt/fiware-cygnus
git clone https://github.com/telefonicaid/fiware-cygnus.git $CYGNUS_HOME
cd $CYGNUS_HOME
git checkout release/1.9.0

# Cygnus-common
echo "Compile Cygnus-common" 
cd $CYGNUS_HOME/cygnus-common
$MVN_HOME/bin/mvn clean compile exec:exec assembly:single
cp target/cygnus-common-1.9.0-jar-with-dependencies.jar $FLUME_HOME/plugins.d/cygnus/libext/ 
$MVN_HOME/bin/mvn install:install-file -Dfile=$FLUME_HOME/plugins.d/cygnus/libext/cygnus-common-1.9.0-jar-with-dependencies.jar -DgroupId=com.telefonica.iot -DartifactId=cygnus-common -Dversion=1.9.0 -Dpackaging=jar -DgeneratePom=false 

# Cygnus-ngsi
echo "Compile Cygnus-ngsi" 
cd $CYGNUS_HOME/cygnus-ngsi
${MVN_HOME}/bin/mvn clean compile exec:exec assembly:single
cp target/cygnus-ngsi-1.9.0-jar-with-dependencies.jar $FLUME_HOME/plugins.d/cygnus/lib/
   
# Install Cygnus Application script
echo "Install Cygnus Application script"
cp $CYGNUS_HOME/cygnus-common/target/classes/cygnus-flume-ng $FLUME_HOME/bin/ 
chmod +x $FLUME_HOME/bin/cygnus-flume-ng

echo "Add cygnus user"
adduser cygnus
chown -R cygnus:cygnus $FLUME_HOME

# Create Cygnus log folder
echo "Create Cygnus log folder"
mkdir /var/log/cygnus
chown cygnus:cygnus /var/log/cygnus

# Cleanup to thin the final image
echo "Cleanup to thin the final image"
cd $CYGNUS_HOME/cygnus-common
${MVN_HOME}/bin/mvn clean
cd $CYGNUS_HOME/cygnus-ngsi
${MVN_HOME}/bin/mvn clean

# Copy files
echo "Copy files"
cp $CYGNUS_HOME/cygnus-common/conf/*.* $FLUME_HOME/conf/
cp $CYGNUS_HOME/cygnus-ngsi/conf/*.* $FLUME_HOME/conf/

# Configure files
echo "Rename template files"
cd $FLUME_HOME/conf
cp flume-env.sh.template flume-env.sh
cp grouping_rules.conf.template grouping_rules.conf
cp name_mappings.conf.template name_mappings.conf
cp krb5.conf.template krb5.conf
cp -ru log4j.properties.template log4j.properties
cp agent_ngsi.conf.template agent_ngsi_ckan.conf
cp cygnus_instance.conf.template cygnus_instance_ckan.conf

echo "Please edit agent_ngsi_ckan.conf and cygnus_instance_ckan.conf files in "$FLUME_HOME/conf" folder according to your CKAN instance" 



