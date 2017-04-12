# PEP Proxy - Wilma #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

The PEP Proxy GE is a backend component, without frontend interface and available at its [GitHub repository](https://github.com/ging/fiware-pep-proxy). 

[Top](#pep-proxy---wilma)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - follow the instruction to [deploy a dedicated KeyRock instance] (https://catalogue.fiware.org/enablers/identity-management-keyrock/creating-instances). 
2. **PEP Proxy - Wilma** - download PEP Proxy source code via github at this link (https://github.com/ging/fiware-pep-proxy.git) and run it (follow the next preliminary steps section).
3. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#pep-proxy---wilma)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management - KeyRock ###

> No actions

### 2. PEP Proxy - Wilma ###

Run the server


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add PEP Proxy IP of previous VM with **pep_proxy** alias according to your instance: 

> `192.168.111.87 pep_proxy`


Copy in the **/tmp/** folder the **PepProxy-5.4.0.jmx**, **auth-token.sh** and **file.properties** files.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#pep-proxy---wilma)

## Testing step by step ##

#### Preliminary steps ####
1. Deploy a KeyRock VM (version 5.4.0)
* login in KeyRock web interface (Horizon) at `keyrock_ip:8000` and use default credentials (`idm/idm`) 
* create an application (just follow the wizard) to get `client id` and `client secret`
* create PEP Proxy credentials from previous application to get `username` and `password` for PEP Proxy registration
2. Download PEP Proxy source code via github (https://github.com/ging/fiware-pep-proxy.git) using `git clone https://github.com/ging/fiware-pep-proxy.git` command
* create the `config.js` file from template (config.js.template) and edit it; just to use the right IP address of KeyRock and credentials of PEP Proxy
* run the server with nodejs
> `$ npm install`

> `$ sudo node server.js`

3. get the token from script
* edit the `auth-token.sh` file; update CLIENT_ID and CLIENT_SECRET, and change the KeyRock IP for oauth2/token link  (http://localhost:8000/oauth2/token) with your right KeyRock IP   
* run the `auth-token.sh` file in the shell to get the token. Don't forget to change the permission to file (`chmod +x auth-token.sh`). Please use username and password as input parameters in the shell: 
> `./auth-token.sh idm idm`
* copy it and put in the `file.properties` file 

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/PepProxy-5.4.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`pep_proxy-5.4.0_yyyy-MM-dd HHmmss.csv`

[Top](#pep-proxy---wilma)