# Iot Discovery GE #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Iot Discovery is the FIWARE GE by University of Surrey available at its [GitHub repository](https://github.com/UniSurreyIoT/fiware-iot-discovery-ngsi9).

[Top](#iot-discovery-ge)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **IoT Discovery GE** - follow the instruction to [deploy a dedicated GE instance](http://fiware-iot-discovery-ngsi9.readthedocs.io/en/latest/install/install/index.html).
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.


[Top](#iot-discovery-ge)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. IoT Discovery GE ###

> No actions

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

add Iot Dsicovery IP of previous VM with **iotdiscovery** alias according to your instance:

> `192.168.111.169 iotdiscovery`


Copy in the **/tmp/** folder the **IoTDiscovery-5.jmx** file.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#iot-discovery-ge)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/IoTDiscovery-5.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iot_discovey-5_yyyy-MM-dd HHmmss.csv`

[Top](#iot-discovery-ge)