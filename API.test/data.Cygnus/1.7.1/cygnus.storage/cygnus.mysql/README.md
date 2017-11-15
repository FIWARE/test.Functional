# Cygnus and MySQL #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

In this section, it's presented the Cygnus configuration with **MySQL database** in order to test the storage functionalities. 
Within this script there are some Orion's features like subscription, add entity and delete of both subscription and entity, but the goal of the script is to check if your data (context) is really stored in the MySQL database.  

[Top](#cygnus-and-mysql)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this adapter, three Virtual Machines you needed, which are: 

1. **MySQL** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install MySQL (version 5) manually on Ubuntu Virtual Machine.
2. **Orion Context Broker GE** - follow the instruction to [deploy a dedicated Orion instance](https://catalogue.fiware.org/enablers/publishsubscribe-context-broker-orion-context-broker/creating-instances). 
3. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-mysql)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. MySQL ###

Install MySQL database manually (and use root/root credentials) on dedicated VM (ubuntu 14.04); in order to do this, deploy a base_ubuntu_14.04 in FIWARE LAB and type the follow commands to install MySQL 5:

`$ sudo apt-get update`

`$ sudo apt-get install mysql-server`

Check version and status of database:

`$ mysql --version`

`$ service mysql status`

in this case: `mysql  Ver 14.14 Distrib 5.5.57 tested`.

It's necessary to open MySQL access up to all IPs, because the script will be run on other VM. 

So, Edit the /etc/mysql/my.cnf, run:

`$ sudo nano /etc/mysql/my.cnf`

and comment `bind-address` property as follow: 

`# bind-address = 127.0.0.1` 

Restart mysql server

`$ sudo service mysql restart` 

Finally give the permissions to access on Database

`$ mysql -u root -p`

`root`

```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;
```

### 2. Orion Context Broker ###

In order to check the  Cygnus and MySQL database you can start from Orion Context Broker instance. For this test we are using an **orion-psb-image-R5.4** VM with flavor **m1.small**. Connect on VM (via SSH) and update the Orion to last version (1.7.0) using these commands:

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

Copy cygnus configuration files from template appending the name your **`<id>`** (in this case **mysql**):

>**`agent_ngsi_<id>.conf`** 		`sudo cp agent_ngsi.conf.template agent_ngsi_mysql.conf`

>**`cygnus_instance_<id>.conf`**  	`sudo cp cygnus_instance.conf.template cygnus_instance_mysql.conf`


Edit **agent_ngsi_mysql.conf** and **cygnus_instance_mysql.conf** files as follow:

**`agent_ngsi_mysql.conf`** 

Here the sections to change:
1.	*General configuration template* - use only the sink and channel that you are using and in this case only mysql-sink and mysql-channel
2.	*Source configuration* - in the channels properties choose only one (mysql-channel)
3.	*NGSIMySQLSink configuration* - uncomment all properties and choose for mysql configurations: mysql_host = mysql, port = 3306 with username/password root/root

**`cygnus_instance_mysql.conf`**

Use the follow properties: 
```text
CONFIG_FILE = /usr/cygnus/conf/agent_ngsi_mysql.conf
AGENT_NAME = cygnus-ngsi
```

**Install JDK**
 
`$ sudo yum install java`

**Start Cygnus**

`$ sudo service cygnus start` 

**Add virtual host for mysql VM**

It's necessary to add the virtual host (mysql) because the agent_ngsi_mysql.conf file uses **mysql** alias (`cygnus-ngsi.sinks.mysql-sink.mysql_host = mysql`) 

`$ sudo vi /etc/hosts`

`192.168.111.43 mysql`

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP of previous VM as **orion** and **mysql** aliases according to your instancea (Cygnus is installed in to Orion VM and MySQL): 

> `192.168.111.42 orion`

> `192.168.111.43 mysql`

Copy in the **/tmp/** folder the **Cygnus-1.7.1_mysql.jmx** file and add mysql driver in the **lib** folder of JMeter the **mysql-connector-java-5.1.23-bin.jar** Jar.

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#cygnus-and-mysql)

## Testing step by step ##

### 1. First test (with persistence = row) ### 

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Cygnus-1.7.1_mysql.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.7.1_mysql_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in MySQL database using these commands:

```text
$ mysql -u root -p
root

mysql> use vehicles;
...
Database changed
mysql> show tables;
mysql> select * from 4wheels_Car1_Car;

+---------------+-------------------------+-------------------+----------+------------+----------+----------+-----------+--------+
| recvTimeTs    | recvTime                | fiwareServicePath | entityId | entityType | attrName | attrType | attrValue | attrMd |
+---------------+-------------------------+-------------------+----------+------------+----------+----------+-----------+--------+
| 1508149679854 | 2017-10-16T10:27:59.854 | /4wheels          | Car1     | Car        | speed    | Integer  | 32        | []     |
+---------------+-------------------------+-------------------+----------+------------+----------+----------+-----------+--------+
```

### 2. Second test (with persistence = column) ###

Before to start the test with persistence = column, you need to follow the instructions below to provide the right structure of data (in the database).

First of all you need to set in the **agent_ngsi_mysql.conf** the **column** attribute for **attr_persistence** instead of (default or previous) **row**:

`attr_persistence = column`

and restart Cygnus. 
Since you are going to store data in columns (attr_persistence), you have to create tables and columns in MySQL database; so in order to do this you must connect in your MySQL database and type these commands:

```text
$ mysql -u root -p
root

mysql> create database vehicles;
mysql> use vehicles;
mysql> create table 4wheels_Car1_Car (recvTime DATETIME, fiwareServicePath varchar(255), entityId varchar(255), entityType varchar(255), speed int, speed_md varchar(255));
```

Now you are ready to run the test.  
 
**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Cygnus-1.7.1_mysql_column.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.7.1_mysql_column_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in MySQL database using these commands:

```text
$ mysql -u root -p
root

mysql> use vehicles;
...
Database changed
mysql> show tables;
mysql> select * from 4wheels_Car1_Car;
 
+---------------------+-------------------+----------+------------+-------+----------+
| recvTime            | fiwareServicePath | entityId | entityType | speed | speed_md |
+---------------------+-------------------+----------+------------+-------+----------+
| 2017-11-14 14:14:16 | /4wheels          | Car1     | Car        |    47 | []       |
+---------------------+-------------------+----------+------------+-------+----------+

```

[Top](#cygnus-and-mysql)