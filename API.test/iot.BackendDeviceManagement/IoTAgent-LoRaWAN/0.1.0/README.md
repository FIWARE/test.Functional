# IoT Agent LoRaWAN #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##
This IoT Agent allows to connect different LoRaWAN network servers, to forward data produced by LoRaWAN nodes into FIWARE (through an Orion Context Broker). Currently supported The Things Network and LoRaServer.io network servers.
IoT Agent LoRaWAN is part of [IDAS component](https://catalogue.fiware.org/enablers/backend-device-management-idas/downloads) which is the FIWARE GE reference implementation of the Backend Device Management GE provided by ATOS available at its [GitHub repository](https://github.com/Fiware/iot.IoTagent-LoraWAN).

[Top](#iot-agent-lorawan)

## Testing environment ##
The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack.
In order to test this GE, please deploy three Virtual Machines, which are: 

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
2. **IoT Agent LoRaWAN GE** - select a "base_ubuntu_16.04" image in the FIWARE Cloud Portal to get IoT Agents script from github.
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#iot-agent-lorawan)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:


### 1. Orion Context Broker ###

Deploy an Orion VM in FIWARE Lab.


### 2. IoT Agent LoRaWAN GE ###

Before to run the IoT Agent you need to install NodeJS and GitHub softwares in the Ubuntu VM. Before to install these softwares, an update of the packages is required using the `apt-get` command, so run in the shell the `sudo apt-get update` command. Here the steps to prepare the softwares to test the IoT Agent:

1. Update of the packages

> `sudo apt-get update`

2. Install NodeJS (nodejs and npm)

> `sudo apt-get install nodejs` 

> `sudo apt-get install npm`

Check the versions for both using these commands `nodejs -v` (v4.2.6) and `npm -v` (3.5.2). 

3. Get the IoT Agent from the repository at this [link](https://github.com/Fiware/iot.IoTagent-LoraWAN.git) and download it (in the **/home/ubuntu** folder):

> `git clone https://github.com/Fiware/iot.IoTagent-LoraWAN`

> `cd iot.IoTagent-LoraWAN`

> `sudo npm install`

4. Open and edit the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Orion IP with **orion** alias according to your instance (because we are going to the use Orion Context Broker to store attributes provided by IoT Agent): 

> `192.168.111.228 orion`

you can try using this command:

> `curl http://orion:1026/version`

5. Install **MongoDB** in order to use this database as the '*Device Registry*'. Please note that if you don't want to use the *MongoDB database* please change the '*type*' attribute of *deviceRegistry* in **memory** instead of **mongodb** in the *config-lora.json* file and JMeter script is configured with Mongo DB.
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

Here the steps on how to configure IoT Agent LoRa GE; basically how to start the IoT Agent LoRa server (via `config-lora.js`) and how to run the MQTT client to send data to IoT Agent server and read the context information in Orion.

**IoT Agent LoRa server**

Copy the `config-lora.js` file provided in the root folder. Basically the *config-lora.js* is a copy of *config.js* file located in the iot.IoTagent-LoraWAN folder downloaded from git; you can copy it (`cp config.js config-lora.js`) and set the Orion IP as *'orion'* instead of *'localhost'* because we are using different VMs for them.
To start the IoT Agent server please use:

> `sudo nodejs bin/iotagent-lora config-lora.js`

**MQTT Broker**

Install [Mosca](https://github.com/mcollina/mosca) (which is a node.js MQTT broker) with this command:

> `sudo npm install mosca`

and start the MQTT Broker server:

> `sudo nodejs mqtt_broker.js`

You can check the connection to Mongo DB database with these commands:
 
> `mongo`

> `use mqtt`

> `show collections`

and you find a `topics` collection.


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IDAS IP with **idas** and **orion** aliases according to your instances: 

> `192.168.111.232 idas`

> `192.168.111.228 orion`

Copy in the **/tmp/** folder the **IoTAgent-LoRaWAN-0.1.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#iot-agent-lorawan)

## Testing step by step ##

**Run the test** with the follow command (after the IoT Agent server is up and running): 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/IoTAgent-LoRaWAN-0.1.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotagent-lora-0.1_yyyy-MM-dd HHmmss.csv`

[Top](#iot-agent-lorawan)