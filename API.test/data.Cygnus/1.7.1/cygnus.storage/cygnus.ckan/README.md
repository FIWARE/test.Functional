# Cygnus and CKAN #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

In this section, it's presented the Cygnus configuration with **CKAN** ( Comprehensive Knowledge Archive Network) in order to test the storage functionalities. 
Within this script there are some Orion's features like subscription, add entity and delete of both subscription and entity, but the goal of the script is to check if your data (context) is really stored in the CKAN system.  

[Top](#cygnus-and-ckan)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, three Virtual Machines you needed, which are: 

1. **CKAN** - - follow the instruction to [deploy a dedicated CKAN instance](https://catalogue.fiware.org/enablers/ckan/creating-instances).
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances). 
3. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-ckan)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. CKAN ###

After deployed the CKAN instance in FIWARE LAB, you need to create an account in to CKAN server using the *Register* link (CKAN is listening on 80 port). 
To configure *Cygnus* with CKAN you also need to retrieve your *API KEY* associated your account; in your profile you can see:

```
API Key Private:
53da9bed-0fca-475c-a837-bebe8339d55d
```

### 2. Orion Context Broker ###

In order to check the  Cygnus and CKAN you can start from Orion Context Broker instance. For this test we are using an **orion-psb-image-R5.4** VM with flavor **m1.small**. Connect on VM (via SSH) and update the Orion to last version (1.7.0) using these commands:

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

Copy cygnus configuration files from template appending the name your **`<id>`** (in this case **ckan**):

>**`agent_ngsi_<id>.conf`** 		`sudo cp agent_ngsi.conf.template agent_ngsi_ckan.conf`

>**`cygnus_instance_<id>.conf`**  	`sudo cp cygnus_instance.conf.template cygnus_instance_ckan.conf`


Edit **agent_ngsi_ckan.conf** and **cygnus_instance_ckan.conf** files as follow:

**`agent_ngsi_ckan.conf`** 

Here the sections to change:
1.	*General configuration template* - use only the sink and channel that you are using and in this case only ckan-sink and ckan-channel
2.	*Source configuration* - in the channels properties choose only one (ckan-channel)
3.	*NGSICKANSink configuration* - uncomment all properties and choose for ckan configurations: hosts: ckan, with api_key your API_KEY = 53da9bed-0fca-475c-a837-bebe8339d55d

**`cygnus_instance_ckan.conf`**

Use the follow properties: 
```text
CONFIG_FILE = /usr/cygnus/conf/agent_ngsi_ckan.conf
AGENT_NAME = cygnus-ngsi
```

**Install JDK**
 
`$ sudo yum install java`

**Start Cygnus**

`$ sudo service cygnus start` 

**Add virtual host for CKAN VM**

It's necessary to add the virtual host (ckan) because the agent_ngsi_ckan.conf file uses **ckan** alias (`cygnus-ngsi.sinks.ckan-sink.ckan_host = ckan`) 

`$ sudo vi /etc/hosts`

`192.168.111.86 ckan`

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP of previous VM as **orion** and **ckan** aliases according to your instance (Cygnus is installed in to Orion VM and CKAN): 

> `192.168.111.75 orion`

> `192.168.111.86 ckan`

