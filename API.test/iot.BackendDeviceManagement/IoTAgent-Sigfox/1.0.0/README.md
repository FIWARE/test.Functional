# IoT Agent Sigfox #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##
This IoT Agent is designed to be a bridge between the Sigfox callbacks protocol and the OMA NGSI protocol used by the Orion Context Broker as well as by other components of the FIWARE ecosystem. 
The IoT Agent is part of [IDAS component](https://catalogue.fiware.org/enablers/backend-device-management-idas/downloads) which is the FIWARE GE reference implementation of the Backend Device Management GE available at its [GitHub repository](https://github.com/telefonicaid/sigfox-iotagent.git).


[Top](#iot-agent-sigfox)

## Testing environment ##
The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack.
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
2. **IoT Agent Sigfox GE** - select a "base_ubuntu_16.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#iot-agent-sigfox)

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

3. Get the IoT Agent from the repository at this [link](https://github.com/telefonicaid/sigfox-iotagent.git) and download it (in the **/home/ubuntu** folder):

> `git clone https://github.com/telefonicaid/sigfox-iotagent.git`

> `cd sigfox-iotagent`

> `sudo npm install`

4. Open and edit the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP with **orion** alias according to your instance (because we are going to the use Orion Context Broker to store attributes provided by IoT Agent as configured in *config-sigfox.json*): 

> `192.168.111.228 orion`

you can try using this command:

> `curl http://orion:1026/version`

5. Install **MongoDB** in order to use this database as the '*Device Registry*'. Please note that if you don't want to use the *MongoDB database* please change the '*type*' attribute of *deviceRegistry* in **memory** instead of **mongodb** in the *config-sigfox.json* file and JMeter script is configured with Mongo DB.
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

Here the steps on how to configure IoT Agent Sigfox GE; basically how to start the IoT Agent Sigfox server (via `config-sigfox.js`) and how to run the client with `client_sigfox_devce.js` script to send data to IoT Agent server and read the context information in Orion.

**IoT Agent Sigfox server**

Copy the `config-sigfox.js` file provided in the root folder. Basically the *config-sigfox.js* is a copy of *config.js* file located in the **sigfox-iotagent** folder downloaded from git; you can copy it (`cp config.js config-sigfox.js`) and set the Orion IP as *'orion'* instead of *'localhost'* because we are not using the Orion via localhost; it's in a different VM. There is also commented the IoT Manager section.
To start the IoT Agent server please use:

> `cd sigfox-iotagent`

> `sudo nodejs bin/iotagent-sigfox config-sigfox.js`

**HTTP client**

Copy the `client_sigfox_device.js` file (provided in the root folder) into `sigfox-iotagent/bin` folder of github project downloaded from git.

Please note that **you can run the clients only after that JMeter script is done**. 
The client send data to IoT Agent server (and IoT Agent server sends them in Orion) and check data in Orion, so you need before to run the IoT Agent server and provide the device via JMeter script. Here the two commands: 

> `sudo nodejs bin/client_sigfox_device.js`


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IDAS IP with **idas** and **orion** aliases according to your instances: 

> `192.168.111.232 idas`

> `192.168.111.228 orion`

Copy in the **/tmp/** folder the **IoTAgent-Sigfox-1.0.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#iot-agent-sigfox)

## Testing step by step ##

**Run the test** with the follow command (after the IoT Agent server is up and running): 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/IoTAgent-Sigfox-1.0.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotagent-sigfox-1.0.0_yyyy-MM-dd HHmmss.csv`

Please note that in order to test the clients, the JMeter script provides the device for testing and the second execution gives 2 errors. You can try again after to clean the device using `IoTAgent-Sigfox-1.0.0.clean.jmx` script.   

### Run the client ###

**The client**

Run the client (`sudo nodejs bin/client_sigfox_device.js`) and an example of execution is:

	 Current measure parameters:

	 -------------------------------------------------------
	 {
	    "id": "8405",
	    "time": "1430908992",
	    "statin": "0817",
	    "lng": -4,
	    "lat": 41
	 }
	
	 Update value for parameter [lng] set to [71]
	
	 Preparing params list (in exadecimal format)
	 --------------------------------
	 theCounter: 00000002 -> decimal = 2
	 theParam1: 00000000 -> decimal = 0
	 param2: 00 -> decimal = 0
	 tempDegreesCelsius: 6A -> decimal = 106
	 voltage: EEC9 -> decimal = 61129
	
	 Data compound = 00000002 + 00000000 + 00 + 6A + EEC9
	 Sending hex data = 0000000200000000006AEEC9 according to attribute mapping: theCounter[8] + theParam1[8] + param2[2] + tempDegreesCelsius[2] + voltage[4]
	
	 Data successfully sent
	
	 Read newer attributes from orion
	 --------------------------------
	
	 {"id":"sigApp2","type":"SIGFOX","TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z","metadata":{}},"lat":{"type":"String","value":"41","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"lng":{"type":"String","value":"71","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"param2":{"type":"Integer","value":"0","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"statin":{"type":"String","value":"0817","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"tempDegreesCelsius":{"type":"Integer","value":"106","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"theCounter":{"type":"Integer","value":"2","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"theParam1":{"type":"Integer","value":"0","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"time":{"type":"String","value":"1430908992","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"voltage":{"type":"Integer","value":"61129","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}}}
	
	 Exiting client
	 --------------------------------
    
#### Check data in Orion  ####

Finally after JMeter and client execution, you can check the data in Orion using this curl command:

`curl -v http://orion:1026/v2/entities/sigApp2 -s -S --header "fiware-service: howtoService" --header "fiware-servicepath: /howto"`

Here an example of Orion's response (the last data in Orion):

	{"id":"sigApp2","type":"SIGFOX","TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z","metadata":{}},"lat":{"type":"String","value":"41","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"lng":{"type":"String","value":"71","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"param2":{"type":"Integer","value":"0","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"statin":{"type":"String","value":"0817","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"tempDegreesCelsius":{"type":"Integer","value":"106","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"theCounter":{"type":"Integer","value":"2","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"theParam1":{"type":"Integer","value":"0","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"time":{"type":"String","value":"1430908992","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}},"voltage":{"type":"Integer","value":"61129","metadata":{"TimeInstant":{"type":"ISO8601","value":"2018-07-18T15:03:47.059Z"}}}}

[Top](#iot-agent-sigfox)