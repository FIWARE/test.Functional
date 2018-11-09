# Cygnus and mongo #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)
* [Testing with Storages](#testing-with-storages)

## Introduction ##

Cygnus is a is an easy to use, powerful, and reliable system to process and distribute data. Internally, Cygnus is based on [Apache NiFi](https://nifi.apache.org/docs.html), NiFi is a dataflow system based on the concepts of flow-based programming. 

[Top](#cygnus-and-mongo)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, two Virtual Machines you needed, which are: 

1. **Cygnus** - follow the instruction in the next step to install Cygnus from package. 
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance].
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-mongo)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Cygnus ###

In order to install Cygnus via source to test functionality in JMeter, you have to deploy an Ubuntu 16.04 VM.
Before to start the Cygnus installation you need also the **mongo** database up and running. 
In this test we are going to install mongo database on Cygnus VM. 
Connect on VM via SSH and install it.

1) Install mongo on the same VM

```text  
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
	echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
	sudo apt-get update
	sudo apt-get install -y mongodb-org
	sudo systemctl start mongod
```

**Open MongoDB access up to all IPs**

It's necessary to open the access of mongo to other IPs in the net for testing. So edit your MongoDB config file in the Orion VM as follow:

`sudo nano /etc/mongod.conf`

Look for the net line and comment out the **bindIp** line under it, which is currently limiting MongoDB connections to localhost:

```text
# network interfaces
net:
   port: 27017
#  bindIp: 127.0.0.1  <- comment out this line
```

Restart mongo daemon (mongod)

`sudo service mongod restart`

2) Install Cygnus 

After **mongodb** installation, you have to run the **install.sh** script provided in this folder to install the software. 
Please note that before to run the script, you must change the permission to *install.sh* file (i.e `chmod +x  install.sh`). To summarize, here the steps:

2.1) Simply configure the FIWARE Env variables:

	  MIRROR=https://archive.apache.org/dist
	  NIFI_VERSION=1.7.0
	  NIFI_BASE_DIR=/opt/nifi
	  NIFI_HOME=${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}
	  NIFI_BINARY_URL=/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz 
	  NIFI_LOG_DIR=${NIFI_HOME}/logs
	  
	  sudo mkdir ${NIFI_BASE_DIR}
	  sudo chmod 777 ${NIFI_BASE_DIR}
	  
2.2) Install jdk
	  
	  sudo apt-get update
	  sudo apt-get install default-jdk -y
  
  
2.3) Then download and decompress the package in the NIFI_HOME
  
	  curl -fSL ${MIRROR}/${NIFI_BINARY_URL} -o ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz
	  cd ${NIFI_BASE_DIR}
	  
	  echo "$(curl https://archive.apache.org/dist/${NIFI_BINARY_URL}.sha256) *${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz" | sha256sum -c - 
	  tar -xvzf ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_BASE_DIR} 
	  rm ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz
  
2.4) Now, download the last release the fiware-cygnus processors from the git hub repo
  
	  cd $NIFI_HOME
	  curl -L -o "nifi-ngsi-resources.tar.gz" "https://github.com/ging/fiware-cygnus/releases/download/FIWARE_7.4/nifi-ngsi-resources.tar.gz"
	tar -xvzf nifi-ngsi-resources.tar.gz -C ./ 
	  rm nifi-ngsi-resources.tar.gz 
	  cp nifi-ngsi-resources/nifi-ngsi-nar-1.0-SNAPSHOT.nar ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}/lib/nifi-ngsi-nar-1.0-SNAPSHOT.nar 
	  cp -r nifi-ngsi-resources/drivers ./ 
	  cp -r nifi-ngsi-resources/templates ${NIFI_HOME}/conf
     
2.5) To run NiFi in the background, use bin/nifi.sh start. This will initiate the application to begin running.
 
	cd $NIFI_HOME 
	./bin/nifi.sh start

To check the status use `./bin/nifi.sh status` and to stop use `./bin/nifi.sh stop` in the NIFI_HOME folder.
  
The server is listening on `http://localhost:8080/nifi`.


3) Use the **Orion-To-Mongo** template to build the connection with mongo.

Please access in the web interface at this link `http://public_ip:8080/nifi`. Use this [link](https://fiware-cygnus-ld.readthedocs.io/en/latest/installation_and_administration_guide/cygnus_gui/index.html#cygnus-user-interface) to configure mongo. 
You need to do configure some  Here the steps:

3.1) Drag the `Orion-To-Mongo` template. 

3.2) Configure `NGSIv2-HTTP-INPUT` block and set **HTTP Headers to receive as Attributes (Regex)** as ** .* ** in the `PROPERTIES` tab.

3.3) Configure `NGSIToMongo` block using the right URL for **Mongo URI** property in the `PROPERTIES` tab (in this case it's `localhost:27017`). Please set also **Enable Encoding** property to **false** in the same tab to disable the encoding.

3.4) Start all blocks.


### 2. Orion ###

Deploy an Orion Context Broker in FIWARE Lab, and set in the file host the Cygnus private IP:

> `sudo vi /etc/hosts` 

and add Cygnus IP as **cygnus** alias according to your instance:

> `192.168.111.156 cygnus`


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus and Orion IPs as **cygnus** and **orion** aliases according to your instance: 

> `192.168.111.156 mongo`

> `192.168.111.200 orion`


Copy in the **/tmp/** folder the **Cygnus-2.0.0_API.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#cygnus-and-mongo)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-2.0.0_API.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-2.0.0_api_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in Mongo DB using these commands:

```text
$ mongo
MongoDB shell version: 3.2.21
...
> show databases
local           0.000GB
sth_vehicles    0.000GB

> use sth_vehicles
switched to db sth_vehicles

> show collections
sth_/4wheels

> db['sth_/4wheels'].find()
	{ "_id" : ObjectId("5be563f9d105a34a4276606b"), "recvTime" : ISODate("2018-11-09T10:39:52.151Z"), "entityId" : "Car1", "entityType" : "Car", "attrName" : "speed", "attrType" : "Integer", "attrValue" : "16", "attrMetadata" : [ ] }
	{ "_id" : ObjectId("5be565c7d105a34a4276606c"), "recvTime" : ISODate("2018-11-09T10:47:35.524Z"), "entityId" : "Car1", "entityType" : "Car", "attrName" : "speed", "attrType" : "Integer", "attrValue" : "11", "attrMetadata" : [ ] }

```

[Top](#cygnus-and-mongo)


## Testing with Storages ##

You can also **run other tests** to check how Cygnus stores the context information by using the follow [documentation](../#cygnus-and-storages).

[Top](#cygnus-and-mongo)