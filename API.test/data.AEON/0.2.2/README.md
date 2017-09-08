# Cloud Messaging - AEON #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Cloud Messaging - AEON is the FIWARE GE by Orange available at its [GitHub repository](https://github.com/atos-ari-aeon/fiware-cloud-messaging-platform).

[Top](#cloud-messaging---aeon)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Cloud Messaging - Aeon GE** - follow the instruction to [deploy a dedicated GE using image](http://aeon-platform.readthedocs.io/en/latest/FIWARE-Cloud-Messaging---Installation-and-Administration-Guide/#deploy-cloud-messaging-ge-using-image ). 
2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#cloud-messaging---aeon)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Cloud Messaging - Aeon ###

Please follow the instruction to [Deploy Cloud Messaging GE using Image](http://aeon-platform.readthedocs.io/en/latest/FIWARE-Cloud-Messaging---Installation-and-Administration-Guide/#deploy-cloud-messaging-ge-using-image). At the end of this section, please set **hostname** and **hosts** to send email

> `$ sudo nano /etc/hostname`

and type **aeon.ddns.info**. After run this command 

> `$ sudo hostname -F /etc/hostname`

> `$ sudo nano /etc/hosts`

and type **127.0.0.1 localhost aeon**


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Aeon IP of previous VM with **aeon** alias according to your instance: 

> `192.168.111.101 aeon`


Copy in the **/tmp/** folder the **Aeon-0.2.2.jmx** and **file.properties** files. 
Edit the file.properties file with your right credentials (**email** and **password**), in order to create the account in the Aeon web interface (http://aeon:8000) and to receive the email.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#cloud-messaging---aeon)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Aeon-0.2.2.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`aeon-0.2.2_yyyy-MM-dd HHmmss.csv`

[Top](#cloud-messaging---aeon)