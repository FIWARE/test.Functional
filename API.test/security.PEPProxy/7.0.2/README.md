# PEP Proxy Wilma #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

The PEP Proxy GE is a backend component, without frontend interface and available at its [GitHub repository](https://github.com/ging/fiware-pep-proxy). 

[Top](#pep-proxy-wilma)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - follow the instruction to [deploy a dedicated KeyRock instance](https://catalogue.fiware.org/enablers/identity-management-keyrock/creating-instances). 
2. **PEP Proxy - Wilma** - follow the instruction to [deploy a dedicated PEP Proxy instance](https://catalogue.fiware.org/enablers/pep-proxy-wilma/creating-instances).
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#pep-proxy-wilma)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management - KeyRock ###

Follow the steps to install Keyrock 7.0.2 on an Ubuntu 16.04 VM (tested with medium flavor) - you can also use the `install_keyrock.sh` script provided in this folder to install and run keyrock:

1) connect on it in SSH

2) update packages

> `sudo apt-get update`

3. install dependencies

> `sudo apt-get install curl git build-essential`

4. install nodejs 6

> `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`

> `sudo apt-get update`

> `sudo apt-get install nodejs` 

> `sudo npm install npm -g`

versions installed: node = v6.14.4 and npnm = 6.4.1

 
5. install MySQL (set username and password for mysql server)

> `sudo apt-get install mysql-server`

> `mysql --version`
 
mysql  Ver 14.14 Distrib 5.7.23, for Linux (x86_64) using  EditLine wrapper


6. download KeyRock from github repository

> `git clone https://github.com/ging/fiware-idm.git --branch 7.0.2 `

7. copy and edit file config.js file in the `fiware-idm` folder

> `cd fiware-idm`

> `cp config.js.template config.js`

> `nano config.js`

Please set the right credentials in the `Database info` section for your MySQL database

8. install, run script to provide data in to database and start the server

> `npm install`

> `npm run-script create_db`

> `npm run-script migrate_db`

> `npm run-script seed_db`

> `npm start`


You can try it via:

1. web browser at link `http://keyrock:3000` using `admin@test.com/1234` credentials, 

2. curl call `http://keyrock:3000/version`.

9) install Postfix 

> `sudo apt-get install mailutils`

After deployed and started KeyRock 7.0.2 VM, it's necessary, for PEP Proxy authentication test, to create an user, an application and register pep proxy.
Here in details, the steps in order to get information about configuring PEP Proxy `config.js` file (you can also use the `KeyRock_for_PEP_Proxy.jmx` script to jump these steps - the script generates automatically a `credentials.txt` file):

1. sign up an user (for example in the JMeter script is used a `pep@test.com` user with password `pep`)

2. login in KeyRock web interface (Horizon) at `http://keyrock_ip:8000` with `pep@test.com/pep` credentials

3. create an application (just follow the wizard) to get `client id` and `client secret`

4. register a new PEP Proxy to get credentials (`username` and `password`) in the PEP Proxy registration

Please take note of these parameters, because they are required in next step to configure PEP Proxy.


### 2. PEP Proxy - Wilma ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add KeyRock IP of previous VM with **keyrock** alias according to your instance: 

> `192.168.111.231 keyrock`

Follow the steps to install PEP Proxy 7.0.2 on an Ubuntu 16.04 VM (tested with medium flavor) - you can also use the `install_pep-proxy.sh` script provided in this folder:

1) connect on it in SSH

2) update packages

> `sudo apt-get update`

3. install dependencies

> `sudo apt-get install curl git build-essential`

4. install nodejs 6

> `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`

> `sudo apt-get update`

> `sudo apt-get install nodejs` 

> `sudo npm install npm -g`

versions installed: node = v6.14.4 and npnm = 6.4.1

4) download pep-proxy source from github

> `git clone https://github.com/ging/fiware-pep-proxy.git`

> `cd fiware-pep-proxy`

> `cp config.js.template config.js`

> `npm install`

4) Edit config.js file


Then, you have to configure the config.js file of Wilma GE with KeyRock:

1. edit the config.js file (in `/home/ubuntu/fiware-pep-proxy` folder); just to change the alias for IP address of KeyRock and the credentials of PEP Proxy (an example of config.js file of PEP Proxy is provided in this folder):

	config.idm = {
		host: 'keyrock',
		port: 3000,
		ssl: false
	}

	config.app = {
		host: 'www.google.it',
		port: '80',
		ssl: false // Use true if the app server listens in https
	}
	
	// Credentials obtained when registering PEP Proxy in app_id in Account Portal
	config.pep = {
		app_id: '6309bdc4-37c3-4d52-9891-b8c805804588',
		username: 'pep_proxy_fd9043e1-ca69-4007-bc6f-ea8eeeb69ffa',
		password: 'pep_proxy_e7fb4051-5c4b-41c9-870c-b19b4bce29c1',
		trusted_apps : []
	}

5) start the server

> `sudo node server.js`


and this is a log example in the console:

	2018-09-28 14:23:27.471  - INFO: Server - Starting PEP proxy in port 80. IdM authentication ...
	2018-09-28 14:23:27.601  - INFO: IDM-Client - IDM authorization configuration:
	2018-09-28 14:23:27.602  - INFO: IDM-Client -  + Authzforce enabled: false
	2018-09-28 14:23:27.602  - INFO: IDM-Client -  + Authorization rules allowed: HTTP Verb+Resource
	2018-09-28 14:23:27.602  - INFO: Server - Success authenticating PEP proxy. Proxy Auth-token:  899af90a-f4a0-4114-9602-10d747c8ef6b
	2018-09-28 14:23:27.603  - INFO: Server - Success authenticating PEP proxy.
 

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add PEP Proxy and KeyRock IPs of previous VMs with **wilma** and **keyrock** aliases according to your instances: 

> `192.168.111.24 wilma`

> `192.168.111.231 keyrock`


Copy in the **/tmp/** folder the **PepProxy-7.0.2.jmx**, **auth-token.sh** and **file.properties** files.

Edit the auth-token.sh file; you have to update only CLIENT_ID and CLIENT_SECRET. Run the `auth-token.sh` file in the shell to get the token. Don't forget to change the permission to file (`sudo chmod +x auth-token.sh`). Please use username and password as input parameters in the shell: 

> `./auth-token.sh pep@test.com pep`

and copy the token and put it in the `file.properties` file:

> `sudo nano file.properties` 

update the file:

> `token = 9e9a539208c25958b95d5891356107cbb434a225`
 

#### Install JMeter 4 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter


[Top](#pep-proxy-wilma)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/PepProxy-7.0.2.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`pep_proxy-7.0.2_yyyy-MM-dd HHmmss.csv`

[Top](#pep-proxy-wilma)