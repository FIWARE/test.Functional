# Cygnus and Cosmos #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

In this section, it's presented the Cygnus configuration with **Cosmos BigData** in order to test the storage functionalities. 
Within this script there are some Orion's features like subscription, add entity and delete of both subscription and entity, but the goal of the script is to check if your data (context) is really stored in the public Cosmos instance of FIWARE.  

[Top](#cygnus-and-cosmos)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, two Virtual Machines you needed, which are: 

1. **Cosmos BigData GE** - for this test, it was used the public Cosmos instance of FIWARE (http://cosmos.lab.fiware.org).
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances). 
3. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-cosmos)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Cosmos BigData ###

Before to use the Cosmos instance is necessary to get the **token**. In ordet to do this please type the follow commands:

`$ curl -k -X POST "https://cosmos.lab.fiware.org:13000/cosmos-auth/v1/token" -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=password&username=<username>&password=<password>"`

where you have to replace `<username>` and `<password>` with your *username* and *password* credentials in Cosmos.

and the response is:

`{"access_token": "Mljhz02XmzmxYsctPnIaeRHlCIa3m4", "token_type": "Bearer", "expires_in": 3600, "refresh_token": "xSPbkOYK5dmOuo1q1l2sLOpSrz4AKP"}`

where the token is `Mljhz02XmzmxYsctPnIaeRHlCIa3m4`.

