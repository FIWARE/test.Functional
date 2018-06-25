# Cygnus and CKAN #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

In this section, it's presented the Cygnus configuration with **CKAN** (Comprehensive Knowledge Archive Network) in order to test the storage functionalities. 
Within this script there are some Orion's features like subscription, add entity and delete of both subscription and entity, but the goal of the script is to check if your data (context) is really stored in the CKAN system.  

[Top](#cygnus-and-ckan)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, three Virtual Machines you needed, which are: 

1. **CKAN** - - follow the instruction to [deploy a dedicated CKAN instance](https://catalogue.fiware.org/enablers/ckan/creating-instances).
2. **Orion Context Broker GE and Cygnus** - follow the instruction in the next step to install both Orion and Cygnus via source on the same VM. 
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-ckan)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. CKAN ###

After deployed the CKAN instance in FIWARE LAB (**ckan_2.5**), you can use your *http://IP_PUBLIC* link to connect on CKAN instance (remember that CKAN is listening on 80 port). 
First you need to create an account in to CKAN server using the *Register* link (on the top right of web site). 
To configure *Cygnus* with CKAN you also need to get your *API KEY* associated your account; so after login, in your profile you can see:

```
API Key Private:
c4543af7-1d1b-4318-848c-785cb38df71c
```

### 2. Orion Context Broker and Cygnus ###

In order to check the Cygnus with CKAN you have to install Orion and Cygnus on Centos 7 VM. So in the FIWARE Lab deploy a Centos 7 VM (base_centos_7) with flavor **m1.medium**. Connect on VM (via SSH).

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

At the end of execution, the script copies for you, two default files (*agent_ngsi_ckan.conf* and *cygnus_instance_ckan.conf*) in the `/user/cygnus/conf` folder. You have to edit these files in order to complete the test with CKAN as follow: 

**`agent_ngsi_ckan.conf`** 

Here the sections to change:
1.	*General configuration template* - use only the sink and channel that you are using and in this case only ckan-sink and ckan-channel
2.	*Source configuration* - in the channels properties choose only one (ckan-channel)
3.	*NGSICKANSink configuration* - uncomment all properties and choose for ckan configurations: ckan host and port, the api_key (in this case API_KEY = c4543af7-1d1b-4318-848c-785cb38df71c) and orion_url as follow: 

```text
cygnus-ngsi.sinks.ckan-sink.api_key = c4543af7-1d1b-4318-848c-785cb38df71c
cygnus-ngsi.sinks.ckan-sink.ckan_host = ckan
cygnus-ngsi.sinks.ckan-sink.ckan_port = 80
cygnus-ngsi.sinks.ckan-sink.orion_url = http://localhost:1026
```

Please note that it's necessary to add the virtual host (ckan) because the agent_ngsi_ckan.conf file uses ckan alias (cygnus-ngsi.sinks.ckan-sink.ckan_host = ckan). The orion_url is localhost (port 1026) because we are using the Cygnus on the same VM of Orion.

> `sudo vi /etc/hosts`

> `192.168.111.169 ckan`

**`cygnus_instance_ckan.conf`**

Use the follow properties: 

```text
CONFIG_FILE = /usr/cygnus/conf/agent_ngsi_ckan.conf
AGENT_NAME = cygnus-ngsi
```

Finally, run the server with this command:

> `./start.sh`

### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP of previous VM as **cygnus** and **ckan** aliases according to your instancea (Cygnus is installed in to Orion VM and CKAN): 

> `192.168.111.169 ckan`

> `192.168.111.161 cygnus`

Copy in the **/tmp/** folder the **Cygnus-1.9.0_ckan.jmx** file.
 

#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#cygnus-and-ckan)

## Testing step by step ##

### 1. First test (with persistence = row) ### 

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-1.9.0_ckan.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.9.0_ckan_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in CKAN database or checking directly in the web interface of CKAN or using these commands:

`curl http://ckan/api/rest/dataset/vehicles_4wheels`

to get the resource_id (in the resources) - i.e. b5c62057-0ea7-452d-9e2d-c32f9182497b

`curl http://ckan/api/action/datastore_search?resource_id=b5c62057-0ea7-452d-9e2d-c32f9182497b`

```text
{"help": "http://default.ckanhosted.dev/api/3/action/help_show?name=datastore_search", "success": true, "result": {"resource_id": "b5c62057-0ea7-452d-9e2d-c32f9182497b", "fields": [{"type": "int4", "id": "_id"}, {"type": "int4", "id": "recvTimeTs"}, {"type": "timestamp", "id": "recvTime"}, {"type": "text", "id": "fiwareServicePath"}, {"type": "text", "id": "entityId"}, {"type": "text", "id": "entityType"}, {"type": "text", "id": "attrName"}, {"type": "text", "id": "attrType"}, {"type": "json", "id": "attrValue"}, {"type": "json", "id": "attrMd"}], "records": [{"attrType": "Integer", "recvTime": "2018-06-25T15:37:10.448000", "recvTimeTs": 1529941030, "attrMd": null, "attrValue": "7", "entityType": "Car", "attrName": "speed", "fiwareServicePath": "/4wheels", "entityId": "Car1", "_id": 1}], "_links": {"start": "/api/action/datastore_search?resource_id=b5c62057-0ea7-452d-9e2d-c32f9182497b", "next": "/api/action/datastore_search?offset=100&resource_id=b5c62057-0ea7-452d-9e2d-c32f9182497b"}, "total": 1}}
```

### 2. Second test (with persistence = column) ###

Before to start the test with persistence = column, you need to follow the instructions below to provide the right structure of dataset in CKAN.

First of all you need to set in the **agent_ngsi_ckan.conf** the **column** attribute for **attr_persistence** instead of (default or previous) **row**:

`attr_persistence = column`

and restart Cygnus. 
Since you are going to store data in columns (attr_persistence), you have to create the dataset and the resource in CKAN server; so in order to do this you must connect in your CKAN to get your *API KEY* and use it in next 5 (REST) calls in the header as authorization:

`Authorization : c4543af7-1d1b-4318-848c-785cb38df71c`

**Create organization**

```text
POST - http://ckan/api/action/organization_create
{
	"name": "vehicles"
}
```
**Create package/dataset**

```text
POST - http://ckan/api/action/package_create
{
	"name": "vehicles_4wheels",
	"owner_org": "vehicles"
}
```

**Create resource**

```text
POST - http://ckan/api/action/resource_create
{
	"package_id": "vehicles_4wheels",
	"url": "localhost",
	"name": "car1_car"
}
```

**Get resource_id**

You can also retrieve the resourse id from previous call, otherwise you can try as follow:
```text
GET - http://ckan/api/action/package_show?id=vehicles_4wheels
```
where the resource_id is located in result.resources.id.

**Create datastore**

Let suppose that the the resource_is is: `ae415294-aa6d-4301-b3b1-1a9481bbbbe6` then the REST call to create the datastore must be: 

```text
POST - http://ckan/api/action/datastore_create
{
	"resource_id": "ae415294-aa6d-4301-b3b1-1a9481bbbbe6",
	"force": "True",
	"fields": [{
		"type": "timestamp",
		"id": "recvTime"
	}, {
		"type": "text",
		"id": "fiwareServicePath"
	}, {
		"type": "text",
		"id": "entityId"
	}, {
		"type": "text",
		"id": "entityType"
	}, {
		"type": "json",
		"id": "speed"
	}, {
		"type": "json",
		"id": "speed_md"
	}]
}
```

Now you are ready to run the test. 

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-1.9.0_ckan_column.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.9.0_ckan_column_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in CKAN database or checking directly in the web interface of CKAN or using these commands:

`curl http://ckan/api/rest/dataset/vehicles_4wheels`

to get the resource_id (in the resources) - i.e. ae415294-aa6d-4301-b3b1-1a9481bbbbe6 

`curl http://ckan/api/action/datastore_search?resource_id=ae415294-aa6d-4301-b3b1-1a9481bbbbe6`

```text
{"help": "http://default.ckanhosted.dev/api/3/action/help_show?name=datastore_search", "success": true, "result": {"resource_id": "ae415294-aa6d-4301-b3b1-1a9481bbbbe6", "fields": [{"type": "int4", "id": "_id"}, {"type": "timestamp", "id": "recvTime"}, {"type": "text", "id": "fiwareServicePath"}, {"type": "text", "id": "entityId"}, {"type": "text", "id": "entityType"}, {"type": "json", "id": "speed"}, {"type": "json", "id": "speed_md"}], "records": [{"recvTime": "2018-06-25T15:52:35.731000", "entityType": "Car", "fiwareServicePath": "/4wheels", "entityId": "Car1", "_id": 1, "speed": "21", "speed_md": null}, {"recvTime": "2018-06-25T15:56:49.626000", "entityType": "Car", "fiwareServicePath": "/4wheels", "entityId": "Car1", "_id": 2, "speed": "36", "speed_md": null}], "_links": {"start": "/api/action/datastore_search?resource_id=ae415294-aa6d-4301-b3b1-1a9481bbbbe6", "next": "/api/action/datastore_search?offset=100&resource_id=ae415294-aa6d-4301-b3b1-1a9481bbbbe6"}, "total": 2}}
```

[Top](#cygnus-and-ckan)