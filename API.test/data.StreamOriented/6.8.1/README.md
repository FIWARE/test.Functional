# Stream-oriented Kurento #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Stream-oriented is the FIWARE GE by Univeridad Rey Juan Carlos available at its [GitHub repository](https://github.com/Kurento).

[Top](#stream-oriented-kurento)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Stream-oriented - Kurento** - follow the instruction to [deploy a dedicated GE instance based on an image](https://catalogue.fiware.org/enablers/stream-oriented-kurento/creating-instances). 
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.


[Top](#stream-oriented-kurento)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Stream-oriented Kurento ###

Deploy dedicated Kurento in FIWARE Lab. Follow these instructions, if it's not available the right version of Stream-oriented Kurento GE in the FIWARE Lab, you can use the `install.sh` script provided in this folder (before to run it, change permission with `chmod +x install.sh` command) or manually using the follow commands: 

1) deploy an Ubuntu 16.04 VM and connect on it in SSH

2) use DISTRO="xenial" for Ubuntu 16.04

> `DISTRO="xenial"` 

3) Add the Kurento repository to your system configuration. Run these two commands in the same terminal you used in the previous step:

> `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83`

    sudo tee "/etc/apt/sources.list.d/kurento.list" >/dev/null <<EOF
    # Kurento Media Server - Release packages
    deb [arch=amd64] http://ubuntu.openvidu.io/6.8.1 $DISTRO kms6
    EOF

4) Install KMS

> `sudo apt-get update`

> `sudo apt-get install kurento-media-server`

5) Start the server

> `sudo service kurento-media-server start`

To stop the server use `sudo service kurento-media-server stop` command.


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Kurento IP of previous VM with **kurento** alias according to your instance: 

> `192.168.111.240 kurento`


Copy in the **/tmp/** folder the **StreamOriented-6.8.1.jmx** file.


#### Install JMeter 4 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#stream-oriented-kurento)

## Testing step by step ##

Before to start the test, you need to add JARs (plugins) in the **apache-jmeter-4.0/lib/ext** folder. Please copy **jmeter-plugins-manager-1.3.jar** and **JMeterWebSocketSamplers-1.2.1.jar** files in the **ext** folder.

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/StreamOriented-6.8.1.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`stream_oriented_kurento-6.8.1_yyyy-MM-dd HHmmss.csv`

[Top](#stream-oriented-kurento)