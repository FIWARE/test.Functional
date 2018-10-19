# Perseo #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

The Perseo GE is CEP implementation for IoT platform provided by Telefonica and composed by two components:
[perseo (front-end)](https://github.com/telefonicaid/perseo-fe)
[core (perseo-core)](https://github.com/telefonicaid/perseo-core)

[Top](#perseo)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Perseo** - select "base_centos_7" image in the FIWARE Cloud Portal to install both perseo-fe and perseo-core.
 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#perseo)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Perseo GE ###

Follow these instructions in order to install two Perseo components: 

1) Deploy a Centos 7 VM and connect on it in SSH: 

2) Download on Centos VM the `perseo-core.sh` and `perseo-fe.sh` files and change them the permissions:

> `chmod +x *.sh`

3) Install Perseo, please install before the perseo-core (version 1.2.0), and after the perseo-core up and running install in to another VM the perseo-fe (1.7.0), using these commands:

> `./perseo-core.sh`

> `./perseo-fe.sh`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Perseo IP of previous VM with **perseo** alias according to your instance: 

> `192.168.111.89 perseo`

Copy in the **/tmp/** folder the **Perseo-Core-1.2.0.jmx** and **Perseo-Front-End-1.7.0.jmx** files.

#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#perseo)

## Testing step by step ##

**Run the test** with the follow command for perseo-core: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Perseo-Core-1.2.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`perseo-core-1.2.0_yyyy-MM-dd HHmmss.csv`

and for perseo-fe

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Perseo-Front-End-1.7.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`perseo-fe-1.7.0_yyyy-MM-dd HHmmss.csv`

[Top](#perseo)