# Cygnus and Mongo #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

In this section, it's presented the Cygnus configuration with **Mongo DB** in order to test the storage functionalities. 
Within this script there are some Orion's features like subscription, add entity and delete of both subscription and entity, but the goal of the script is to check if your data (context) is really stored in the Mongo database.  

[Top](#cygnus-and-mongo)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, two Virtual Machines you needed, which are: 

1. **Orion Context Broker GE and Cygnus** - follow the instruction in the next step to install both Orion and Cygnus via source on the same VM. 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-mongo)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Orion Context Broker and Cygnus ###

In order to check the Cygnus with Mongo DB you have to install Orion and Cygnus on Centos 7 VM. So in the FIWARE Lab deploy a Centos 7 VM (base_centos_7) with flavor **m1.medium**. Connect on VM (via SSH).

#### Install Orion #####

Download the Orion 1.13.0 version using this command:

> `wget -O contextBroker-1.13.0-1.x86_64.rpm https://nexus.lab.fiware.org/repository/el/7/x86_64/release/contextBroker-1.13.0-1.x86_64.rpm` 

Install some dependencies:

> `sudo yum install boost boost-devel boost-doc`

Install and start mongodb:
 
create a `mongodb-org.repo` file:
 
> `sudo vi /etc/yum.repos.d/mongodb-org.repo`

add these lines in to mongodb-org.repo:

	[mongodb-org-3.4]
	name=MongoDB Repository
	baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
	gpgcheck=1
	enabled=1
	gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc

and install mongo:

> `sudo yum repolist`

> `sudo yum install mongodb-org`

> `sudo systemctl start mongod`
   
Install and start orion:
   
> `sudo rpm -i contextBroker-1.13.0-1.x86_64.rpm`

> `sudo service contextBroker start`

and check the 1.13.0 version of Orion

> `curl http://localhost:1026/version`


**Open MongoDB access up to all IPs**

It's necessary to open the access of mongo to other IPs in the net for testing. So edit your MongoDB config file in the Orion VM as follow:

`sudo vi /etc/mongod.conf`

Look for the net line and comment out the **bindIp** line under it, which is currently limiting MongoDB connections to localhost:

```text
# network interfaces
net:
   port: 27017
#  bindIp: 127.0.0.1  <- comment out this line
```

Restart mongo daemon (mongod)

`sudo service mongod restart`


#### Install Cygnus #####

In order to install Cygnus via source copy in `/home/centos` folder the **install.sh** and **start.sh** script provided in this folder to install Cygnus. 
You have to run the scripts as root user. Before to run these scripts you have to change the permissions. So type these commands:  

> `sudo -i`

> `cd /home/centos`

Copy install.sh and start.sh files on VM, and change permissions:

> `chmod +x install.sh`

> `chmod +x start.sh`


Run the installation:

> `./install.sh`

At the end of execution, the script copies for you, two default files (*agent_ngsi_mongo.conf* and *cygnus_instance_mongo.conf*) in the `/usr/cygnus/conf` folder. You have to edit these files in order to complete the test with Mongo as follow: 

**`agent_ngsi_mongo.conf`** 

Here the sections to change:
1.	*General configuration template* - use only the sink and channel that you are using and in this case only mongo-sink and mongo-channel
2.	*Source configuration* - in the channels properties choose only one (mongo-channel)
3.	*NGSIMongoSink configuration* - uncomment all properties and choose for mongo db configurations: mongo_hosts with username and password empty as follow: 

```text
cygnus-ngsi.sinks.mongo-sink.mongo_hosts = localhost:27017 
cygnus-ngsi.sinks.mongo-sink.mongo_username =
cygnus-ngsi.sinks.mongo-sink.mongo_password =
```

**`cygnus_instance_mongo.conf`**

Use the follow properties: 

```text
CONFIG_FILE = /usr/cygnus/conf/agent_ngsi_mongo.conf
AGENT_NAME = cygnus-ngsi
```

Finally, run the server with this command:

> `./start.sh`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP of previous VM as **cygnus** alias according to your instance (Cygnus is installed in to Orion VM): 

> `192.168.111.87 cygnus`

Copy in the **/tmp/** folder the **Cygnus-1.9.0_mongo.jmx** file.

#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#cygnus-and-mongo)

## Testing step by step ##

### 1. First test (with persistence = row) ### 

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-1.9.0_mongo.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.9.0_mongo_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in Mongo DB using these commands:

```text
$ mongo
MongoDB shell version v3.4.15
...
> show databases
admin           0.000GB
local           0.000GB
orion           0.000GB
orion-vehicles  0.000GB
sth_vehicles    0.000GB

> use sth_vehicles
switched to db sth_vehicles

> show collections
sth_/4wheels_Car1_Car

> db['sth_/4wheels_Car1_Car'].find()

{ "_id" : ObjectId("5b2cb72a6dc8e308503f1a02"), "recvTime" : ISODate("2018-06-22T08:45:19.089Z"), "attrName" : "speed", "attrType" : "Integer", "attrValue" : "120" }
{ "_id" : ObjectId("5b2cb7a46dc8e308503f1a03"), "recvTime" : ISODate("2018-06-22T08:47:24.760Z"), "attrName" : "speed", "attrType" : "Integer", "attrValue" : "38" }
```

### 2. Second test (with persistence = column) ###

Before to start the test with persistence = column, you need to set in the **agent_ngsi_mongo.conf** the **column** attribute for **attr_persistence** instead of (default or previous) **row**:

`attr_persistence = column`

and restart Cygnus (via start.sh script). 

Please note that it's not necessary to provide (perfect structure) data in Mongo DB as should be done in the other storage systems.

Now you are ready to run the test.  
 
**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-1.9.0_mongo_column.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.9.0_mongo_column_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in Mongo DB using these commands:

```text
$ mongo
MongoDB shell version v3.4.15
...
> show databases
admin           0.000GB
local           0.000GB
orion           0.000GB
orion-vehicles  0.000GB
sth_vehicles    0.000GB

> use sth_vehicles
switched to db sth_vehicles

> show collections
sth_/4wheels_Car1_Car

> db['sth_/4wheels_Car1_Car'].find()

{ "_id" : ObjectId("5b2cba7a6dc8e3098e3a198e"), "recvTime" : ISODate("2018-06-22T08:59:23.359Z"), "speed" : "95" }
{ "_id" : ObjectId("5b2cbb136dc8e3098e3a198f"), "recvTime" : ISODate("2018-06-22T09:01:45.384Z"), "speed" : "6" }
```

[Top](#cygnus-and-mongo)