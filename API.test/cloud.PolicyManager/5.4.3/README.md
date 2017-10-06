# Policy Manager - Bosun #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Policy Manager - Bosun is the FIWARE GE by Telefonica available at its GitHub repository as [fiware-cloto](https://github.com/telefonicaid/fiware-cloto) and [fiware-facts](https://github.com/telefonicaid/fiware-facts).

[Top](#policy-manager---bosun)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Policy Manager - Bosun GE** - follow the instruction for [Installation & Administration Guide](http://fiware-cloto.readthedocs.io/en/readthedocs/admin_guide/). 

2. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#policy-manager---bosun)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Policy Manager - Bosun ###

Please follow the instruction for [Installation & Administration Guide](http://fiware-cloto.readthedocs.io/en/readthedocs/admin_guide/) and configure the */etc/fiware.d/fiware-cloto.cfg* file with the right Orion Context Broker public IP (for *CONTEXT_BROKER_URL* label).


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Bosun IP of previous VM with **bosun** alias according to your instance: 

> `192.168.111.131 bosun`


Copy in the **/tmp/** folder the **Bosun-5.4.3.jmx** and **file.properties** files. 
Edit the file.properties file with your FIWARE LAB credentials (**email** and **password**), and **serverId** parameter (the 'ID' of your running instance in the FIWARE LAB that you want to use the policy manager).


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#policy-manager---bosun)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Bosun-5.4.3.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`bosun-5.4.3_yyyy-MM-dd HHmmss.csv`

[Top](#policy-manager---bosun)