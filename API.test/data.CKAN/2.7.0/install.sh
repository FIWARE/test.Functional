#!/bin/bash

echo "Install CKAN 2.7 on Ubuntu 14.04"

echo "Update Ubuntu's package index"
sudo apt-get update

echo "Install the Ubuntu packages that CKAN requires (and git, to enable you to install CKAN extensions)"
sudo apt-get install -y nginx apache2 libapache2-mod-wsgi libpq5 redis-server git-core

echo "Download the CKAN package on Ubuntu 14.04"
wget http://packaging.ckan.org/python-ckan_2.7-trusty_amd64.deb

echo "Install the CKAN package on Ubuntu 14.04"
sudo dpkg -i python-ckan_2.7-trusty_amd64.deb
sudo rm -f python-ckan_2.7-trusty_amd64.deb

echo "Install and configure PostgreSQL"
sudo apt-get install -y postgresql
sudo -u postgres psql -l
sudo -u postgres bash -c "psql -c \"CREATE USER ckan_default WITH PASSWORD 'pass';\""
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8

echo "Install and configure Solr"
sudo apt-get install -y solr-jetty

echo "Edit the Jetty configuration file (/etc/default/jetty)"
sudo chmod 777 /etc/default/jetty
sudo sed -i "s/`head -4 /etc/default/jetty | tail -1 `/NO_START=0/" /etc/default/jetty
sudo sed -i "s/`head -16 /etc/default/jetty | tail -1 `/JETTY_HOST=127.0.0.1/" /etc/default/jetty
sudo sed -i "s/`head -19 /etc/default/jetty | tail -1 `/JETTY_PORT=8983/" /etc/default/jetty
sudo service jetty restart

echo "Replace the default schema.xml file with a symlink to the CKAN schema file included in the sources"
sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml

echo "Change the solr_url setting in your CKAN configuration file (/etc/ckan/default/production.ini) to point to your Solr server"
sudo chmod 777 /etc/ckan/default/production.ini
sudo sed -i '79s/.*/solr_url = http:\/\/127.0.0.1:8983\/solr/' /etc/ckan/default/production.ini
PUBLIC_IP=`wget http://ipecho.net/plain -O - -q ; echo`
sudo sed -i "59s/.*/ckan.site_url = http:\/\/${PUBLIC_IP}/" /etc/ckan/default/production.ini

echo "Initialize your CKAN database"
sudo ckan db init

echo "Restart Apache and Nginx"
sudo service apache2 restart
sudo service nginx restart
sudo service jetty restart