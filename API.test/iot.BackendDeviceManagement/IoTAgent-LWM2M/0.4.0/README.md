# IoT Agent LWM2M #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##
IoT Agent LWM2M is designed to be a bridge between an HTTP/MQTT+JSON based protocol and the FIWARE NGSI standard used in FIWARE, like the Orion Context Broker.
This IoT Agent LWM2M (CoaP transport) is part of [IDAS component](https://catalogue.fiware.org/enablers/backend-device-management-idas/downloads) which is the FIWARE GE reference implementation of the Backend Device Management GE provided by ATOS available at its [GitHub repository](https://github.com/Fiware/iot.IoTagent-LWM2M/releases/tag/0.4.0).


[Top](#iot-agent-lwm2m)

## Testing environment ##
The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack.
In order to test this GE, three Virtual Machines you needed, which are: 

1. **IoT Agent LWM2M GE** - select a "base_ubuntu_16.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#iot-agent-lwm2m)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. IoT Agent LWM2M GE ###

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

> `192.168.111.83 orion`

5. Get the IoT Agent from the repository at this [link](https://github.com/Fiware/iot.IoTagent-LWM2M.git) and download it (in the **/home/ubuntu** folder):

> `git clone https://github.com/Fiware/iot.IoTagent-LWM2M.git`

> `cd iot.IoTagent-LWM2M`

> `sudo npm install`

6. Install **MongoDB** in order to use this database as the '*Device Registry*'. Please note that if you don't want to use the *MongoDB database* please change the '*type*' attribute of *deviceRegistry* in **memory** instead of **mongodb** in the *config-json.json* file and JMeter script is configured with Mongo DB.
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

> `exit`
 

### Run the IoT Agent ###

Here the steps on how to configure IoT Agent LWM2M GE; basically how to start the IoT Agent LWM2M server (via `config-lwm2m.js`) and how to run the lwm2m client to send data to IoT Agent server and read the context information in Orion.

**IoT Agent LWM2M server**

Copy the `config-lwm2m.js` file provided in the root folder. Basically the *config-lwm2m.js* is a copy of *config.js* file located in the iot.IoTagent-JSON folder downloaded from git; you can copy it (`cp config.js config-lwm2m.js`) and set the Orion IP as *'orion'* instead of *'localhost'* because we are using different VMs for them.
To start the IoT Agent server please use:

> `sudo nodejs bin/lwm2mAgent.js config-lwm2m.js`

**IoT Agent LWM2M client**

Download and install the client from [github](https://github.com/telefonicaid/lwm2m-node-lib.git) using these commands:

> `git clone https://github.com/telefonicaid/lwm2m-node-lib.git`

> `cd lwm2m-node-lib`

> `sudo npm install`

Copy `client_lwm2m_device.js` and `client_lwm2m_service.js` files (provided in the root folder) into `lwm2m-node-lib/bin` folder of github project downloaded from git.

Please note that **you can run clients only after that JMeter script is done**. 
This client sends data to IoT Agent server (and IoT Agent server sends them in Orion) and check data in Orion, so you need before to run the IoT Agent server and provide device/service via JMeter script.

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IDAS IP with **idas** and **orion** aliases according to your instances: 

> `192.168.111.80 idas`

> `192.168.111.83 orion`

Copy in the **/tmp/** folder the **IoTAgent-JSON-1.6.2.jmx** file.


#### Install JMeter 3.3 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 3.3

4. `sudo wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.3.tgz` - download JMeter 3.3

5. `sudo tar -xf apache-jmeter-3.3.tgz` - unpack JMeter

[Top](#iot-agent-lwm2m)

## Testing step by step ##

**Run the test** with the follow command (after the IoT Agent server is up and running): 

`./apache-jmeter-3.3/bin/jmeter -n -t /tmp/IoTAgent-LWM2M.0.4.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotagent-lwm2m-0.4.0_yyyy-MM-dd HHmmss.csv`

Please note that in order to test the clients, the JMeter script provides device/service for testing and the second execution gives 2 errors. You can try again after to clean device/service using `IoTAgent-LWM2M.0.4.0.clean.jmx` script.   

### Run the client ###


**Client device**

Run the client (`sudo nodejs bin/client_lwm2m_device.js`) in the **lwm2m-node-lib** folder:

	 Create object
	 
	 Object:
	 --------------------------------
	 ObjectType: 7392
	 ObjectId: 0
	 ObjectUri: /7392/0
	 Create connection
	 time=2018-02-20T16:40:03.806Z | lvl=INFO | corr=n/a | trans=n/a | op=LWM2MLib.COAPRouter | msg=Starting COAP Server on port [36508]
	 time=2018-02-20T16:40:03.809Z | lvl=INFO | corr=n/a | trans=n/a | op=LWM2MLib.COAPRouter | msg=COAP Server started successfully
	 
	 Connected:
	 --------------------------------
	 Device location: rd/1
	 
	 --------------------------------
	 Send data after 5 seconds
	 Send first data: battery = 98
	 
	 Object:
	 --------------------------------
	 ObjectType: 7392
	 ObjectId: 0
	 ObjectUri: /7392/0
	 
	 Attributes:
        -> 1: 98
    
    Send second data
    
    Object:
    --------------------------------
    ObjectType: 7392
    ObjectId: 0
    ObjectUri: /7392/0
    
    Attributes:
        -> 1: 98
        -> 2: Hello world
        
    Send third data
    
    Object:
    --------------------------------
    ObjectType: 7392
    ObjectId: 0
    ObjectUri: /7392/0
    
    Attributes:
        -> 1: 98
        -> 2: Hello world
        -> 3: [8,8]
        
    --------------------------------
    Update data
    Update first data: battery = 7
    
    Object:
    --------------------------------
    ObjectType: 7392
    ObjectId: 0
    ObjectUri: /7392/0
    
    Attributes:
        -> 1: 7
        -> 2: Hello world
        -> 3: [8,8]
        
    --------------------------------
    Waiting to read data from Context Broker
    {"type":"number","value":"7","metadata":{}}
    
    Exiting client
    --------------------------------


**Client service**

Run the client (`sudo nodejs bin/client_lwm2m_service.js`) in the **lwm2m-node-lib** folder:

	 Connected:
	 --------------------------------
	 
	 Device location: rd/2	 
	 --------------------------------
	 Send data
	 Send Longitude and Latitude
	 
	 Object:
	 --------------------------------
	 ObjectType: 6
	 ObjectId: 0
	 ObjectUri: /6/0
	 
	 Attributes:
        -> 0: 1
        
    Object:
    --------------------------------
    ObjectType: 6
    ObjectId: 0
    ObjectUri: /6/0
    
    Attributes:
        -> 0: 1
        -> 1: -4
        
    Send Temperature
    
    Object:
    --------------------------------
    ObjectType: 3303
    ObjectId: 0
    ObjectUri: /3303/0
    
    Attributes:
        -> 0: 23
        
    Send Power: On
    
    Object:
    --------------------------------
    ObjectType: 3312
    ObjectId: 0
    ObjectUri: /3312/0
    
    Attributes:
        -> 0: On
        
    {"id":"weather1:WeatherBaloon","type":"WeatherBaloon","Power Control":{"type":"Boolean","value":" ","metadata":{}}}
   
    Exiting client
    --------------------------------


#### Check data in Orion  ####

Finally after JMeter and client device execution, you can check the data in Orion using this curl command:

`curl -v http://orion:1026/v2/entities/Robot:robot1 -s -S --header "fiware-service: smartGondor" --header "fiware-servicepath: /gardens"`

Here an example of Orion's response (the last data in Orion):

	{"id":"Robot:robot1","type":"Robot","Battery":{"type":"number","value":"7","metadata":{}},"Position_info":{"type":"commandResult","value":" ","metadata":{}},"Position_result":{"type":"commandResult","value":" ","metadata":{}},"Position_status":{"type":"commandStatus","value":"UNKNOWN","metadata":{}}}
	
and a client service execution:

`curl -v http://orion:1026/v2/entities/weather1:WeatherBaloon -s -S --header "fiware-service: smartGondor" --header "fiware-servicepath: /gardens"`

Here an example of Orion's response (the last data in Orion):

	{"id":"weather1:WeatherBaloon","type":"WeatherBaloon","Power Control":{"type":"Boolean","value":" ","metadata":{}}}

[Top](#iot-agent-lwm2m)