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

1. **MySQL** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install MySQL (version 5) manually on Ubuntu Virtual Machine.
2. **Orion Context Broker GE and Cygnus** - follow the instruction in the next step to install both Orion and Cygnus via source on the same VM. 
3. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cygnus-and-mysql)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. MySQL ###

Install MySQL database manually (and use root/root credentials) on dedicated VM (ubuntu 16.04); in order to do this, deploy a base_ubuntu_16.04 in FIWARE LAB and type the follow commands to install MySQL 5:

`sudo apt-get update`

`sudo apt-get install mysql-server`

Check version and status of database:

`mysql --version`

in this case: `mysql  Ver 14.14 Distrib 5.7.22, for Linux (x86_64) using  EditLine wrapper`

To check the status use:

`service mysql status`

In order to test the data in to database, it's necessary to open MySQL access up to all IPs, because the script will be run on other VM in the net. 

So, Edit the `/etc/mysql/mysql.conf.d/mysqld.cnf`, run:

`sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf`

and comment `bind-address` property as follow: 

`# bind-address = 127.0.0.1` 

Restart mysql server

`sudo service mysql restart` 

Finally give the permissions to access on Database

`mysql -u root -p`

`root`

```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;
```

### 2. Orion Context Broker and Cygnus ###

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

At the end of execution, the script copies for you, two default files (*agent_ngsi_mysql.conf* and *cygnus_instance_mysql.conf*) in the `/usr/cygnus/conf` folder. You have to edit these files in order to complete the test with Mongo as follow: 

**`agent_ngsi_mysql.conf`** 

Here the sections to change:
1.	*General configuration template* - use only the sink and channel that you are using and in this case only mysql-sink and mysql-channel
2.	*Source configuration* - in the channels properties choose only one (mysql-channel)
3.	*NGSIMySQLSink configuration* - uncomment all properties and choose for mysql db configurations: mysql_host = mysql, port = 3306 with username/password root/root as follow: 

```text
cygnus-ngsi.sinks.mysql-sink.mysql_host = mysql 
cygnus-ngsi.sinks.mysql-sink.mysql_port = 3306 
cygnus-ngsi.sinks.mysql-sink.mysql_username = root
cygnus-ngsi.sinks.mysql-sink.mysql_password = root
```

Please note that it's necessary to add the virtual host (mysql) because the agent_ngsi_mysql.conf file uses mysql alias (cygnus-ngsi.sinks.mysql-sink.mysql_host = mysql)

> `sudo vi /etc/hosts`

> `192.168.111.170 mysql`

**`cygnus_instance_mysql.conf`**

Use the follow properties: 

```text
CONFIG_FILE = /usr/cygnus/conf/agent_ngsi_mysql.conf
AGENT_NAME = cygnus-ngsi
```

Finally, run the server with this command:

> `./start.sh`


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Cygnus IP of previous VM as **cygnus** and **mysql** aliases according to your instancea (Cygnus is installed in to Orion VM and MySQL): 

> `192.168.111.172 cygnus`

> `192.168.111.170 mysql`

Copy in the **/tmp/** folder the **Cygnus-1.8.0_mysql.jmx** file.
 

#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

Finally add mysql driver in the **lib** folder of JMeter (`/home/ubuntu/apache-jmeter-4.0/lib`) the **mysql-connector-java-5.1.23-bin.jar** JAR provided in this folder.

[Top](#cygnus-and-mysql)

## Testing step by step ##

### 1. First test (with persistence = row) ### 

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-1.8.0_mysql.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.8.0_mysql_yyyy-MM-dd HHmmss.csv`


**`NOTE`**

It's also possible to check directly the data stored in MySQL database using these commands:

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
| 4wheels_Car1_Car   |
+--------------------+
1 row in set (0.01 sec)

mysql> select * from 4wheels_Car1_Car;
+---------------+-------------------------+-------------------+----------+------------+----------+----------+-----------+--------+
| recvTimeTs    | recvTime                | fiwareServicePath | entityId | entityType | attrName | attrType | attrValue | attrMd |
+---------------+-------------------------+-------------------+----------+------------+----------+----------+-----------+--------+
| 1533481108299 | 2018-08-05T14:58:28.299 | /4wheels          | Car1     | Car        | speed    | Integer  | 141       | []     |
| 1533481217207 | 2018-08-05T15:00:17.207 | /4wheels          | Car1     | Car        | speed    | Integer  | 72        | []     |
| 1533481294072 | 2018-08-05T15:01:34.72  | /4wheels          | Car1     | Car        | speed    | Integer  | 55        | []     |
+---------------+-------------------------+-------------------+----------+------------+----------+----------+-----------+--------+
3 rows in set (0.00 sec)
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

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Cygnus-1.8.0_mysql_column.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`cygnus-1.8.0_mysql_column_yyyy-MM-dd HHmmss.csv`


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
| 2018-08-05 15:05:50 | /4wheels          | Car1     | Car        |   108 | []       |
| 2018-08-05 15:07:14 | /4wheels          | Car1     | Car        |   128 | []       |
| 2018-08-05 15:08:22 | /4wheels          | Car1     | Car        |    98 | []       |
+---------------------+-------------------+----------+------------+-------+----------+
3 rows in set (0.00 sec)

```

[Top](#cygnus-and-mysql)