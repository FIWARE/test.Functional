# Backend Device Management - IDAS #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

The IDAS component is an implementation of the Backend Device Management GE by Telefonica available and it provides four different [IoT Agents implementation](https://catalogue.fiware.org/enablers/backend-device-management-idas/downloads) in github at these links: 
1. [IoT Agent JSON (MQTT)](https://github.com/telefonicaid/iotagent-json) 
2. [IoT Agent UL2.0 (HTTP or MQTT)](https://github.com/telefonicaid/iotagent-ul)
3. [IoT Agent LWM2M/CoAP](https://github.com/telefonicaid/lightweightm2m-iotagent)
4. [IoT Agent SIGFOX Devices](https://github.com/telefonicaid/sigfox-iotagent)


[Top](#backend-device-management---idas)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Backend Device Management - IDAS** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
3. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#backend-device-management---idas)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Backend Device Management - IDAS ###

Before to run the IoT Agent you need to install NodeJS and GitHub softwares in the Ubuntu VM. Before to install these softwares, an update of packages is required by using the `apt-get`, so run in the shell the `sudo apt-get update` command. Here the steps to prepare the softwares to test IoT Agent:

1. install GitHub

> `sudo apt-get install git` 

2. install NodeJS (node and npm)

> `sudo apt-get install nodejs` 

> `sudo apt-get install npm`

Check the versions for both using these commands `nodejs -v` (0.10.25) and `npm -v` (1.3.10). 
Set node in your PATH:

> `cd /usr/bin/`

> `sudo ln -s nodejs node`

3. Open and edit the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP with **orion** alias according to your instance (because we are using Orion Context Broker to store attributes): 

> `192.168.111.112 orion`

#### Start the IoT Agents ####

Please note that IoT Agents was been run singularly, so you cannot run all IoT Agents at the same time.

##### JSON #####

##### UL2.0 #####

##### LWM2M #####

1. download and start **lightweightm2m** IoT Agent 

> `git clone https://github.com/telefonicaid/lightweightm2m-iotagent`

go in the folder and install with this command: 

> `npm install`

copy `config-lwm2m.js` (from **LWM2M** folder) in the same folder and run the IoT Agent (server):

> `node bin/lwm2mAgent.js config-lwm2m.js`


2. download the client 

> `git clone https://github.com/telefonicaid/lwm2m-node-lib.git`

go in the folder and install with this command: 
> `npm install`

copy `client_lwm2m_service.js` and `client_lwm2m_device.js` in the **bin** folder.

Run the clients **only after you have started the JMeter of IoT Agent**, because in the JMeter script is also included the provisioning (device and service) of IoT Agent.

##### SIGFOX #####

1. download and start **sigfox-iotagent** IoT Agent 

> `git clone https://github.com/telefonicaid/sigfox-iotagent`

go in the folder and install with this command: 

> `npm install`

copy `config-sigfox.js` (from **SIGFOX** folder) in the same folder and run the IoT Agent (server):

> `node bin/iotagent config-sigfox.js`


2. copy the client (client_sigfox_device.js file) under **bin** folder of github project  

> `sigfox-iotagent/bin/client_sigfox_device.js`


### 2. Orion Context Broker ###

> No actions

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IDAS IP with **idas** alias according to your instance: 

> `192.168.111.87 idas`

Copy in the **/tmp/** folder the **IDAS-5-LWM2M.jmx** file according to your IoT Agent you want to test.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#backend-device-management---idas)

## Testing step by step ##

**Run the test**:

##### LWM2M #####

**Northbound**: run the JMeter script with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/IDAS-5-LWM2M.jmx`


**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`idas-5-lwm2m_yyyy-MM-dd HHmmss.csv`

*Southbound*: before to test clients (southbound) you need to run the IoT Agent and to make a provisioning both service and device. So in the JMeter script with the follow command: 

Now you can start the clients in the **idas** VM to send data from client to **orion**:

> `node bin/client_lwm2m_service.js`

> `node bin/client_lwm2m_device.js`


##### SIGFOX #####

**Northbound**: run the JMeter script with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/IDAS-5-SIGFOX.jmx`


**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`idas-5-sigfox_yyyy-MM-dd HHmmss.csv`

**Southbound**: before to test clients (southbound) you need to run the IoT Agent and to make a provisioning both service and device. So in the JMeter script with the follow command: 

Now you can start the clients in the **idas** VM to send data from client to **orion**:

> `node bin/client_sigfox_device.js`


[Top](#backend-device-management---idas)