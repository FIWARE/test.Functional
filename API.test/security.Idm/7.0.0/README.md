# Identity Management KeyRock #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Keyrock is an implementation of the FIWARE Identity Management Generic Enabler by UPM available at its [GitHub repository](https://github.com/ging/fiware-idm). 

[Top](#identity-management-keyrock)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - follow the instruction to [deploy a dedicated KeyRock instance](https://catalogue.fiware.org/enablers/identity-management-keyrock/creating-instances).
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#identity-management-keyrock)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management KeyRock ###

If there isn't available a dedicate instance, please follow these instructions to install KeyRock manually following these instructions (tested on Ubuntu 16.04): 

1) deploy an Ubuntu 16.04 VM (tested with medium flavor) and connect on it in SSH

2) update packages

> `sudo apt-get update`

3. install dependencies

> `sudo apt-get install curl git build-essential`

4. install nodejs

> `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`

> `sudo apt-get update`

> `sudo apt-get install nodejs` 

> `sudo npm install npm -g`

versions installed: node = v6.14.1 and npnm = 5.8.0

 
5. install MySQL (set username and password for mysql server)

> `sudo apt-get install mysql-server`

> `mysql --version`
 
mysql  Ver 14.14 Distrib 5.7.21, for Linux (x86_64) using  EditLine wrapper


6. download KeyRock from github repository

> `git clone https://github.com/ging/fiware-idm.git`

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

> `npm start` or `nohup npm start &`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add KeyRock IP of previous VM with **keyrock** alias according to your instance: 

> `192.168.111.9 keyrock`


Copy in the **/tmp/** folder the **KeyRock-7.0.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#identity-management-keyrock)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/KeyRock-7.0.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`keyrock-7.0.0_yyyy-MM-dd HHmmss.csv`

[Top](#identity-management-keyrock)