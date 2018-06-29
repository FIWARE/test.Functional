# STH Comet #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##


The FIWARE Short Time Historic (STH) - Comet is a component able to manage (storing and retrieving) historical context information as raw and aggregated time series context information available at its [GitHub repository](https://github.com/telefonicaid/fiware-sth-comet). 

[Top](#sth-comet)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, three Virtual Machines you needed, which are: 

1. **STH Comet** - follow the instruction to [deploy a dedicated STH Comet instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#sth-comet)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. STH Comet ###

Deploy the dedicated Orion Context Broker in FIWARE Lab. Follow these instructions in order to install the STH Comet instance in the FIWARE Lab: 

1) Deploy an Ubuntu 16.04 VM and connect on it in SSH: 

2) Update packages:

> `sudo apt-get update`

3) Install the Node.js modules and dependencies:

> `sudo apt-get install nodejs`

> `sudo apt-get install npm`

> `sudo apt-get install nodejs-legacy`

with node version v4.2.6 and npm version 3.5.2


4) Install mongo db

> `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927`

> `echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list`

> `sudo apt-get update`

> `sudo apt-get install -y mongodb-org`

> `sudo systemctl start mongod`

ant to test, use this command:

> `mongo`

4) Install STH Comet 

> `git clone https://github.com/telefonicaid/fiware-sth-comet.git`

> `cd fiware-sth-comet/`

> `sudo npm install`

5) Edit the config.js file

In order to use the JMeter script, it's necessary to edit the `config.js` script in `fiware-sth-comet/`.
It's important to change the host of server from "localhost" to "0.0.0.0" in order to get access to other VM (in this case from JMeter VM for testing)

6) Running the STH server (port 8666)

> `./bin/sth`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add STH Comet IP of previous VM with **sth** alias according to your instance: 

> `192.168.111.72 sth`


Copy in the **/tmp/** folder the **STH-Comet-2.3.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#sth-comet)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/STH-Comet-2.3.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`sth-comet-2.3.0_yyyy-MM-dd HHmmss.csv`

[Top](#sth-comet)