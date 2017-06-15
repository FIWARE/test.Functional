# Electronic Data Exchange - Domibus #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Domibus is a sample implementation of a CEF (Connecting Europe Facility) eDelivery Access Point by EUROPEAN COMMISSION available at its [CEF Digital web site](https://ec.europa.eu/cefdigital/wiki/display/CEFDIGITAL/Domibus+-+v3.2). 

[Top](#electronic-data-exchange---domibus)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Electronic Data Exchange - Domibus (sender) GE** - follow the instruction to [deploy a dedicated Domibus instance](https://catalogue.fiware.org/enablers/electronic-data-exchange-domibus/creating-instances).
2. **Electronic Data Exchange - Domibus (receiver) GE** - follow the instruction to [deploy a dedicated Domibus instance](https://catalogue.fiware.org/enablers/electronic-data-exchange-domibus/creating-instances). 
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

Please note that you need of two Domibus instances, in order to test an use case (Business Scenario).
The first Virtual Machine is used to send the message (Access Point Sending) and the second to download the message (Access Point Receiving).  
![Four corner model](four_corner.png?style=centerme "The four-corner model")

[Top](#electronic-data-exchange---domibus)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Domibus (sender) ###

Domibus sender is the `blue_gw` example. Edit the `/usr/local/tomcat/domibus/conf/domibus/domibus-security.xml` file. 
Here the changes:
- in the passwordStore properties of keystorePasswordCallback bean as key/value, use `blue_gw/test123`
- in the keystore alias to use for decryption and signing, use `blue_gw` 
- in the location of the keystore, use `gateway_keystore.jks`
- in the location and name of the trustStore, use `gateway_truststore.jks`
 
Just to use the right configuration, you can check it using `domibus-security-blue_gw.xml` file. Restart the server:
> `ps -e|grep java`
> `kill -9` xxx
> `sudo service domibus start`   

### 2. Domibus (receiver) ###

Domibus sender is the `red_gw` example. Edit the `/usr/local/tomcat/domibus/conf/domibus/domibus-security.xml` file. 
Here the changes:
- in the passwordStore properties of keystorePasswordCallback bean as key/value, use `red_gw/test123`
- in the keystore alias to use for decryption and signing, use `red_gw` 
- in the location of the keystore, use `gateway_keystore.jks`
- in the location and name of the trustStore, use `gateway_truststore.jks`
 
Just to use the right configuration, you can check it using `domibus-security-red_gw.xml` file. Restart the server:
> `ps -e|grep java`
> `kill -9` xxx
> `sudo service domibus start` 

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Domibus_Blue IP of previous VM with **domibus_blue** alias and Domibus_Red IP of previous VM with **domibus_red** alias according to your instance: 

> `192.168.111.201 domibus_blue`
> `192.168.111.202 domibus_red`


Copy in the **/tmp/** folder the **Domibus-3.2.jmx** file.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#electronic-data-exchange---domibus)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Domibus-3.2.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`domibus-3.2_yyyy-MM-dd HHmmss.csv`

[Top](#electronic-data-exchange---domibus)