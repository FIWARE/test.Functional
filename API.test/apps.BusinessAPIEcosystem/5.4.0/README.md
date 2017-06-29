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
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - follow the instruction to [deploy a dedicated KeyRock instance](https://catalogue.fiware.org/enablers/identity-management-keyrock/creating-instances).

2. **Business API Ecosystem GE** - follow the instruction to [deploy a dedicated GE instance based on an image](https://catalogue.fiware.org/enablers/business-api-ecosystem/creating-instances). 

3. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#business-api-ecosystem---biz-ecosystem-ri)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management - KeyRock ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Keyrock and Business API Ecosystem IPs with **keyrock** and **business** aliases according to your instance: 

> `127.0.0.1 217.172.12.241 localhost keyrock`

> `217.172.12.184 business`

Please note that in this test we are using keyrock version 5.4.0.

If you have just launch it for the first time, you will need to create in Keyrock:

1) a consumer (application) named **Business** with URL http://business:8000/ and callback URL http://business:8000/auth/fiware/callback
2) a seller and a customer users (named `seller` and `customer`), 
3) create two roles (`Seller` and `Customer`) and enable the users: the seller with **Seller** and **Provider** roles and customer with **Customer** role.

You can do this configuration via Web Interface at this link http://keyrock:8000 (use idm/idm credentials), or you can execute the `KeyRock-5.4.0_for_BusinessAPIEcosystem.jmx` JMeter script (please run this script in the JMeter VM).
For more details see the step 3 (JMeter); so run this command:

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/KeyRock-5.4.0_for_BusinessAPIEcosystem.jmx`

**Please note** that the script generates a `credentials.txt` file (located in the root) to get the credentials clientSecret and clientId for your `Business` application. If you use the command above then the credentials.txt file is located in `/tmp folder`. 
You can also find these values via Web Interface accessing to http://keyrock:8000 (with `seller/seller` credentials). 


### 2. Business API Ecosystem ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Keyrock and Business API Ecosystem IPs with **keyrock** and **business** aliases according to your instance: 

> `127.0.0.1 217.172.12.184 localhost business`

> `217.172.12.241 keyrock`


Configure the files in the Business VM:
1) Include the **Keyrock** credentials (client id, client secret), the server and the callback URL in the config.js file located at `/opt/biz/Business-API-Ecosystem/business-ecosystem-logic-proxy`.

Please **modify the charging endpoint port from 8004 to 8006**

2) Provide a valid email in the settings.py file (WSTOREMAIL) located in `/opt/biz/Business-API-Ecosystem/business-ecosystem-charging-backend/src`

3) Update the external site of the charging backend
	1. from `/opt/biz/Business-API-Ecosystem/business-ecosystem-charging-backend/` execute `source virtenv/bin/activate`
	2. from src execute `./manage.py shell`
	- [1] `from django.contrib.sites.models import Site` 
	- [2] `site = Site.objects.get(name='ext')` 
	- [3] `site.domain = 'http://keyrock:8000/'`
	- [4] `site.save()`
	
	type `ctrl-D` to exit
	
	3. from src execute `./manage.py loadplugin /opt/biz/Business-API-Ecosystem/business-ecosystem-charging-backend/src/wstore/test/test_plugin_files/test_plugin.zip`
	
	4. from src execute `mkdir -p media/assets/[seller]`

4) **patch**: edit `oauth2.js` file in `/opt/biz/Business-API-Ecosystem/business-ecosystem-logic-proxy/node_modules/passport-fiware-oauth/lib/passport-fiware-oauth` to change the address (https://account.lab.fiware.org) with your keyrock (http://keyrock:8000) in three lines (44,45 and 79)

5) Restart the charging backend

	`sudo service business-charging restart`
	
6) Restart the proxy

	`sudo service business-proxy restart`
	
7) Login into the `business` portal (http://business:8000) with seller user and customer users to authorize them. Please use two different browsers for both users.

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Keyrock and Business API Ecosystem IPs with **keyrock** and **business** aliases according to your instance: 

> `217.172.12.184 business`

> `217.172.12.241 keyrock`

Copy in the **/tmp/** folder the **BusinessAPIEcosystem-5.4.0.jmx**, **KeyRock-5.4.0_for_BusinessAPIEcosystem.jmx**, **auth-token.sh** and **file.properties** files.

Before to start the script, you must to update the `file.properties` file with seller and customer tokens. 
In order to do this you have to edit the `auth-token.sh` script with your credentials (CLIENT_ID, CLIENT_SECRET - lines 24 and 25) and type these commands in the shell:
- `chmod 777 auth-token.sh`
- `./auth-token.sh seller seller` to get the token in the shell (copy and paste token_seller in the file.properties)
- `./auth-token.sh customer customer`  to get the token in the shell (copy and paste token_customer in the file.properties)

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


Please note that if this script fails probably the tokens are expired.

[Top](#business-api-ecosystem---biz-ecosystem-ri)