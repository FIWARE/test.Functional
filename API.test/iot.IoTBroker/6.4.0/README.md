# Aeron IoT Broker #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

Aeron IoT Broker is the FIWARE GE reference implementation of the IoT Broker Generic Enabler by NEC available at its [GitHub repository](https://github.com/Aeronbroker/Aeron).

[Top](#aeron-iot-broker)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, three Virtual Machines you needed, which are: 

1. **Aeron IoT Broker** - follow the instruction to [deploy a dedicated IoT Broker instance](https://catalogue.fiware.org/enablers/iot-broker/creating-instances). Since this GEri, in order to work properly, rely on the GE **IoT Discovery**, a mockup implementation of the latter - available from the same owner- will be installed on the same machine.

2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#aeron-iot-broker)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Aeron IoT Broker ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IoTBroker IP with **iotbroker** alias according to your instance: 

> `217.172.12.223 iotbroker`
 
Since this IoT Broker GE is not available as deploy in the FIWARE Cloud, follow the steps to install and run it (as root user) in to a **base_ubuntu_14.04** VM via docker: 

> `sudo -i`

1) update packages:

> `apt-get update`

2) install docker:

> `apt-get install apt-transport-https ca-certificates curl software-properties-common`

> `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

> `apt-key fingerprint 0EBFCD88`

> `add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`

> `apt-get update`

> `apt-get install docker-ce`

3) install JDK: 

> `add-apt-repository ppa:webupd8team/java`

> `apt-get update`

> `apt-get install oracle-java8-installer`

4) install and start the `iotbroker-tester`:

> `apt-get install git maven`

> `git clone https://github.com/Fiware/test.NonFunctional.git`

> `cd test.NonFunctional/testers/aeron/fiware-iotbroker-tester/`

add `maven-compiler-plugin` artifact in the `build/plugins` of pom.xml file as follow:

	 <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>2.3.2</version>
        <configuration>
            <source>1.6</source>
            <target>1.6</target>
        </configuration>
    </plugin>

and save it. 

> `mvn package`

> `cd target`

> `java -jar iotbroker-tester-1.0.5.jar  data-provider 1`

5) start `IoTBroker`

> `docker run -t -p 8065:8065 -p 8060:8060 -p 5984:5984 fiware/iotbroker:v6.4-standalone -p iotbroker_semantic="disabled" -p iotbroker_producedtype="application/xml"`  

and add `hosts` in docker container:

> `docker ps -a`

to get the container id

> `docker exec -it CONTAINER_ID bash`

> `echo 217.172.12.223 iotbroker >> /etc/hosts`

> `exit`


### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add IoT Broker IP with **iotbroker** alias according to your instance: 

> `217.172.12.223 iotbroker`

Copy in the **/tmp/** folder the **IoTBroker-6.4.0.jmx** file and the overall **NGSI** folder.


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter


## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/IoTBroker-6.4.0.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`iotbroker-6.4.0_yyyy-MM-dd HHmmss.csv`

[Top](#aeron-iot-broker)