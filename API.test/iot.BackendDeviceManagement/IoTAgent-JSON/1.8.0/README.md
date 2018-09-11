# IoT Agent JSON #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##
IoT Agent JSON is designed to be a bridge between an HTTP/MQTT+JSON based protocol and the FIWARE NGSI standard used in FIWARE, like the Orion Context Broker.
This IoT Agent JSON (HTTP/MQTT transport) is part of [IDAS component](https://catalogue.fiware.org/enablers/backend-device-management-idas/downloads) which is the FIWARE GE reference implementation of the Backend Device Management GE provided by ATOS available at its [GitHub repository](https://github.com/telefonicaid/iotagent-json/releases/tag/1.8.0).

[Top](#iot-agent-json)

## Testing environment ##
The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack.
In order to test this GE, please deploy three Virtual Machines, which are: 

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
2. **IoT Agent JSON GE** - select a "base_ubuntu_16.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#iot-agent-json)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:


### 1. Orion Context Broker ###

Deploy an Orion VM in FIWARE Lab.


### 2. IoT Agent JSON GE ###

First of all you need to deploy an Ubuntu 16.04 VM in FIWARE Lab. Before to run the IoT Agent you need to install NodeJS and GitHub softwares in the Ubuntu VM. Before to install these softwares, an update of the packages is required using the `apt-get` command, so run in the shell the `sudo apt-get update` command. Here the steps to prepare the softwares to test the IoT Agent:

1. Update of the packages

> `sudo apt-get update`

2. Install NodeJS (nodejs and npm)

> `sudo apt-get install nodejs` 

> `sudo apt-get install npm`

Check the versions for both using these commands `nodejs -v` (v4.2.6) and `npm -v` (3.5.2). 

3. Get the IoT Agent from the repository at this [link](https://github.com/Fiware/iot.IoTagent-JSON.git) and download it (in the **/home/ubuntu** folder):

> `git clone https://github.com/Fiware/iot.IoTagent-JSON.git --branch 1.8.0 --single-branch`

> `cd iot.IoTagent-JSON`

> `sudo npm install`

4. Open and edit the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP with **orion** alias according to your instance (because we are going to the use Orion Context Broker to store attributes provided by IoT Agent): 

> `192.168.111.9 orion`

you can try using this command:

> `curl http://orion:1026/version`

5. Install **MongoDB** in order to use this database as the '*Device Registry*'. Please note that if you don't want to use the *MongoDB database* please change the '*type*' attribute of *deviceRegistry* in **memory** instead of **mongodb** in the *config-json.json* file and JMeter script is configured with Mongo DB.
Here the steps to install MongoDB:

Importing the Public Key
> `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927`

Create source list file MongoDB
> `echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list`

Update the repository
> `sudo apt-get update`

Install MongoDB
> `sudo apt-get install -y mongodb-org`

Start mongodb and add it as service to be started at boot time:

> `sudo systemctl start mongod`

> `sudo systemctl enable mongod`

Now check that mongodb has been started on port 27017 with the netstat command.

> `netstat -plntu`

and check the version (`3.2.21`) using these two commands:

> `mongo`

> `db.version()`

> `exit`
 

### Run the IoT Agent ###

Here the steps on how to configure IoT Agent JSON GE; basically how to start the IoT Agent JSON server (via `config-json.js`) and how to run the MQTT client to send data to IoT Agent server and read the context information in Orion.

**IoT Agent JSON server**

Copy the `config-json.js` file provided in the root folder. Basically the *config-json.js* is a copy of *config.js* file located in the iot.IoTagent-JSON folder downloaded from git; you can copy it (`cp config.js config-json.js`) and set the Orion IP as *'orion'* instead of *'localhost'* because we are using different VMs for them.
To start the IoT Agent server please use:

> `sudo nodejs bin/iotagent-json config-json.js`

**MQTT client**

Copy the `client_mqtt_json.js` file (provided in the root folder) into `iot.IoTagent-JSON/bin` folder of github project downloaded from git.

**Please note** that to use the MQTT client you need to start a MQTT Broker server. In order to do this, copy the `mqtt_broker.js` file in the `iot.IoTagent-JSON` folder too. The MQTT Broker uses the *Mongo DB* database, so it's necessary that a mongo instance is up and running. 
Before to run the mqtt_broker.js script, you need to install [Mosca](https://github.com/mcollina/mosca) (which is a node.js MQTT broker) with this command:

> `sudo npm install mosca`

and start the MQTT Broker server:

> `sudo nodejs mqtt_broker.js`

You can check the connection to Mongo DB database, after starting `mqtt_broker.js` script with these commands:
 
> `mongo`

> `use mqtt`

> `show collections`

and you find a `topics` collection.

**Please note** that you have to start before the **IoT Agent JSON server** and after the **MQTT Broker server**. 

**Please note** that **you can run the client only after that JMeter script is done**. 
This client sends data to IoT Agent server (and IoT Agent server sends them in Orion) and check data in Orion, so you need before to run the IoT Agent server and provide device/service via JMeter script. Here the command: 

> `sudo nodejs bin/client_mqtt_json.js`


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IDAS IP with **idas** and **orion** aliases according to your instances: 

> `192.168.111.117 idas`

> `192.168.111.9 orion`

Copy in the **/tmp/** folder the **IoTAgent-JSON-1.8.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#iot-agent-json)

## Testing step by step ##

**Run the test** with the follow command (after the IoT Agent server is up and running): 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/IoTAgent-JSON-1.8.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotagent-json-1.8.0_yyyy-MM-dd HHmmss.csv`

Please note that in order to test the clients, the JMeter script provides device/service for testing and the second execution gives 2 errors. You can try again after to clean device/service using `IoTAgent-JSON-1.8.0.clean.jmx` script.   

### Run the client ###


**MQTT client**

Run the MQTT client (`sudo nodejs bin/client_mqtt_json.js`) and an example of execution is (don't forget to start the MQTT Broker `sudo nodejs mqtt_broker.js`):

	Connecting to MQTT Broker...
	
	Current configuration:	
	{
	    "host": "localhost",
	    "port": 1883,
	    "apikey": "1234",
	    "deviceId": "myDeviceId"
	}	
	
	Send to orion singleMeasure: t=92
	Message successfully published
	Send to orion multipleMeasure: t=91, l=2
	Message successfully published
	
	Read newer data from orion
	--------------------------------
	
	{"id":"LivingRoomSensor","type":"multiSensor","TimeInstant":{"type":"ISO8601","value":"2018-09-07T15:15:24.942Z","metadata":{}},"luminosity":{"type":"lumens","value":"2","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-09-07T15:15:24.942Z"}}},"temperature":{"type":"celsius","value":"91","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-09-07T15:15:24.942Z"}}}}
	
	Exiting client
	--------------------------------

#### Check data in Orion  ####

Finally after JMeter and client execution, you can check the data in Orion using this curl command:

`curl -v http://orion:1026/v2/entities/LivingRoomSensor -s -S --header "fiware-service: howtoService" --header "fiware-servicepath: /howto"`

Here an example of Orion's response (the last data in Orion):

	{"id":"LivingRoomSensor","type":"multiSensor","TimeInstant":{"type":"ISO8601","value":"2018-09-07T15:15:24.942Z","metadata":{}},"luminosity":{"type":"lumens","value":"2","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-09-07T15:15:24.942Z"}}},"temperature":{"type":"celsius","value":"91","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-09-07T15:15:24.942Z"}}}}

[Top](#iot-agent-json)