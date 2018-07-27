#!/bin/bash

sudo apt-get install python-setuptools

echo "CKAN extensions: Private Datasets CKAN extension v0.3"
git clone https://github.com/conwetlab/ckanext-privatedatasets
cd ckanext-privatedatasets
git checkout v0.3
. /usr/lib/ckan/default/bin/activate
sudo python setup.py install

echo "Add privatedatasets plugin"
sudo sed -i '103s/=/= privatedatasets/' /etc/ckan/default/production.ini
sudo sed -i '109i# Customize private datasets' /etc/ckan/default/production.ini
sudo sed -i '110ickan.privatedatasets.parser = ckanext.privatedatasets.parsers.fiware:FiWareNotificationParser' /etc/ckan/default/production.ini
sudo sed -i '111ickan.privatedatasets.show_acquire_url_on_create = True' /etc/ckan/default/production.ini
sudo sed -i '112ickan.privatedatasets.show_acquire_url_on_edit = True' /etc/ckan/default/production.ini
sudo sed -i '112s/.*/&\n/' /etc/ckan/default/production.ini

echo "Restart Apache and Nginx"
sudo service apache2 restart
sudo service nginx restart
