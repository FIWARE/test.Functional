#!/bin/bash

sudo apt-get install python-setuptools

echo "CKAN extensions: Data Requests CKAN extension v1.0.0"
git clone https://github.com/conwetlab/ckanext-datarequests.git
cd ckanext-datarequests
git checkout v1.0.0
. /usr/lib/ckan/default/bin/activate
sudo python setup.py install

echo "Add datarequests plugin"
sudo sed -i '103s/=/= datarequests/' /etc/ckan/default/production.ini
sudo sed -i '109i# Customize data requests' /etc/ckan/default/production.ini
sudo sed -i '110ickan.datarequests.comments = true' /etc/ckan/default/production.ini
sudo sed -i '111ickan.datarequests.show_datarequests_badge = true' /etc/ckan/default/production.ini
sudo sed -i '111s/.*/&\n/' /etc/ckan/default/production.ini

sudo chmod 777 -R /usr/lib/ckan/default/src/ckan/ckan/public/base/i18n/

echo "Restart Apache and Nginx"
sudo service apache2 restart
sudo service nginx restart
