# Fast RTPS #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

[eprosima Fast RTPS](https://github.com/eProsima/Fast-RTPS) is a C++ implementation of the RTPS (Real Time Publish Subscribe) protocol, which provides publisher-subscriber communications over unreliable transports such as UDP, as defined and maintained by the Object Management Group (OMG) consortium.

**Please note** that this test doesn't provide a CSV result because there aren't REST APIs to check and so no JMeter script is included. The test here is intended to provide a manual configuration to test the real functionality (both publisher and subscriber) of the GE. 


[Top](#fast-rtps)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, a Virtual Machines you needed, it's: 

1. **Fast RTPS GE** - follow the instruction to [install a dedicated Fast RTPS instance](https://github.com/eProsima/Fast-RTPS#installation-guide).


[Top](#fast-rtps)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Fast RTPS GE ###

Follow the steps to install Fast RTPS on an Ubuntu 16.04 VM (tested with medium flavor) following these steps:

1) connect on it in SSH

2) update packages

> `sudo apt-get update`

3. install dependencies

> `sudo apt-get install gcc gettext build-essential libboost-all-dev`

4. install JDK 8

> `sudo add-apt-repository ppa:webupd8team/java`

> `sudo apt-get update`

> `sudo apt-get install oracle-java8-installer`

> `java -version`

and it's `java version "1.8.0_191"`

5. copy and untar the `eProsima_FastRTPS-1.5.0-Linux.tar.gz` file provide in this folder

> `wget https://github.com/Fiware/test.Functional/blob/master/API.test/i2nd.FastRTPS/1.5.0/eProsima_FastRTPS-1.3.0-Linux.tar.gz?raw=true -O eProsima_FastRTPS-1.3.0-Linux.tar.gz`

> `tar -xvzf eProsima_FastRTPS-1.3.0-Linux.tar.gz`

6. **eProsima Fast RTPS** requires the installation of `eProsima FastCDR` library

> `cd requiredcomponents/`
   
> `tar -xvzf eProsima_FastCDR-1.0.6-Linux.tar.gz`
   
> `cd eProsima_FastCDR-1.0.6-Linux`

> `./configure --libdir=/usr/lib`

> `make`

> `sudo make install`
   
7. install the eProsima Fast RTPS software, go in the `eProsima_FastRTPS-1.3.0-Linux/` folder with 2 times `cd ..`

> `cd eProsima_FastRTPS-1.3.0-Linux/`

> `./configure --libdir=/usr/lib`

> `make`

> `sudo make install`

11. create a folder for the test (`/home/ubuntu/test/`) and put **MyType.idl** file 

> `mkdir /home/ubuntu/test`

> `cd /home/ubuntu/test`

copy the **MyType.idl** file.
 
12. compile the file with **fastrtpsgen**

> `fastrtpsgen -example x64Linux2.6gcc MyType.idl`

> `make -f makefile_x64Linux2.6gcc`


[Top](#fast-rtps)

## Testing step by step ##

**Run the test** simply to use two consoles to run both subscriber and publisher. In order to do this open a shell and go in the **/home/ubuntu/test/bin/x64Linux2.6gcc** folder

> `cd /home/ubuntu/test/bin/x64Linux2.6gcc`

> `./MyTypePublisherSubscriber subscriber`

Open a second shell and go in **/home/ubuntu/test/bin/x64Linux2.6gcc** folder 

> `cd /home/ubuntu/test/bin/x64Linux2.6gcc`

> `./MyTypePublisherSubscriber publisher`

Use **y** (yes) to publish (to increment the *count* value), **n** to finish.

This is the view in the subscriber shell:

	ubuntu@fastrtps:~/test/bin/x64Linux2.6gcc$ ./MyTypePublisherSubscriber subscriber
	Starting
	Waiting for Data, press Enter to stop the Subscriber.
	Subscriber matched
	Sample received, count=1
	Sample received, count=2
	Sample received, count=3
	Sample received, count=4
	Sample received, count=5
	Sample received, count=6
	Subscriber unmatched

and this is the view in the publisher shell:

	ubuntu@fastrtps:~/test/bin/x64Linux2.6gcc$ ./MyTypePublisherSubscriber publisher
	Starting
	Publisher created, waiting for Subscribers.
	Publisher matched
	Sending sample, count=1, send another sample?(y-yes,n-stop): y
	Sending sample, count=2, send another sample?(y-yes,n-stop): y
	Sending sample, count=3, send another sample?(y-yes,n-stop): y
	Sending sample, count=4, send another sample?(y-yes,n-stop): y
	Sending sample, count=5, send another sample?(y-yes,n-stop): y
	Sending sample, count=6, send another sample?(y-yes,n-stop): n
	Stopping execution
	ubuntu@fastrtps:~/test/bin/x64Linux2.6gcc$

![Example Pub/Sub](pubsub.png?raw=true "Example Pub/Sub")	

[Top](#fast-rtps)