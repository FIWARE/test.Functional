# Authorization PDP - AuthZForce #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

AuthZForce is an implementation of the FIWARE Identity Management Generic Enabler by THALES available at its [GitHub repository](https://github.com/authzforce). 

[Top](#authorization-pdp---authzforce)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - follow the instruction to [deploy a dedicated KeyRock instance](https://catalogue.fiware.org/enablers/identity-management-keyrock/creating-instances). 
2. **PEP Proxy - Wilma** - download PEP Proxy source code via github at this [link](https://github.com/ging/fiware-pep-proxy.git) and run it.
3. **Authorization PDP - AuthZForce** - follow the instruction to [Deploying a dedicated GE instance based on an image](https://catalogue.fiware.org/enablers/authorization-pdp-authzforce/creating-instances).
4. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#authorization-pdp---authzforce)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management - KeyRock ###

> No actions, only to deploy the VM

### 2. PEP Proxy - Wilma ###

> Download on the KeyRock VM and start the PEP Proxy server; follow the [preliminary steps](#preliminary-steps) 

### 3. Authorization PDP - AuthZForce ###

> No actions, only to deploy the VM

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add KeyRock and AuthZForce IPs of previous VM with **keyrock** and **authzforce** aliases according to your instance: 

> `192.168.111.87 keyrock`

> `192.168.111.89 authzforce`


Copy in the **/tmp/** folder the **AuthZForce-5.4.1.jmx** file.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#authorization-pdp---authzforce)

## Testing step by step ##


#### Preliminary steps ####
1. Deploy a KeyRock VM (version 5.4.0)
* login in KeyRock web interface (Horizon) at `keyrock_ip:8000` and use default credentials (`idm/idm`) 
* create an application (just follow the wizard) to get `client id` and `client secret`
* create PEP Proxy credentials from previous application to get `username` and `password` for PEP Proxy registration
2. Download PEP Proxy source code via [github](https://github.com/ging/fiware-pep-proxy.git) using `git clone https://github.com/ging/fiware-pep-proxy.git` command
* create the `config.js` file from template (config.js.template) and edit it; just to use the right IP address of KeyRock and credentials of PEP Proxy
* run the server with nodejs
> `$ npm install`

> `$ sudo node server.js`

4. Please add the `attribute provider` just follow the 4 steps at this [link](http://authzforce-ce-fiware.readthedocs.io/en/latest/UserAndProgrammersGuide.html#integrating-an-attribute-provider-into-authzforce-server). Files are also available in this folder.


**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/AuthZForce-5.4.1.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`authzforce-5.4.1_yyyy-MM-dd HHmmss.csv`

[Top](#authorization-pdp---authzforce)