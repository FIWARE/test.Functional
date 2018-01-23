# Data Visualization - Knowage #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)

## Introduction ##

Knowage is the professional open source suite for modern business analytics over traditional sources and big data systems developed by Engineering Ingegneria Informatica, available at its [GitHub repository](https://github.com/KnowageLabs/Knowage-Server). 

[Top](#data-visualization---knowage)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Knowage GE** - follow the instruction to [deploy a dedicated Orion instance](https://interestingittips.wordpress.com/tag/knowage-spagobi-install/). 
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#data-visualization---knowage)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Knowage ###

> No actions

### 2. JMeter ###

Open the **/etc/hosts** file and add the IP of Knowage instance with **knowage** alias according to your instance: 

> `192.168.111.71 knowage`

Copy in the **/tmp/** folder the **Knowage-6.1.1.jmx** file JMeter script and **prova.xml** file.

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#data-visualization---knowage)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Knowage-6.1.1.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`knowage-6.1.1_yyyy-MM-dd HHmmss.csv`

[Top](#data-visualization---knowage)