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

1. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances). 
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-mongo)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Orion Context Broker ###

In order to check the Cygnus's APIs you can start from Orion Context Broker instance. For this test we are using an **orion-psb-image-R5.4** VM with flavor **m1.small**. Connect on VM (via SSH) and update the Orion to last version (1.7.0) using these commands:

`$ sudo yum install contextBroker`

`$ sudo service contextBroker restart`

`$ curl http://localhost:1026/version`

Follow these steps to install Cygnus (configuring the FIWARE repository):


`$ cat > /etc/yum.repos.d/fiware.repo <<EOL`

```text
[Fiware]
name=FIWARE repository
baseurl=http://repositories.lab.fiware.org/repo/rpm/x86_64/
gpgcheck=0
enabled=1
EOL
```
First, remove the older Cygnus version and install the newer:

`$ sudo yum remove cygnus`

`$ sudo yum install cygnus-common`

`$ sudo yum install cygnus-ngsi`


**Copy and edit template files**

Go in the **/usr/cygnus/conf** folder and copy these template files (no editing):

>**`flume-env.sh`**	   `$ sudo cp flume-env.sh.template flume-env.sh`

>**`krb5.conf`**    `$ sudo cp krb5.conf.template krb5.conf`

>**`grouping_rules.conf`**  `sudo cp grouping_rules.conf.template grouping_rules.conf`

>**`name_mappings.conf`**  `sudo cp name_mappings.conf.template name_mappings.conf`

No changes for these files (use as default):

>**`log4j.properties`** 	
	
>**`krb5_login.conf`** 

Copy cygnus configuration files from template appending the name your **`<id>`** (in this case **mongo**):

>**`agent_ngsi_<id>.conf`** 		`sudo cp agent_ngsi.conf.template agent_ngsi_mongo.conf`

>**`cygnus_instance_<id>.conf`**  	`sudo cp cygnus_instance.conf.template cygnus_instance_mongo.conf`


Edit **agent_ngsi_mongo.conf** and **cygnus_instance_mongo.conf** files as follow:

**`agent_ngsi_mongo.conf`** 

Here the sections to change:
1.	*General configuration template* - use only the sink and channel that you are using and in this case only mongo-sink and mongo-channel
2.	*Source configuration* - in the channels properties choose only one (mongo-channel)
3.	*OrionMongoSink configuration* - uncomment all properties and choose for mongo db configurations: hosts = localhost:27107 with username and password empty

**`cygnus_instance_mongo.conf`**

Use the follow properties: 
```text
CONFIG_FILE = /usr/cygnus/conf/agent_ngsi_mongo.conf
AGENT_NAME = cygnus-ngsi
```

**Install JDK**
 
`$ sudo yum install java`

**Start Cygnus**

`$ sudo service cygnus start` 

**Open MongoDB access up to all IPs**

It's necessary to open the access of mongo to other IPs in the net. So edit your MongoDB config file in the Orion VM as follow:

`$ sudo vi /etc/mongod.conf`

Look for the net line and comment out the **bindIp** line under it, which is currently limiting MongoDB connections to localhost:

```text
# network interfaces
net:
   port: 27017
#  bindIp: 127.0.0.1  <- comment out this line
```

Restart mongo daemon (mongod)

`$ sudo service mongod restart`

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP of previous VM as **orion** alias according to your instance (Cygnus is installed in to Orion VM): 

> `192.168.111.169 orion`

Copy in the **/tmp/** folder the **Cygnus-1.7.1_API.jmx** file.

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#cygnus-and-mongo)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Cygnus-1.7.1_mongo.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.7.1_mongo_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in Mongo DB using these commands:

```text
$ mongo
MongoDB shell version: 3.2.6
connecting to: test
...
> show databases
local           0.000GB
orion           0.000GB
orion-vehicles  0.000GB
sth_vehicles    0.000GB

> use sth_vehicles
switched to db sth_vehicles

> show collections
sth_/4wheels_Car1_Car

> db['sth_/4wheels_Car1_Car'].find()
```