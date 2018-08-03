# Knowage #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)

## Introduction ##

Knowage is the professional open source suite for modern business analytics over traditional sources and big data systems developed by Engineering Ingegneria Informatica, available at its [GitHub repository](https://github.com/KnowageLabs/Knowage-Server). 

[Top](#knowage)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Knowage GE** - follow the instruction in the next step to install it via docker.
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#knowage)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Knowage ###

Here the steps to install Knowage via docker compose:

1) deploy an Ubuntu 16.04 VM (with a large flavor) and connect on it in SSH: 

2) install docker and docker-compose

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`
`sudo apt-get update`
`sudo apt-get install -y docker-ce`
`sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose`
`sudo chmod +x /usr/local/bin/docker-compose`

2) download and edit docker-compose.yml file 

`wget https://raw.githubusercontent.com/KnowageLabs/Knowage-Server-Docker/master/docker-compose.yml`

open and edit it; add this line:
 
`- PUBLIC_ADDRESS:217.172.12.223`

after `- WAIT_MYSQL=true` with your public IP. This file is also available here.

3) run docker compose
 
`export DOCKER_HOST=127.0.0.1`

`sudo docker-compose up`

Before to run the script you have to create the data source via Web Interface at this url `IP_PUBLIC:8080/knowage` (with biadmin/biadmin credentials):

1) create data source: in the menu, from `Data Providers -> Data source`; please use as label = FIWARE (it's important):

```text
Label = FIWARE
Description = Test FIWARE
Dialect = MySQL/MariaDB
Type = JDBC
URL = jdbc:mysql://mysql:3306/fiware
User = root
Password = root
Driver = com.mysql.jdbc.Driver  
```
![Data Source](datasource.png?raw=true "Data Source")

2) add functionality: in the menu, from `Profile Management -> Functionalities management`; please use as label = Functionality (it's important):

```text
Label = Functionality
Name = Functionality
Description = Test Functionality
```
check roles for admin and demo users.
![Functionality](functionality.png?raw=true "Functionality")

3) add analitical driver: in the menu, from `Behavioural model -> Analytical drivers management`; please use as label = Functionality (it's important):

```text
Label = Analytical
Name = Analytical
Description = Test Analytical driver
```
![Analytical drivers](analitical_drivers.png?raw=true "Analytical drivers")


### 2. JMeter ###

Open the **/etc/hosts** file and add the IP of Knowage instance with **knowage** alias according to your instance: 

> `192.168.111.135 knowage`

Copy in the **/tmp/** folder the **Knowage-6.2.10.jmx** file JMeter script and **prova.xml** file.

#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository
2. `sudo apt-get update` - to refresh packages metadata
3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0
4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0
5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#knowage)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/Knowage-6.2.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`knowage-6.2.0_yyyy-MM-dd HHmmss.csv`

[Top](#knowage)