# Cygnus and Postgres #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)
* [Testing with Storages](#testing-with-storages)

## Introduction ##

Cygnus is a is an easy to use, powerful, and reliable system to process and distribute data. Internally, Cygnus is based on [Apache NiFi](https://nifi.apache.org/docs.html), NiFi is a dataflow system based on the concepts of flow-based programming. 

[Top](#cygnus-and-postgres)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, two Virtual Machines you needed, which are: 

1. **Cygnus** - follow the instruction in the next step to install Cygnus from package. 
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-postgres)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Cygnus ###

In order to install Cygnus via source to test functionality in JMeter, you have to deploy an Ubuntu 16.04 VM.
Before to start the Cygnus installation you need also the **Postgres** database up and running. 
In this test we are going to install Postgres database on Cygnus VM. 
Connect on VM via SSH and install it.

1) Install Postgres on the same VM
   	
	sudo apt-get update
	
	sudo apt-get install postgresql postgresql-contrib -y
   
and to get the version use:
   	
	psql -V

test on mysql version:

	psql (PostgreSQL) 9.5.14
   
**Open Postgres access up to all IPs**   	

In order to test the data in to database, it's necessary to open Postgres access up to all IPs, because the script will be run on other VM in the net.

So, edit the /etc/postgresql/9.5/main/postgresql.conf file, run:

	sudo nano /etc/postgresql/9.5/main/postgresql.conf

and uncomment `listen_addresses = 'localhost'` property as follow:

```text
listen_addresses = '*'
```

Edit also sudo nano /etc/postgresql/9.5/main/pg_hba.conf file using:

```text
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             0.0.0.0/0               md5
```

Restart postgres server

	sudo service postgresql restart

To connect in postgres to set the password for `postgres` user:

	sudo -u postgres psql

	ALTER USER postgres PASSWORD 'postgres';

2) Install Cygnus 

After **Postgres** installation, you have to run the **install.sh** script provided in this folder to install the software. 
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

3) Use the **Orion-To-Postgres** template to build the connection with Postgres.

Please access in the web interface at this link `http://public_ip:8080/nifi`. Use this [link](https://fiware-cygnus-ld.readthedocs.io/en/latest/installation_and_administration_guide/cygnus_gui/index.html#cygnus-user-interface) to configure Postgres. 
You need to do configure some  Here the steps:

3.1) Drag the `Orion-To-PostgreSQL` template. 

3.2) Configure `NGSIv2-HTTP-INPUT` block and set **HTTP Headers to receive as Attributes (Regex)** as ** .* ** in the `PROPERTIES` tab.

3.3) Configure `NGSIToPostgreSQL` block set **Enable Encoding** property to **false** in the `PROPERTIES` tab to disable the encoding. Please set also the **DBCPConnectionPool** in the same tab. To do this click on the "*arrow*" to edit the PostgreSQL properties, like URL (`jdbc:postgresql://localhost:5432/`) username and password (postgres/postgres). Finally enable the DBCPConnectionPool. 

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

> `192.168.111.156 postgres`

> `192.168.111.200 orion`


Copy in the **/tmp/** folder the **Cygnus-2.0.0_postgres.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

Finally add mysql driver in the **lib** folder of JMeter (`/home/ubuntu/apache-jmeter-4.0/lib`) the **postgresql-42.2.4.jar** JAR provided in this folder.

[Top](#cygnus-and-postgres)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-2.0.0_postgres.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-2.0.0_postgres_yyyy-MM-dd HHmmss.csv`

**`NOTE`**

It's also possible to check directly the data stored in Posgres DB using these commands:

```text
$ sudo -u postgres psql

postgres=# \dn
   List of schemas
   Name   |  Owner
----------+----------
 public   | postgres
 vehicles | postgres
(2 rows)

postgres=# \dt vehicles.*
          List of relations
  Schema  |  Name  | Type  |  Owner
----------+--------+-------+----------
 vehicles | wheels | table | postgres
(1 row)


postgres=# SELECT * FROM vehicles.wheels ORDER BY recvTime DESC;
  recvtimets   |      recvtime       | fiwareservicepath | entityid | entitytype | attrname | attrtype | attrvalue | attrmd
---------------+---------------------+-------------------+----------+------------+----------+----------+-----------+--------
 1542104207502 | 11/13/2018 10:16:47 | wheels            | Car1     | Car        | speed    | Integer  | 112       | []
 1542104120381 | 11/13/2018 10:15:20 | wheels            | Car1     | Car        | speed    | Integer  | 66        | []
(2 rows)
```

[Top](#cygnus-and-postgres)


## Testing with Storages ##

You can also **run other tests** to check how Cygnus stores the context information by using the follow [documentation](../#cygnus-and-storages).

[Top](#cygnus-and-postgres)