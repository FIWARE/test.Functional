# PEP Proxy - Wilma #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

The PEP Proxy GE is a backend component, without frontend interface and available at its [GitHub repository](https://github.com/ging/fiware-pep-proxy). 

[Top](#pep-proxy---wilma)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - follow the instruction to [deploy a dedicated KeyRock instance](https://catalogue.fiware.org/enablers/identity-management-keyrock/creating-instances). 
2. **PEP Proxy - Wilma** - download PEP Proxy source code via github at this [link](https://github.com/ging/fiware-pep-proxy.git) and run it (follow the next preliminary steps section).
3. **JMeter** - select "base_ubuntu_14.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#pep-proxy---wilma)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management - KeyRock ###

After deployed KeyRock 5.4.0 VM, there are the follow steps in order to get information to configure PEP Proxy config.js file:

1. login in KeyRock web interface (Horizon) at `keyrock_ip:8000` and use default credentials (`idm/idm`) 
2. create an application (just follow the wizard) to get `client id` and `client secret`
3. register a new PEP Proxy to get credentials (`username` and `password`) in the PEP Proxy registration

### 2. PEP Proxy - Wilma ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add KeyRock IP of previous VM with **keyrock** alias according to your instance: 

> `192.168.111.210 keyrock`

Then, you have to configure the config.js file of Wilma GE with KeyRock:

1. edit the config.js file (in /home/ubuntu/fiware-pep-proxy folder); just to change the alias for IP address of KeyRock and the credentials of PEP Proxy:

> `config.account_host = 'keyrock';`


> `config.keystone_host = 'keyrock';`

> `config.keystone_port = 5000;`

> `....`

> `config.username = 'pep_proxy_26c243bbc0364151a0d5fd19201d7763';`
> `config.password = '271a3721dae346d4bb5f444677f3f392';`

2. start the server

> `$ sudo node server.js`


### 3. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add PEP Proxy and KeyRock IPs of previous VMs with **pep_proxy** and **keyrock** aliases according to your instances: 

> `192.168.111.211 pep_proxy`

> `192.168.111.210 keyrock`


Copy in the **/tmp/** folder the **PepProxy-6.2.jmx**, **auth-token.sh** and **file.properties** files.

Edit the auth-token.sh file; you have to update only CLIENT_ID and CLIENT_SECRET. Run the `auth-token.sh` file in the shell to get the token. Don't forget to change the permission to file (`sudo chmod +x auth-token.sh`). Please use username and password as input parameters in the shell: 

> `./auth-token.sh idm idm`

and copy the token and put it in the `file.properties` file:

> `sudo nano file.properties` 

update the file:

> `token = jU56BZQjz6xmTSmLwxN4ifYuAaviPL`
 

#### Install JMeter 3 (on Ubuntu 14.04) ####

1. `sudo apt-get update` - to refresh packages metadata
2. `sudo apt-get install openjdk-7-jre-headless` - Java 7 is pre-requisite for JMeter 3.0
3. `wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-3.1.tgz` - download JMeter 3.1
4. `tar -xf apache-jmeter-3.1.tgz` - unpack JMeter

[Top](#pep-proxy---wilma)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-3.1/bin/jmeter -n -t /tmp/PepProxy-6.2.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`pep_proxy-6.2_yyyy-MM-dd HHmmss.csv`

[Top](#pep-proxy---wilma)