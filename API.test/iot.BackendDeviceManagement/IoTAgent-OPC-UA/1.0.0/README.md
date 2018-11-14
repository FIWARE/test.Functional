# IoT Agent OPC UA #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##
This IoT Agent is designed to be a bridge between the [OPC Unified Architecture](http://www.opcua.us) protocol and the NGSI interface of a Orion Context Broker.

This IoT Agent OPC UA is part of [IDAS component](https://www.fiware.org/developers/catalogue/) which is the FIWARE GE reference implementation of the Backend Device Management GE provided by Engineering available at its [GitHub repository](https://github.com/Engineering-Research-and-Development/iotagent-opcua).

[Top](#iot-agent-opc-ua)

## Testing environment ##
The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack.
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
2. **IoT Agent IoT Agent OPC UA GE** - select a "base_ubuntu_16.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#iot-agent-opc-ua)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:


### 1. Orion Context Broker ###

Deploy an Orion VM in FIWARE Lab.


### 2. IoT Agent IoT Agent OPC UA GE ###

Before to run the IoT Agent you need to install Node (8 or later) in the Ubuntu VM. Here the steps to prepare the environment to test the IoT Agent:

1. Update of the packages

> `sudo apt-get update`

2. Install Node

> `curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -` 

> `sudo apt-get install nodejs`

Check the versions for both using these commands `nodejs -v` (v8.12.0) and `npm -v` (6.4.1). 

3. Get the IoT Agent from the repository at this [link](https://github.com/Engineering-Research-and-Development/iotagent-opcua) and download it (in the **/home/ubuntu** folder):

> `sudo git clone https://github.com/Engineering-Research-and-Development/iotagent-opcua`

> `cd iotagent-opcua`

> `sudo npm install`

4. Open and edit the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP with **orion** alias according to your instance (because we are going to the use Orion Context Broker to store attributes provided by IoT Agent as configured in *config.json*): 

> `192.168.111.125 orion`

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

and check the version (`3.2.21`) using these two commands:

> `mongo`

> `db.version()`

> `exit`

6. Before to start the IoT Agent, please edit the `config.properties` file using *orion* as alias and *localhost* for mongo.

> `node index.js`

You can also use the **config.json** file, using this command:

> `node index.js config.json`
 

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IPs with **idas** and **orion** aliases according to your instances: 

> `192.168.111.120 idas`

> `192.168.111.125 orion`

Copy in the **/tmp/** folder the **IoTAgent-OPC-UA.1.0.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#iot-agent-opc-ua)

## Testing step by step ##

**Run the test** with the follow command (after the IoT Agent server is up and running - `node index.js`): 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/IoTAgent-OPC-UA.1.0.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotagent-opcua-1.0.0_yyyy-MM-dd HHmmss.csv`


### Run the IoT Agent Car Server ###

Here the steps on how to configure IoT Agent OPC UA GE; first of all you need to download an OPC UA CAR SERVER with NodeOPCUA from [github](https://github.com/Engineering-Research-and-Development/opc-ua-car-server).

> `git clone https://github.com/Engineering-Research-and-Development/opc-ua-car-server`

> `cd opc-ua-car-server`

> `npm install`

> `node car.js`

the server is listening on 4334 port.

Before to start the server you have to install the certificate in the `opc-ua-car-server/node_modules/node-opcua` folder. To create the certificate use these commands:

> `cd /home/ubuntu/opc-ua-car-server/node_modules/node-opcua`

> `sudo node bin/crypto_create_CA.js demo`

return in the `/home/ubuntu/opc-ua-car-server` to start the server:

> `node index.js config.json`


#### Check data in Orion  ####

Finally after JMeter and client execution, you can check the data in Orion using this curl command:

`curl -v http://orion:1026/v2/entities/car1_Car -s -S --header "fiware-service: opcua_car" --header "fiware-servicepath: /demo"`

Here an example of Orion's response (the last data in Orion):
	
	{"id":"car1_Car","type":"Car","Accelerate_info":{"type":"commandResult","value":" ","metadata":{}},"Accelerate_status":{"type":"commandStatus","value":"UNKNOWN","metadata":{}},"Engine_Oxigen":{"type":"Number","value":"10.299999999999999","metadata":{}},"Engine_Temperature":{"type":"Number","value":"83","metadata":{}},"Fake":{"type":"Text","value":" ","metadata":{}},"Passenger":{"type":"Boolean","value":" ","metadata":{}},"Speed":{"type":"Number","value":"0","metadata":{}},"Stop_info":{"type":"commandResult","value":" ","metadata":{}},"Stop_status":{"type":"commandStatus","value":"UNKNOWN","metadata":{}}}


[Top](#iot-agent-opc-ua)