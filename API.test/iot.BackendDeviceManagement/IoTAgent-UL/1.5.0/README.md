# IoT Agent UltraLight #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##
IoT Agent UltraLight is designed to be a bridge between an UltraLight2.0 protocol and the FIWARE NGSI standard used in FIWARE, like the Orion Context Broker. 
This IoT Agent UltraLight (HTTP/MQTT transport) is part of [IDAS component](https://catalogue.fiware.org/enablers/backend-device-management-idas/downloads) which is the FIWARE GE reference implementation of the Backend Device Management GE provided by ATOS available at its [GitHub repository](https://github.com/Fiware/iot.IoTagent-UL/releases/tag/1.5.0).

[Top](#iot-agent-ultralight)

## Testing environment ##
The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack.
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
2. **IoT Agent UltraLight GE** - select a "base_ubuntu_16.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#iot-agent-ultralight)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:


### 1. Orion Context Broker ###

Deploy an Orion VM in FIWARE Lab.


### 2. IoT Agent UltraLight GE ###

Before to run the IoT Agent you need to install NodeJS in the Ubuntu VM. Here the steps to prepare the environment to test the IoT Agent:

1. Update of the packages

> `sudo apt-get update`

2. Install NodeJS (nodejs and npm)

> `sudo apt-get install nodejs` 

> `sudo apt-get install npm`

Check the versions for both using these commands `nodejs -v` (v4.2.6) and `npm -v` (3.5.2). 

3. Get the IoT Agent from the repository at this [link](https://github.com/Fiware/iot.IoTagent-UL.git) and download it (in the **/home/ubuntu** folder):

> `git clone https://github.com/Fiware/iot.IoTagent-UL.git`

> `cd iot.IoTagent-UL`

> `git checkout tags/1.5.0`

> `sudo npm install`

4. Open and edit the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP with **orion** alias according to your instance (because we are going to the use Orion Context Broker to store attributes provided by IoT Agent as configured in *config-ul.json*): 

> `192.168.111.228 orion`

you can try using this command:

> `curl http://orion:1026/version`

5. Install **MongoDB** in order to use this database as the '*Device Registry*'. Please note that if you don't want to use the *MongoDB database* please change the '*type*' attribute of *deviceRegistry* in **memory** instead of **mongodb** in the *config-ul.json* file and JMeter script is configured with Mongo DB.
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

and check the version (`3.2.20`) using these two commands:

> `mongo`

> `db.version()`

> `exit`
 
### Run the IoT Agent ###

Here the steps on how to configure IoT Agent UltraLight GE; basically how to start the IoT Agent UltraLight server (via `config-ul.js`) and how to run two clients, both HTTP (via `client_http_ul.js`) and MQTT (via `client_mqtt_ul.js`) protocols respectively to send data to IoT Agent server and read the context information in Orion.

**IoT Agent UltraLight server**

Copy the `config-ul.js` file provided in the root folder. Basically the *config-ul.js* is a copy of *config.js* file located in the **iot.IoTagent-UL** folder downloaded from git; you can copy it (`cp config.js config-ul.js`) and set the Orion IP as *'orion'* instead of *'localhost'* because we are not using the Orion via localhost; it's in a different VM.
To start the IoT Agent server please use:

> `cd iot.IoTagent-UL`

> `sudo nodejs bin/iotagent-ul config-ul.js`

**HTTP and MQTT clients**

Copy the `client_http_ul.js` and `client_mqtt_ul.js` files (provided in the root folder) into `iot.IoTagent-UL/bin` folder of github project downloaded from git.

Please note that to use the MQTT client you need to start a MQTT Broker server. In order to do this, copy the `mqtt_broker.js` file in the `iot.IoTagent-UL` folder too. The MQTT Broker uses the *Mongo DB* database, so it's necessary that a mongo instance is up and running. 
Install [Mosca](https://github.com/mcollina/mosca) (which is a node.js MQTT broker) with this command:

> `sudo npm install mosca`

and start the MQTT Broker server:

> `cd iot.IoTagent-UL`

> `sudo nodejs mqtt_broker.js`

You can check the connection to Mongo DB database with these commands:
 
> `mongo`

> `use mqtt`

> `show collections`

and you can see a `topics` collection.

Please note that **you can run the clients only after that JMeter script is done**. 
These clients send data to IoT Agent server (and IoT Agent server sends them in Orion) and check data in Orion, so you need before to run the IoT Agent server and provide device/service via JMeter script. Here the two commands: 

> `sudo nodejs bin/client_http_ul.js`

> `sudo nodejs bin/client_mqtt_ul.js`

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IDAS IP with **idas** and **orion** aliases according to your instances: 

> `192.168.111.232 idas`

> `192.168.111.228 orion`

Copy in the **/tmp/** folder the **IoTAgent-UL-1.5.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#iot-agent-ultralight)

## Testing step by step ##

**Run the test** with the follow command (after the IoT Agent server is up and running): 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/IoTAgent-UL-1.5.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotagent-ul-1.5.0_yyyy-MM-dd HHmmss.csv`

Please note that in order to test the clients, the JMeter script provides device/service for testing and the second execution gives 2 errors. You can try again after to clean device/service using `IoTAgent-UL-1.5.0.clean.jmx` script.   

### Run the clients ###

**HTTP client**

Run the HTTP client (`sudo nodejs bin/client_http_ul.js`) and an example of execution is:

	Current configuration:

	{
	    "binding": "HTTP",
	    "host": "localhost",
	    "port": 1883,
	    "httpPort": 7896,
	    "apikey": "1234",
	    "deviceId": "myDeviceId",
	    "httpPath": "/iot/d"
	}
	
	
	Send to orion singleMeasure: a=41
	HTTP measure accepted
	Send to orion multipleMeasure: a=20, b=52
	HTTP measure accepted
	
	Read newer data from orion
	--------------------------------
	
	{"id":"MQTT_Device","type":"AnMQTTDevice","TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:49:13.090Z","metadata":{}},"a":{"type":"celsius","value":"20","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:49:13.090Z"}}},"b":{"type":"degrees","value":"52","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:49:13.090Z"}}},"ping_info":{"type":"commandResult","value":" ","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:51:21.753Z"}}},"ping_status":{"type":"commandStatus","value":"UNKNOWN","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:51:21.753Z"}}}}
	
	Exiting client
	--------------------------------

**MQTT client**

Run the MQTT client (`sudo nodejs bin/client_mqtt_ul.js`) and an example of execution is (don't forget to start the MQTT Broker `sudo nodejs mqtt_broker.js`):

	Connecting to MQTT Broker...
	
	Current configuration:
	
	{
	    "binding": "MQTT",
	    "host": "localhost",
	    "port": 1883,
	    "httpPort": 7896,
	    "apikey": "1234",
	    "deviceId": "myDeviceId",
	    "httpPath": "/iot/d"
	}
	
	
	Send to orion singleMeasure: a=25
	Message successfully published
	Send to orion multipleMeasure: a=78, b=21
	Message successfully published
	Send to orion mqttCommand: ping=45
	Message successfully published
	
	Read newer data from orion
	--------------------------------
	
	{"id":"MQTT_Device","type":"AnMQTTDevice","TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:59.771Z","metadata":{}},"a":{"type":"celsius","value":"78","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:56.269Z"}}},"b":{"type":"degrees","value":"21","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:56.269Z"}}},"ping_info":{"type":"commandResult","value":"45","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:59.771Z"}}},"ping_status":{"type":"commandStatus","value":"OK","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:59.771Z"}}}}
	
	Exiting client
	--------------------------------
    
#### Check data in Orion  ####

Finally after JMeter and client execution, you can check the data in Orion using this curl command:

`curl -v http://orion:1026/v2/entities/MQTT_Device -s -S --header "fiware-service: howtoService" --header "fiware-servicepath: /howto"`

Here an example of Orion's response (the last data in Orion):
	
	{"id":"MQTT_Device","type":"AnMQTTDevice","TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:59.771Z","metadata":{}},"a":{"type":"celsius","value":"78","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:56.269Z"}}},"b":{"type":"degrees","value":"21","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:56.269Z"}}},"ping_info":{"type":"commandResult","value":"45","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:59.771Z"}}},"ping_status":{"type":"commandStatus","value":"OK","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-19T07:50:59.771Z"}}}}

[Top](#iot-agent-ultralight)