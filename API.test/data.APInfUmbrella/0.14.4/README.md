# APInf Umbrella #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

APInf Umbrella is open source under the [MIT license](https://github.com/NREL/api-umbrella/blob/master/LICENSE.txt) available at its [GitHub repository](https://github.com/apinf/api-umbrella). 

[Top](#apinf-umbrella)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **APInf Umbrella GE** - follow the instruction to [install a dedicated Umbrella instance](https://apiumbrella.io/install/).

2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#apinf-umbrella)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. APInf Umbrella  ###

Follow these instructions to install APInf Umbrella in the FIWARE Lab on Ubuntu 16.04 VM (for installation details see at this [link](https://apiumbrella.io/install/) ): 

1) deploy an Ubuntu 16.04 VM and connect on it in SSH

2) download and install the package::

> `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61`

> `echo "deb https://dl.bintray.com/nrel/api-umbrella-ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/api-umbrella.list`

> `sudo apt-get update`

> `sudo apt-get install api-umbrella`

3) start umbrella

> `sudo /etc/init.d/api-umbrella start`

4) get **API Key** and **Token**

- to get API Key go to *http://your_hostname* and [sign up link](https://your_hostname/signup). After registration you get the API Key for example `17KR9rno5TyS3efmnNfEBB3r1um6yMvlTpLCPIoG`.

- to get Token go to *http://your_hostname/admin* and [sign up link https://your_hostname/admins/signup]. After registration you get the Token in *My Account*, for example `88lEK3ZVNklfnEPk0JOurq84bN2WZxN2vUOzI3kT`.

Please save *API Key* and *Token* in the *file.properties* file.

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add Umbrella IP of previous VM with **umbrella** alias according to your instance: 

> `192.168.111.194 umbrella`

Copy in the **/tmp/** folder the **APInf-Umbrella-0.14.4.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#apinf-umbrella)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/APInf-Umbrella-0.14.4.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`umbrella-0.14.4_yyyy-MM-dd HHmmss.csv`

[Top](#apinf-umbrella)