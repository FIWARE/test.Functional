# How to get all GEs from catalogue #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

It's a JMeter script to get basic info for any GEs. 

[Top](#how-to-get-all-ges-from-catalogue)

## Testing environment ##

In order to get info about all GEs, only a Virtual Machine you needed: 


1. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#how-to-get-all-ges-from-catalogue)

## Overall preliminary setup ##

### 1. JMeter ###

Copy in the **/tmp/** folder the **Catalogue.jmx** file.


#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#how-to-get-all-ges-from-catalogue)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/Catalogue.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`all_ges_yyyy-MM-dd HHmmss.csv`

[Top](#how-to-get-all-ges-from-catalogue)