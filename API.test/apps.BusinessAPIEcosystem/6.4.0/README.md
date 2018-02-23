# Business API Ecosystem #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Business API Ecosystem is the FIWARE GE by UPM available at its [GitHub repository](https://github.com/FIWARE-TMForum/Business-API-Ecosystem). 

[Top](#business-api-ecosystem)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - follow the instruction to [deploy a dedicated KeyRock instance](https://catalogue.fiware.org/enablers/identity-management-keyrock/creating-instances).

2. **Business API Ecosystem GE** - follow the instruction to [deploy a dedicated GE instance based on an image](https://catalogue.fiware.org/enablers/business-api-ecosystem/creating-instances). 

3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#business-api-ecosystem)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management - KeyRock ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Keyrock and Business API Ecosystem IPs with **keyrock** and **business** aliases according to your instance: 

> `127.0.0.1 217.172.12.159 localhost keyrock`

> `217.172.12.184 business`

*Please note that in this test we are using keyrock version 5.4.0.*
Install KeyRock via docker.

> `sudo curl -fsSL https://get.docker.com/ | sh`

> `sudo docker run -d --name idm -p 8000:8000 -p 5000:5000 -t  fiware/idm`


If you have just run it for the first time, you will need to create in Keyrock:

1) a consumer (application) named **Business** with URL http://business:8004/ and callback URL http://business:8004/auth/fiware/callback
2) a seller and a customer users (named `seller` and `customer`), 
3) create two roles (`Seller` and `Customer`) and enable the users: the seller with **Seller** and **Provider** roles and customer with **Customer** role.

You can do this configuration via Web Interface at this link http://keyrock:8000 (use idm/idm credentials), or you can execute the `KeyRock-5.4.0_for_BusinessAPIEcosystem.jmx` JMeter script (please run this script in the JMeter VM).
For more details see the step 3 (JMeter); so run this command (make sure to add '*keyrock*' alias in the */etc/hosts* file):

`./apache-jmeter-3.3/bin/jmeter -n -t /tmp/KeyRock-5.4.0_for_BusinessAPIEcosystem.jmx`

**Please note** that the script generates a `credentials.txt` file (located in the root) to get the credentials *clientSecret* and *clientId* for your `Business` application. If you use the command above then the credentials.txt file is located in `/tmp` folder. 
You can also find these values via Web Interface accessing to http://keyrock:8000 (with `seller/seller` credentials). 


### 2. Business API Ecosystem ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Keyrock and Business API Ecosystem IPs with **keyrock** and **business** aliases according to your instance: 

> `127.0.0.1 217.172.12.184 localhost business`

> `217.172.12.159 keyrock`

Since there isn't a dedicated GE instance of Business API Ecosystem, here follow the steps for installation.
In order to do this you need to deploy a base_ubuntu_16.04 VM and become root user (`sudo -i`): 

1) update packages

> `apt-get update`

2) download software

> `mkdir /opt/biz`

> `cd /opt/biz`

> `wget https://github.com/FIWARE-TMForum/Business-API-Ecosystem/archive/v6.4.0.zip`

> `apt-get install unzip git`

> `unzip v6.4.0.zip`

> `cd Business-API-Ecosystem-6.4.0`

> `./setup_env.sh`

3) Run the script to install the GE. In the **/opt/biz/Business-API-Ecosystem-6.4.0** folder, edit the mysql password in the **install.py** file 

> `nano install.py`

change the *toor* default password in to your real mysql password.

> `./install.py all`

4) Create folders in the **/opt/biz/Business-API-Ecosystem-6.4.0** folder:

> `mkdir -p business-ecosystem-charging-backend/src/media/bills`

> `mkdir -p business-ecosystem-charging-backend/src/media/assets`

5) Edit the config.js file in the **/opt/biz/Business-API-Ecosystem-6.4.0/business-ecosystem-logic-proxy/** folder:

> `nano config.js`

and complete the follow attributes:

    'server': 'http://keyrock:8000',
    'clientID': '12995437d3c54153ba92842ddd3cbc70',
    'clientSecret': '49331f71a59c481bb140b9299a2c4608',
    'callbackURL': 'http://business:8004/auth/fiware/callback',

6) Run the *logic-proxy* server:

In the same folder type:

> `node server.js`

or to execute the process in background: 

> `nohup node server.js > /var/log/business-ecosystem-logic-proxy.log 2>&1&`

7) Run the *charging-backend* server:

> `cd /opt/biz/Business-API-Ecosystem-6.4.0/business-ecosystem-charging-backend/src`

> `source ../virtenv/bin/activate`

> `./manage.py loadplugin wstore/test/test_plugin_files/test_plugin.zip`

and create the `media/assets/[seller_account_name]` directory:

> `mkdir -p media/assets/seller`

> `./manage.py runserver 127.0.0.1:8006`

or to execute the process in background:

> `nohup ./manage.py runserver 127.0.0.1:8006 > /var/log/business-ecosystem-charging-backend.log 2>%1&`


7) Login into the `business` portal (http://business:8000) with seller user and customer users to authorize them. *Please use two different browsers for both users*.

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Keyrock and Business API Ecosystem IPs with **keyrock** and **business** aliases according to your instance: 

> `217.172.12.184 business`

> `217.172.12.159 keyrock`

Copy in the **/tmp/** folder the **BusinessAPIEcosystem-5.4.0.jmx**, **KeyRock-5.4.0_for_BusinessAPIEcosystem.jmx**, **auth-token.sh** and **file.properties** files.

Before to start the script, you must to update the `file.properties` file with seller and customer tokens. 
In order to do this you have to edit the `auth-token.sh` script with your credentials (CLIENT_ID, CLIENT_SECRET - lines 24 and 25) and type these commands in the shell:
- `chmod 777 auth-token.sh`
- `./auth-token.sh seller seller` to get the token in the shell (copy and paste token_seller in the file.properties)
- `./auth-token.sh customer customer`  to get the token in the shell (copy and paste token_customer in the file.properties)

#### Install JMeter 3.3 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 3.3

4. `sudo wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.3.tgz` - download JMeter 3.3

5. `sudo tar -xf apache-jmeter-3.3.tgz` - unpack JMeter

[Top](#business-api-ecosystem)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.3/bin/jmeter -n -t /tmp/BusinessAPIEcosystem-6.4.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`business_api_ecosystem-6.4.0_yyyy-MM-dd HHmmss.csv`


**Please note** that if this script fails probably the tokens are expired.

[Top](#business-api-ecosystem)