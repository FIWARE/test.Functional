# CKAN Extensions #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

CKAN extensions are a set of plugins, developed within FIWARE, which integrates this data portal platform with the main FIWARE GEs, enhancing the default CKAN behaviour with improved access control, publication of right-time context data, and rich visualization features, available at its [GitHub repository](https://github.com/conwetlab/FIWARE-CKAN-Extensions). 

[Top](#ckan-extensions)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **CKAN Extensions GE** -  select "base_ubuntu_14.04" and follow the instruction below this section.(https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances). 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#ckan-extensions)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. CKAN Extensions ###

This CKAN Extensions required CKAN 2.7 on Ubuntu 14.04. Follow these steps to install CKAN 2.7 and CKAN Extensions: 

1) deploy an Ubuntu 14.04 VM and connect on it in SSH: 

2) copy `install.sh`, `privatedatasets.sh` and `datarequests.sh` files in `/home/ubuntu` folder and change mod to all: `chmod 777 *.sh`. 

3) install CKAN 2.7

`./install.sh`

4) install CKAN Extensions:

`./privatedatasets.sh`

`./datarequests.sh`

5) register an account in CKAN using this url `http://IP/user/register` and take note of the **username** and the **API Key Private**; edit in the **file.properties** file your username and api_key propeties. 
for example: 

`username = <username>`
`api_key = 62f6a4e0-ff05-4b44-b320-8391f4e84ac9`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP of previous VM with **orion** alias according to your instance: 

> `192.168.111.4 ckan`


Copy in the **/tmp/** folder the **CKAN-extensions-6.4.0.jmx** and **file.properties** files.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#ckan-extensions)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/CKAN-extensions-6.4.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`ckan_extensions-6.4.0_yyyy-MM-dd HHmmss.csv`

[Top](#ckan-extensions)