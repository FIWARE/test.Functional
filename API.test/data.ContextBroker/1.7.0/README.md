# Publish/Subscribe Context Broker - Orion Context Broker #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Orion is the FIWARE GE reference implementation of the Context Broker Generic Enabler by Telefonica available at its [GitHub repository](https://github.com/telefonicaid/fiware-orion). 

[Top](#publishsubscribe-context-broker---orion-context-broker)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance] (https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances). 
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#publishsubscribe-context-broker---orion-context-broker)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Orion Context Broker ###

> No actions


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP of previous VM with **orion** alias according to your instance: 

> `192.168.111.201 orion`


Copy in the **/tmp/** folder the **OrionContextBroker-1.7.0.jmx** file.

To check the context information provided by Orion Context Broker (after the execution of the test), use:

`curl -v http://orion:1026/v2/entities`

or to delete:

`curl -vX DELETE http://orion:1026/v2/entities/Car1`
 

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#publishsubscribe-context-broker---orion-context-broker)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/OrionContextBroker-1.7.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`orion_context_broker-1.7.0_yyyy-MM-dd HHmmss.csv`

[Top](#publishsubscribe-context-broker---orion-context-broker)