To check your file status (and of course if it's possible to connect to Cosmos instance), use this command: 

`$ curl -X GET "http://cosmos.lab.fiware.org:14000/webhdfs/v1/user/<username>?op=LISTSTATUS&user.name=<username>" -H "X-Auth-Token: Mljhz02XmzmxYsctPnIaeRHlCIa3m4"`

and the response is empty (at the first time):

`{"FileStatuses":{"FileStatus":[]}}`

Please note that, for public instance of Cosmos, you have to request the account to owner of GE provide the token. 


### 2. Orion Context Broker ###

In order to check the Cygnus and Cosmos you can start from Orion Context Broker instance. For this test we are using an **orion-psb-image-R5.4** VM with flavor **m1.small**. Connect on VM (via SSH) and update the Orion to last version (1.7.0) using these commands:

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

Copy cygnus configuration files from template appending the name your **`<id>`** (in this case **cosmos**):

>**`agent_ngsi_<id>.conf`** 		`sudo cp agent_ngsi.conf.template agent_ngsi_cosmos.conf`

>**`cygnus_instance_<id>.conf`**  	`sudo cp cygnus_instance.conf.template cygnus_instance_cosmos.conf`


Edit **agent_ngsi_cosmos.conf** and **cygnus_instance_cosmos.conf** files as follow:

**`agent_ngsi_cosmos.conf`** 

Here the sections to change:
1.	*General configuration template* - use only the sink and channel that you are using and in this case only hdfs-sink and hdfs-channel
2.	*Source configuration* - in the channels properties choose only one (hdfs-channel)
3.	*NGSIHDFSSink configuration* - uncomment all properties and use in the cosmos configurations: 
- hdfs_host and hdfs_port - the default host (cosmos.lab.fiware.org and 14000); 
- dfs_username and hdfs_password - your username and password
- oauth2_token - your previous token (Mljhz02XmzmxYsctPnIaeRHlCIa3m4)

**`cygnus_instance_cosmos.conf`**

Use the follow properties: 
```text
CONFIG_FILE = /usr/cygnus/conf/agent_ngsi_cosmos.conf
AGENT_NAME = cygnus-ngsi
```

**Install JDK**
 
`$ sudo yum install java`

**Start Cygnus**

`$ sudo service cygnus start` 


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP of previous VM as **orion** alias according to your instance (Cygnus is installed in to Orion VM): 

> `192.168.111.169 orion`

Copy in the **/tmp/** folder the **Cygnus-1.7.1_cosmos.jmx** and **file.properties** files. Edit the file.properties file with your parameters.

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#cygnus-and-cosmos)

## Testing step by step ##

### 1. First test (with file_format = json-row) ### 

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Cygnus-1.7.1_cosmos.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.7.1_cosmos_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in Cosmos BigData using these commands:

```text
$ curl -X GET "http://cosmos.lab.fiware.org:14000/webhdfs/v1/user/<username>?op=LISTSTATUS&user.name=<username>" -H "X-Auth-Token: Mljhz02XmzmxYsctPnIaeRHlCIa3m4"
```
where `<username>` is your account in Cosmos. The response is:

```text
{"FileStatuses":{"FileStatus":[{"pathSuffix":"vehicles","type":"DIRECTORY","length":0,"owner":"<username>","group":"<username>","permission":"755","accessTime":0,"modificationTime":1510933006058,"blockSize":0,"replication":0}]}}
```

The response of this LISTSTATUS operation, with pathSuffix = vehicles is a type = DIRECTORY; so you have to make another call to get as the type = FILE just append the directories (pathSuffix) after the (first) username; for instance (append vehicles to url):

```text
$ curl -X GET "http://cosmos.lab.fiware.org:14000/webhdfs/v1/user/<username>/vehicles?op=LISTSTATUS&user.name=<username>" -H "X-Auth-Token: Mljhz02XmzmxYsctPnIaeRHlCIa3m4"
```

Finally, when you find type = FILE, you can open the file as follow (in the script the path is `/vehicles/4wheels/Car1_Car/Car1_Car.txt`):

```text
curl -X GET "http://cosmos.lab.fiware.org:14000/webhdfs/v1/user/<username>/vehicles/4wheels/Car1_Car/Car1_Car.txt?op=OPEN&user.name=<username>" -H "X-Auth-Token: Mljhz02XmzmxYsctPnIaeRHlCIa3m4"
```
and the response is:

```text
{"recvTimeTs":"1511190720","recvTime":"2017-11-20T15:12:00.989Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car","attrName":"speed","attrType":"Integer","attrValue":"58","attrMd":[]}
{"recvTimeTs":"1511190855","recvTime":"2017-11-20T15:14:15.917Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car","attrName":"speed","attrType":"Integer","attrValue":"56","attrMd":[]}
{"recvTimeTs":"1511192905","recvTime":"2017-11-20T15:48:25.193Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car","attrName":"speed","attrType":"Integer","attrValue":"37","attrMd":[]}
{"recvTimeTs":"1511192982","recvTime":"2017-11-20T15:49:42.517Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car","attrName":"speed","attrType":"Integer","attrValue":"90","attrMd":[]}
{"recvTimeTs":"1511193082","recvTime":"2017-11-20T15:51:22.443Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car","attrName":"speed","attrType":"Integer","attrValue":"4","attrMd":[]}
```

### 2. Second test (with file_format = json-column) ###

Before to start the test with persistence = column, you need to set in the **agent_ngsi_cosmos.conf** the **json-column** attribute for **file_format** instead of (default or previous) **json-row**:

`file_format = json-column`

and restart Cygnus. 

Please note that it's not necessary to provide (perfect structure) data in Cosmos BigData as it should be done in the other storage systems.

Now you are ready to run the test.  
 
**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Cygnus-1.7.1_cosmos_column.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.7.1_cosmos_column_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in Cosmos BigData using these commands:

```text
curl -X GET "http://cosmos.lab.fiware.org:14000/webhdfs/v1/user/<username>/vehicles/4wheels/Car1_Car/Car1_Car.txt?op=OPEN&user.name=<username>" -H "X-Auth-Token: Mljhz02XmzmxYsctPnIaeRHlCIa3m4"
```
and the response is:

```text
{"recvTime":"2017-11-21T10:40:49.90Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car", "speed":"15", "speed_md":[]}
{"recvTime":"2017-11-21T10:43:29.652Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car", "speed":"118", "speed_md":[]}
{"recvTime":"2017-11-21T10:44:29.166Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car", "speed":"136", "speed_md":[]}
{"recvTime":"2017-11-21T10:47:18.859Z","fiwareServicePath":"/4wheels","entityId":"Car1","entityType":"Car", "speed":"125", "speed_md":[]}
```

[Top](#cygnus-and-cosmos)