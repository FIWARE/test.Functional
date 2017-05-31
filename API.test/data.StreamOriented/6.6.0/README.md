# Stream-oriented - Kurento #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Stream-oriented is the FIWARE GE by Univeridad Rey Juan Carlos available at its [GitHub repository](https://github.com/Kurento).

[Top](#stream-oriented---kurento)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Stream-oriented - Kurento** - follow the instruction to [deploy a dedicated GE instance based on an image](https://catalogue.fiware.org/enablers/stream-oriented-kurento/creating-instances). 
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.


[Top](#stream-oriented---kurento)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Stream-oriented - Kurento ###

> No actions

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Kurento IP of previous VM with **kurento** alias according to your instance: 

> `192.168.111.228 kurento`


Copy in the **/tmp/** folder the **StreamOriented-6.6.0.jmx** file.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install oracle-java8-installer` - Java 8 is required for WebSocket
3. `wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#stream-oriented---kurento)

## Testing step by step ##

Before to start the test, you need to add JARs (plugins) in the **apache-jmeter-3.1/lib/ext** folder. Please copy **jmeter-plugins-manager-0.12.jar** and **JMeterWebSocketSamplers-0.7.3.jar** files in the **ext** folder.

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/StreamOriented-6.6.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`stream_oriented_kurento-6.6.0_yyyy-MM-dd HHmmss.csv`

[Top](#stream-oriented---kurento)