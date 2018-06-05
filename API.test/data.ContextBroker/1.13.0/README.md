# Orion Context Broker #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Orion Context Broker is the FIWARE GE reference implementation of the Context Broker Generic Enabler by Telefonica available at its [GitHub repository](https://github.com/telefonicaid/fiware-orion). 

[Top](#orion-context-broker)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).

2. **Orion Context Broker GE** - deploy a second instance of Orion as *Context Provider*. 
 
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#orion-context-broker)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Orion Context Broker ###

Deploy the dedicated Orion Context Broker in FIWARE Lab.

Please open the **/etc/hosts** file by using this command:

> `sudo vi /etc/hosts` 

and add Orion IP of the second Orion VM with **provider** alias (the second instance of Orion must be used as *context provider* for testing of this Orion): 

> `192.168.111.170 provider`


Follow these instructions, if it's not available the right version of Orion Context Broker GE in the FIWARE Lab: 

1) deploy an Centos 7 VM and connect on it in SSH: 

2) copy the `contextBroker-1.12.0-1.x86_64.rpm` file in the `/home/centos` folder or use `wget` command:

> `wget -O contextBroker-1.13.0-1.x86_64.rpm https://nexus.lab.fiware.org/repository/el/7/x86_64/release/contextBroker-1.13.0-1.x86_64.rpm` 

3) install some dependencies:

> `sudo yum install boost boost-devel boost-doc`

4) install and start mongodb:
 
create a `mongodb-org.repo` file:
 
> `sudo vi /etc/yum.repos.d/mongodb-org.repo`

and add these lines:

	[mongodb-org-3.4]
	name=MongoDB Repository
	baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
	gpgcheck=1
	enabled=1
	gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc

> `sudo yum repolist`

> `sudo yum install mongodb-org`

> `sudo systemctl start mongod`
   
5) install and start orion:
   
> `sudo rpm -i contextBroker-1.12.0-1.x86_64.rpm`

> `sudo service contextBroker start`

and check the version

> `sudo curl http://localhost:1026/version`

### 2. Orion Context Broker ###

Please use any Orion Context Broker instance in the FIWARE Lab. This Orion will be only the *context provider* for the previous Orion (version 1.13.0).

> No actions

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orions IP of previous VM with **orion** and **provider** aliases according to your instance: 

> `192.168.111.169 orion`

> `192.168.111.170 provider`


Copy in the **/tmp/** folder the **OrionContextBroker-1.13.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#orion-context-broker)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/OrionContextBroker-1.13.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`orion_context_broker-1.13.0_yyyy-MM-dd HHmmss.csv`

[Top](#orion-context-broker)