# IoT Agent UltraLight #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##
IoT Agent UltraLight is designed to be a bridge between an UltraLight2.0 protocol and the FIWARE NGSI standard used in FIWARE, like the Orion Context Broker. 
This IoT Agent UltraLight (HTTP/MQTT transport) is part of [IDAS component](https://catalogue.fiware.org/enablers/backend-device-management-idas/downloads) which is the FIWARE GE reference implementation of the Backend Device Management GE provided by ATOS available at its [GitHub repository](https://github.com/Fiware/iot.IoTagent-UL/releases/tag/1.5.2).

[Top](#iot-agent-ultralight)

## Testing environment ##
The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack.
In order to test this GE, three Virtual Machines you needed, which are: 

1. **IoT Agent UltraLight GE** - select a "base_ubuntu_16.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#iot-agent-ultralight)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. IoT Agent UltraLight GE ###

Before to run the IoT Agent you need to install NodeJS and GitHub softwares in the Ubuntu VM. Before to install these softwares, an update of the packages is required using the `apt-get` command, so run in the shell the `sudo apt-get update` command. Here the steps to prepare the softwares to test the IoT Agent:

1. Update of the packages

> `sudo apt-get update`

2. Install Git

> `sudo apt-get install git` 

3. Install NodeJS (nodejs and npm)

> `sudo apt-get install nodejs` 

> `sudo apt-get install npm`

Check the versions for both using these commands `nodejs -v` (v4.2.6) and `npm -v` (3.5.2). 

4. Open and edit the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP with **orion** alias according to your instance (because we are going to the use Orion Context Broker to store attributes provided by IoT Agent): 

> `192.168.111.244 orion`

5. Get the IoT Agent from the repository at this [link](https://github.com/Fiware/iot.IoTagent-UL.git) and download it (in the **/home/ubuntu** folder):

> `git clone https://github.com/Fiware/iot.IoTagent-UL.git`

> `cd iot.IoTagent-UL`

> `sudo npm install`

6. Install **MongoDB** in order to use this database as the '*Device Registry*'. Please note that if you don't want to use the *MongoDB database* please change the '*type*' attribute of *deviceRegistry* in **memory** instead of **mongodb** in the *config-ul.json* file and JMeter script is configured with Mongo DB.
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

and check the version (`3.2.19`) using these two commands:

> `mongo`

> `db.version()`
 

#### Run the IoT Agent ####

Here the steps on how to configure IoT Agent UltraLight, basically how to start the IoT Agent UltraLight and to run the client to read the context information in Orion.

1. config-ul.js

copy the `config-ul.js` file provided in the root folder. Basically the *config-ul.js* is a copy of *config.js* file located in the iot.IoTagent-UL folder; you can copy it (`cp config.js config-ul.js`) and set the Orion IP as *'orion'* instead of *'localhost'*.
To start the IoT Agent server please use:

> `sudo nodejs bin/iotagent-ul config-ul.js`

2. client_ul.js

copy the `client_ul.js` file provided in the root folder into `iot.IoTagent-UL/bin` folder of github project downloaded and **run it only after that JMeter script is done**. It's a client to send data in Orion and check them, so you need before to run the IoT Agent server and provide device/service via JMeter script: 

> `sudo nodejs bin/client_ul.js`


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IDAS IP with **idas** and **orion** aliases according to your instances: 

> `192.168.111.243 idas`

> `192.168.111.244 orion`

Copy in the **/tmp/** folder the **IoTAgent-UL-1.5.2.jmx** file.


#### Install JMeter 3.3 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 3.3

4. `sudo wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.3.tgz` - download JMeter 3.3

5. `sudo tar -xf apache-jmeter-3.3.tgz` - unpack JMeter

[Top](#iot-agent-ultralight)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.3/bin/jmeter -n -t /tmp/IoTAgent-UL-1.5.2.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotagent-ul-1.5.2_yyyy-MM-dd HHmmss.csv`

#### Check the data in Orion  ####

After JMeter execution, you can check the data in Orion using this curl command:

`curl -v http://orion:1026/v2/entities -s -S --header "fiware-service: howtoService" --header "fiware-servicepath: /howto"`

Here an example of Orion's response:

	[{"id":"TheDevice1","type":"DeviceType","TimeInstant":{"type":"ISO8601","value":" ","metadata":{}},"humidity":{"type":"float","value":" ","metadata":{}},"pressure":{"type":"float","value":" ","metadata":{}},"serialID":{"type":"02598347","value":null,"metadata":{}},"temperature":{"type":"float","value":" ","metadata":{}},"turn_info":{"type":"commandResult","value":" ","metadata":{}},"turn_status":{"type":"commandStatus","value":"UNKNOWN","metadata":{}}},{"id":"MQTT_Device","type":"AnMQTTDevice","TimeInstant":{"type":"ISO8601","value":"2018-02-06T16:57:18.300Z","metadata":{}},"a":{"type":"celsius","value":"59","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-02-06T16:57:18.300Z"}}},"b":{"type":"degrees","value":"65","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-02-06T16:57:18.300Z"}}}}]

while an example of execution of (IoT Agent) client (`sudo nodejs bin/client_ul.js`):

	Connecting to MQTT Broker...
	Send to orion singleMeasure: a=43
	HTTP measure accepted
	Send to orion multipleMeasure: a=59, b=65
	HTTP measure accepted
	
	Read newer data from orion
	--------------------------------
	
	{"id":"MQTT_Device","type":"AnMQTTDevice","TimeInstant":{"type":"ISO8601","value":"2018-02-06T16:57:18.300Z","metadata":{}},"a":{"type":"celsius","value":"59","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-02-06T16:57:18.300Z"}}},"b":{"type":"degrees","value":"65","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-02-06T16:57:18.300Z"}}}}
	Close client
	
	Exiting client
	--------------------------------

[Top](#iot-agent-ultralight)