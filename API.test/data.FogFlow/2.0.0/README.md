# FogFlow #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

FogFlow is an IoT edge computing framework to orchestrate dynamic processing flows over cloud and edges. It can dynamically and automatically composite multiple NGSI-based data processing tasks to form high level IoT services, and then orchestrate and optimize the deployment of those services within a shared cloud-edge environment, with regards to the availability, locality, and mobility of IoT devices. FogFlow is available at its [GitHub repository](https://github.com/Fiware/context.FogFlow). 

[Top](#fogflow)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **FogFlow GE** - select "base_ubuntu_16.04" and follow the instruction below this section.
 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#fogflow)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. FogFlow ###

Follow these steps to install FogFlow instance (also provided at this link https://fogflow.readthedocs.io/en/latest/setup.html): 

1) deploy an Ubuntu 16.04 VM and connect on it in SSH: 

2) install Docker CE and Docker Compose using these commands:

> `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

> `sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`

> `sudo apt-get update`

> `apt-cache policy docker-ce`

> `sudo apt-get install -y docker-ce`

and 

> `sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose`

> `sudo chmod +x /usr/local/bin/docker-compose`

> `docker-compose --version`

that is *docker-compose version 1.18.0, build 8dd22a9*

3) download the deployment script

> `wget https://raw.githubusercontent.com/smartfog/fogflow/master/deployment/core/docker-compose.yml`

4) download the configuration file

> `wget https://raw.githubusercontent.com/smartfog/fogflow/master/deployment/core/config.json`

Please note that you have to edit the config.json file, just to update the external_IP address (i.e. 155.54.239.141) with your public IP (i.e. 217.172.12.159) that you are using.

5) start the FogFlow system

> `sudo docker-compose up -d`

The web interface is running on port 80, while the APIs of FogFlow Discovery are running on port 443 and APIs of FogFlow Broker on port 8080.


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add FogFlow IP of previous VM with **fogflow** alias according to your instance: 

> `192.168.111.215 fogflow`

Copy in the **/tmp/** folder the **FogFlow-2.0.0.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#fogflow)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/FogFlow-2.0.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`fogflow-2.0.0_yyyy-MM-dd HHmmss.csv`

[Top](#fogflow)