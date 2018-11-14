# Open MTC #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

OpenMTC is the FIWARE GE by OpenMTC available at its [GitHub repository](https://github.com/OpenMTC/OpenMTC). 

[Top](#open-mtc)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **OpenMTC GE** - follow the instruction to install an OpenMTC instance in FIWARE Lab in the next section. 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#open-mtc)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. OpenMTC ###

Follow these instructions to install OpenMTC: 

1) deploy an Ubuntu 16.04 VM (tested with medium flavor) and connect on it in SSH

2) update packages

> `sudo apt-get update`

3) install dependencies

> `sudo apt-get install python-pip libev-dev python-dev gcc make automake`

4) download OpenMTC via git

> `git clone https://github.com/OpenMTC/OpenMTC OpenMTC`

5) install OpenMTC

> `cd OpenMTC/`

> `pip2 install --user --requirement openmtc-gevent/dependencies.txt`

> `sudo python setup-sdk.py install`

6) start OpenMTC

> `./openmtc-gevent/run-gateway`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add OpenMTC IP of previous VM with **openmtc** alias according to your instance: 

> `192.168.111.169 openmtc`


Copy in the **/tmp/** folder the **OpenMTC-1.0.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#open-mtc)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/OpenMTC-1.0.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`openmtc-1.0.0_yyyy-MM-dd HHmmss.csv`

[Top](#open-mtc)