# Business API Ecosystem - Biz Ecosystem RI #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Business API Ecosystem is the FIWARE GE by UPM available at its [GitHub repository](https://github.com/FIWARE-TMForum/Business-API-Ecosystem). 

[Top](#business-api-ecosystem---biz-ecosystem-ri)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Business API Ecosystem GE** - follow the instruction to [deploy a dedicated GE instance based on an image] (https://catalogue.fiware.org/enablers/business-api-ecosystem/creating-instances). 
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.


[Top](#business-api-ecosystem---biz-ecosystem-ri)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Business API Ecosystem ###

If you have just launch it for the first time, you will need to configure several things, since the system is using a default configuration which is not valid for a real usage:
1) Register an application in the **FIWARE IdM - Keyrock**
	1. URL `http://<yourcloudip>:8000/`
	2. Callback URL `http://<yourcloudip>:8000/auth/fiware/callback`
	3. Create roles Seller and Customer
	4. Enable two users: one with Seller and Provider roles and one with Customer role

2) Include the IdM credentials (client id, client secret), and the callback URL in the config.js file located at `/opt/biz/Business-API-Ecosystem/business-ecosystem-logic-proxy`. Please **MODIFY CHARGING ENDPOINT PORT! 8004 -> 8006**

3) Provide a valid email in the settings.py file (WSTOREMAIL) located in `/opt/biz/Business-API-Ecosystem/business-ecosystem-charging-backend/src`

4) Update the external site of the charging backend
	1. from `/opt/biz/Business-API-Ecosystem/business-ecosystem-charging-backend/` execute source `virtenv/bin/activate`
	2. from src execute `./manage.py shell`
	- [1] from `django.contrib.sites.models` import Site 
	- [2] `site = Site.objects.get(name='ext')` 
	- [3] `site.domain = 'http://<yourcloudip>:8000/'`
	- [4] `site.save()`
	3. from src execute `./manage.py loadplugin /opt/biz/Business-API-Ecosystem/business-ecosystem-charging-backend/src/wstore/test/test_plugin_files/test_plugin.zip`
	4. from src execute `mkdir -p media/assets/[seller_account_name]`

5) Restart the charging backend
	1. `sudo service business-charging restart`
	
6) Restart the proxy
	1. `sudo service business-proxy restart`
	
7) Login 
	1. Login into the portal with seller user and customer user 


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Business API Ecosystem IP of previous VM with **business** alias according to your instance: 

> `192.168.111.226 business`


Copy in the **/tmp/** folder the **BusinessAPIEcosystem-5.4.0.jmx** file.

Modify file.properties file with two AUTH2 tokens (for seller and customer). 
 

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#business-api-ecosystem---biz-ecosystem-ri)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/BusinessAPIEcosystem-5.4.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`business_api_ecosystem-5.4.0_yyyy-MM-dd HHmmss.csv`

[Top](#business-api-ecosystem---biz-ecosystem-ri)