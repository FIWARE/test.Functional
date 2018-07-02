# Cygnus #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)

## Introduction ##

Cygnus is a connector in charge of persisting certain sources of data in certain configured third-party storages, creating a historical view of such data provided by Telefonica available at its [GitHub repository](https://github.com/telefonicaid/fiware-cygnus). Cygnus (more specifically, cygnus-ngsi agent) plays the role of a connector between Orion Context Broker (which is a NGSI source of data) and many FIWARE storages such as CKAN, Cosmos Big Data (Hadoop) and STH Comet, so it's usefull to use/install Cygnus adapter directly in the Orion Context Broker VM. 

[Top](#cygnus)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, two Virtual Machines you needed, which are: 

1. **Cygnus** - follow the instruction in the next step to install Cygnus via source. 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Cygnus ###

In order to install Cygnus via source to test APIs with JMeter, you have to deploy a Centos 7 VM.
After connected on VM via SSH, you have to run the **install.sh** script provided in this folder to install the software. 
Please note that before to run the script, you must change the permission to *install.sh* file (i.e `chmod +x  install.sh`) and run it as root user (`sudo -i`). 
At the end of installation process you have to start the Cygnus server using the second script (**start.sh**) after changed permission file.

To summarize, here the commands you have to type:

> `sudo -i`

Copy install.sh and start.sh files on VM, and change permissions:

> `chmod +x  install.sh`

> `chmod +x  start.sh`


Run the installation:

> `./install.sh`


Please note that for this test (API) it's not necessary to configure any storage systems. The start.sh script creates for you two default files (*agent_ngsi_api.conf* and *cygnus_instance_api.conf*) to test the Cygnus APIs. 

Run the server:

> `./start.sh`
 

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP as **cygnus** alias according to your instance: 

> `192.168.111.152 cygnus`


Copy in the **/tmp/** folder the **Cygnus-1.8.0_API.jmx** and **file.properties** files.
Edit the **file.properties** file with your FIWARE LAB credentials (in particular **email** and **password**).


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#cygnus)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-1.8.0_API.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.8.0_api_yyyy-MM-dd HHmmss.csv`

[Top](#cygnus)
