# AuthZForce #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

AuthZForce is an implementation of the FIWARE Identity Management Generic Enabler by THALES available at its [GitHub repository](https://github.com/authzforce). 

[Top](#authzforce)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Authorization PDP - AuthZForce** - follow the instruction to [Deploying a dedicated GE instance based on an image](https://catalogue.fiware.org/enablers/authorization-pdp-authzforce/creating-instances).
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#authzforce)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:


### 1. Authorization PDP - AuthZForce ###

If you have the right instance in the FIWARE Lab then you can jump to step 1.6, otherwise just follow all steps to install
the AuthZForce 8.0.1 on `Ubuntu 16.04` following these steps:

**1.1 - Deploy Ubuntu 16.04**

Deploy an Ubuntu 16.04 VM in the FIWARE Lab (in this test it was used a *flavor medium*) and update the packages.

> `sudo apt-get update`

**1.2 - Install JDK 8** 

> `sudo apt-get install openjdk-8-jre`

> `java -version`

for example, in this test results `openjdk version "1.8.0_151"`.

**1.3 - Install Tomcat 8**

> `sudo apt-get install tomcat8`

**1.4 - Download the right version from repository**. At this [link](http://repo1.maven.org/maven2/org/ow2/authzforce/authzforce-ce-server-dist/) you can find your right distribution. In general the naming is MAJOR.MINOR.PATH (Semantic Versioning) = M.m.P: `http://repo1.maven.org/maven2/org/ow2/authzforce/authzforce-ce-server-dist/M.m.P/authzforce-ce-server-dist-M.m.P.deb`

and in this case, download it (in `/home/ubuntu` folder) using `wget` command:

> `wget http://repo1.maven.org/maven2/org/ow2/authzforce/authzforce-ce-server-dist/8.0.1/authzforce-ce-server-dist-8.0.1.deb`

If you cannot download it, you can find the `authzforce-ce-server-dist-8.0.1.deb` distribution in this folder.

**1.5 - Install AuthZForce server**

> `sudo apt-get install gdebi curl`

> `sudo gdebi authzforce-ce-server-dist-8.0.1.deb`

At the end, you will see a message giving optional instructions to go through. Please follow them as necessary.

Note that Tomcat default configuration may specify a very low value for the Java Xmx flag, causing the Authzforce webapp startup to fail. In that case, make sure Tomcat with Xmx at 1 Go or more (2 Go recommended). You can fix it as follows:

> `sudo sed -i "s/-Xmx128m/-Xmx1024m/" /etc/default/tomcat8`

> `sudo service tomcat8 restart`

**1.6 - Attribute Provider configuration**
*Note* that in order to run successful the JMeter script, you have to add the `attribute provider` just follow how *'Integrating an Attribute Provider into AuthzForce'* at this [link](https://github.com/authzforce/core/wiki/Attribute-Providers#integrating-an-attribute-provider-into-authzforce). All Files are also available in this folder.

* add the `authzforce-ce-core-pdp-testutils-10.3.0.jar` library in to `/opt/authzforce-ce-server/webapp/WEB-INF/lib`

* edit `/opt/authzforce-ce-server/conf/authzforce-ext.xsd` schema file simply adding this line:
	
> `<xs:import namespace="http://authzforce.github.io/core/xmlns/test/3" />`

* edit `/opt/authzforce-ce-server/conf/catalog.xml` file simply adding this line:

> `<uri name="http://authzforce.github.io/core/xmlns/test/3" uri="classpath:org.ow2.authzforce.core.pdp.testutil.ext.xsd" />`
 
 * restart the server `sudo service tomcat8 restart`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add AuthZForce IP of previous VM with **authzforce** alias according to your instance: 

> `192.168.111.149 authzforce`


Copy in the **/tmp/** folder the **AuthZForce-8.0.1.jmx** file.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#authzforce)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/AuthZForce-8.0.1.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`authzforce-8.0.1_yyyy-MM-dd HHmmss.csv`

[Top](#authzforce)