Copy in the **/tmp/** folder the **Cygnus-1.7.1_ckan.jmx** file.

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#cygnus-and-ckan)

## Testing step by step ##

### 1. First test (with persistence = row) ### 

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Cygnus-1.7.1_ckan.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.7.1_ckan_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in CKAN database or checking directly in the web interface of CKAN or using these commands:

`curl http://ckan/api/rest/dataset/vehicles_4wheels`

to get the resource_id (in the resources) - i.e. 5b5d8466-d59f-4a10-90a7-cd00b5208b38 

`curl http://ckan/api/action/datastore_search?resource_id=5b5d8466-d59f-4a10-90a7-cd00b5208b38`

```text
{"help": "http://default.ckanhosted.dev/api/3/action/help_show?name=datastore_search", "success": true, "result": {"resource_id": "5b5d8466-d59f-4a10-90a7-cd00b5208b38", "fields": [{"type": "int4", "id": "_id"}, {"type": "int4", "id": "recvTimeTs"}, {"type": "timestamp", "id": "recvTime"}, {"type": "text", "id": "fiwareServicePath"}, {"type": "text", "id": "entityId"}, {"type": "text", "id": "entityType"}, {"type": "text", "id": "attrName"}, {"type": "text", "id": "attrType"}, {"type": "json", "id": "attrValue"}, {"type": "json", "id": "attrMd"}], "records": [{"attrType": "Integer", "recvTime": "2017-10-19T09:51:00.442000", "recvTimeTs": 1508406660, "attrMd": null, "attrValue": "92", "entityType": "Car", "attrName": "speed", "fiwareServicePath": "/4wheels", "entityId": "Car1", "_id": 1}], "_links": {"start": "/api/action/datastore_search?resource_id=5b5d8466-d59f-4a10-90a7-cd00b5208b38", "next": "/api/action/datastore_search?offset=100&resource_id=5b5d8466-d59f-4a10-90a7-cd00b5208b38"}, "total": 1}}
```

### 2. Second test (with persistence = column) ###

Before to start the test with persistence = column, you need to follow the instructions below to provide the right structure of dataset in CKAN.

First of all you need to set in the **agent_ngsi_ckan.conf** the **column** attribute for **attr_persistence** instead of (default or previous) **row**:

`attr_persistence = column`

and restart Cygnus. 
Since you are going to store data in columns (attr_persistence), you have to create the dataset and the resource in CKAN server; so in order to do this you must connect in your CKAN to get your *API KEY* and use it in next (REST) calls in the header as authorization:

`Authorization : 53da9bed-0fca-475c-a837-bebe8339d55d`

###Create organization###

```text
POST - http://ckan/api/action/organization_create
{
	"name": "vehicles"
}
```
###Create package/dataset###

```text
POST - http://ckan/api/action/package_create
{
	"name": "vehicles_4wheels",
	"owner_org": "vehicles"
}
```

###Create resource###

```text
POST - http://ckan/api/action/resource_create
{
	"package_id": "vehicles_4wheels",
	"url": "localhost",
	"name": "car1_car"
}
```

###Get resource_id### 
You can also retrieve the resourse id from previous call, otherwise you can try as follow:
```text
GET - http://ckan/api/action/package_show?id=vehicles_4wheels
```
where the resource_id is located in result.resources.id.

###Create datastore###
Let suppose that the the resource_is is: `dd4312d4-41bc-4f17-ae1e-3162a873bdad` then the REST call to create the datastore must be: 

```text
POST - http://ckan/api/action/datastore_create
{
	"resource_id": "dd4312d4-41bc-4f17-ae1e-3162a873bdad",
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

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Cygnus-1.7.1_ckan_column.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.7.1_ckan_column_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in CKAN database or checking directly in the web interface of CKAN or using these commands:

`curl http://ckan/api/rest/dataset/vehicles_4wheels`

to get the resource_id (in the resources) - i.e. 5b5d8466-d59f-4a10-90a7-cd00b5208b38 

`curl http://ckan/api/action/datastore_search?resource_id=5b5d8466-d59f-4a10-90a7-cd00b5208b38`

```text
{"help": "http://default.ckanhosted.dev/api/3/action/help_show?name=datastore_search", "success": true, "result": {"resource_id": "5b5d8466-d59f-4a10-90a7-cd00b5208b38", "fields": [{"type": "int4", "id": "_id"}, {"type": "int4", "id": "recvTimeTs"}, {"type": "timestamp", "id": "recvTime"}, {"type": "text", "id": "fiwareServicePath"}, {"type": "text", "id": "entityId"}, {"type": "text", "id": "entityType"}, {"type": "text", "id": "attrName"}, {"type": "text", "id": "attrType"}, {"type": "json", "id": "attrValue"}, {"type": "json", "id": "attrMd"}], "records": [{"attrType": "Integer", "recvTime": "2017-10-19T09:51:00.442000", "recvTimeTs": 1508406660, "attrMd": null, "attrValue": "92", "entityType": "Car", "attrName": "speed", "fiwareServicePath": "/4wheels", "entityId": "Car1", "_id": 1}], "_links": {"start": "/api/action/datastore_search?resource_id=5b5d8466-d59f-4a10-90a7-cd00b5208b38", "next": "/api/action/datastore_search?offset=100&resource_id=5b5d8466-d59f-4a10-90a7-cd00b5208b38"}, "total": 1}}
```


[Top](#cygnus-and-ckan)