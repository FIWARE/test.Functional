# Cygnus and MySQL #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)
* [Testing with Storages](#testing-with-storages)

## Introduction ##

Cygnus is a is an easy to use, powerful, and reliable system to process and distribute data. Internally, Cygnus is based on [Apache NiFi](https://nifi.apache.org/docs.html), NiFi is a dataflow system based on the concepts of flow-based programming. 

[Top](#cygnus-and-mysql)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, two Virtual Machines you needed, which are: 

1. **Cygnus** - follow the instruction in the next step to install Cygnus from package. 
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances).
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-mysql)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Cygnus ###

In order to install Cygnus via source to test functionality in JMeter, you have to deploy an Ubuntu 16.04 VM.
Before to start the Cygnus installation you need also the **MySQL** database up and running. 
In this test we are going to install MySQL database on Cygnus VM. 
Connect on VM via SSH and install it.

1) Install MySQL on the same VM


	sudo apt-get install mysql-server -y 
   
and type the password for user root (i.e root)
   	
	mysql --version

test on mysql version:

	mysql  Ver 14.14 Distrib 5.7.24, for Linux (x86_64) using  EditLine wrapper
   

**Open MySQL access up to all IPs**   	

In order to test the data in to database, it's necessary to open MySQL access up to all IPs, because the script will be run on other VM in the net.

So, Edit the /etc/mysql/mysql.conf.d/mysqld.cnf, run:

	sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

and comment bind-address property as follow:

```text
# bind-address = 127.0.0.1
```

Restart mysql server and give the permissions to access on Database

	sudo service mysql restart


	mysql -u root -p
	
	(root)
	
	mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
	mysql> FLUSH PRIVILEGES;

	exit

2) Install Cygnus 

After **MySQL** installation, you have to run the **install.sh** script provided in this folder to install the software. 
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

3) Use the **Orion-To-MySQL** template to build the connection with MySQL.

Please access in the web interface at this link `http://public_ip:8080/nifi`. Use this [link](https://fiware-cygnus-ld.readthedocs.io/en/latest/installation_and_administration_guide/cygnus_gui/index.html#cygnus-user-interface) to configure MySQL. 
You need to do configure some  Here the steps:

3.1) Drag the `Orion-To-MySQL` template. 

3.2) Configure `NGSIv2-HTTP-INPUT` block and set **HTTP Headers to receive as Attributes (Regex)** as ** .* ** in the `PROPERTIES` tab.

3.3) Configure `NGSIToMySQL` block set **Enable Encoding** property to **false** in the `PROPERTIES` tab to disable the encoding. Please set also the **DBCPConnectionPool** in the same tab. To do this click on the "*arrow*" to edit the MySQL properties, like URL (`jdbc:mysql://localhost:3306`) username and password (root/root). Finally enable the DBCPConnectionPool. 

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

> `192.168.111.156 mysql`

> `192.168.111.200 orion`


Copy in the **/tmp/** folder the **Cygnus-2.0.0_mysql.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

Finally add mysql driver in the **lib** folder of JMeter (`/home/ubuntu/apache-jmeter-4.0/lib`) the **mysql-connector-java-5.1.23-bin.jar** JAR provided in this folder.

[Top](#cygnus-and-mysql)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-2.0.0_mysql.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-2.0.0_mysql_yyyy-MM-dd HHmmss.csv`

**`NOTE`**

It's also possible to check directly the data stored in Mongo DB using these commands:

```text
$ mysql -u root -p
root

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| vehicles           |
+--------------------+
5 rows in set (0.00 sec)

mysql> use vehicles;
...
Database changed
mysql> show tables;
+--------------------+
| Tables_in_vehicles |
+--------------------+
| 4wheels   |
+--------------------+
1 row in set (0.01 sec)

mysql> select * from 4wheels;
+---------------+---------------------+-------------------+----------+------------+----------+----------+-----------+--------+
| recvTimeTs    | recvTime            | fiwareServicePath | entityId | entityType | attrName | attrType | attrValue | attrMd |
+---------------+---------------------+-------------------+----------+------------+----------+----------+-----------+--------+
| 1541763566161 | 11/09/2018 11:39:26 | 4wheels           | Car1     | Car        | speed    | Integer  | 4         | []     |
| 1541763759800 | 11/09/2018 11:42:39 | 4wheels           | Car1     | Car        | speed    | Integer  | 150       | []     |
+---------------+---------------------+-------------------+----------+------------+----------+----------+-----------+--------+
2 rows in set (0.00 sec)
```

[Top](#cygnus-and-mysql)


## Testing with Storages ##

You can also **run other tests** to check how Cygnus stores the context information by using the follow [documentation](../#cygnus-and-storages).

[Top](#cygnus-and-mysql)