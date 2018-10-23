# APInf Fiware #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

APInf Fiware is an ES2015 Meteor OAuth handler package for FIWARE IdM available at its [GitHub repository](https://github.com/apinf/apinf-fiware). 

Please note that this test doesn't provide a CSV result, but the test is intended to provide an authentication through FIWARE IdM using OAuth. This test needs a Keyrock 7.0.0 version or greater.

[Top](#apinf-fiware)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Identity Management - KeyRock GE** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install Keyrock 7.0.2 on Ubuntu Virtual Machine.

2. **APInf Fiware GE** - follow the instruction to [install a dedicated Umbrella instance](https://apiumbrella.io/install/).


[Top](#apinf-fiware)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Identity Management KeyRock ###

Follow the steps to install Keyrock 7.0.2 on an Ubuntu 16.04 VM (tested with medium flavor) - you can also use the `install_keyrock.sh` script provided in this folder to install and run keyrock: 

1) connect on it in SSH

2) update packages

> `sudo apt-get update`

3. install dependencies

> `sudo apt-get install curl git build-essential`

4. install nodejs 6

> `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`

> `sudo apt-get update`

> `sudo apt-get install nodejs` 

> `sudo npm install npm -g`

versions installed: node = v6.14.4 and npnm = 6.4.1

 
5. install MySQL (set username and password for mysql server)

> `sudo apt-get install mysql-server`

> `mysql --version`
 
mysql  Ver 14.14 Distrib 5.7.23, for Linux (x86_64) using  EditLine wrapper


6. download KeyRock from github repository

> `git clone https://github.com/ging/fiware-idm.git`

7. copy and edit file config.js file in the `fiware-idm` folder

> `cd fiware-idm`

> `cp config.js.template config.js`

> `nano config.js`

Please set the right credentials in the `Database info` section for your MySQL database

8. install, run script to provide data in to database and start the server

> `npm install`

> `npm run-script create_db`

> `npm run-script migrate_db`

> `npm run-script seed_db`

> `npm start`


You can try it via (let's suppose you are added `keyrock` alias name in the `/etc/hosts` file):

8.1) web browser at link `http://keyrock:3000` using `admin@test.com/1234` credentials, 

8.2) curl call `http://keyrock:3000/version`.

9) get Client Id and Client Secret

login at link `http://keyrock:3000` with `admin@test.com/1234` credentials. Create an **Application** following the wizard; please use as **Callback URL** field  the`http://IP_APINF_FIWARE:3000/_oauth/fiware` link as it is shown in the picture. 
![APInf Login](apinf-login.png?raw=true "APInf Login")

This application provides a Client ID = `d0ed93b5-b145-4938-8b22-dfbd033cd943` and Client Secret = `927193fb-c34c-4020-a97a-b92d77c58e7b`


### 2. APInf Fiware  ###

Follow these instructions to install APInf Fiware in the FIWARE Lab on Ubuntu 16.04 VM: 

1) deploy an Ubuntu 16.04 VM and connect on it in SSH

2) install meteor

`sudo curl https://install.meteor.com/ | sh`

`sudo apt-get update`

`meteor --version`

`(Meteor 1.8)`

3) install node

`sudo apt-get install nodejs`

`sudo apt-get install npm`

4) download simple-todos provided in github

`git clone https://github.com/meteor/simple-todos.git fiware`

`cd fiware`

`meteor`

you can try simply to connect at `http://PUBLIC_IP:3000` link. 

The web page is shown in the next picture. 
![Todo List](todolist.png?raw=true "Todo List")

You can also create a new account using `Sign in` and `Create account`. Here we want to show to login with FIWARE.
So you can also test to login via FIWARE and after creating account. 

Stop the server using this command to add login with FIWARE

`ctrl-c`

5) add fiware package

`meteor add apinf:fiware`

`meteor add apinf:accounts-fiware`

`export ROOT_URL=http://PUBLIC_IP:3000`

Please note that **ROOT_URL** is necessary to set the IP for Callback URL in OAuth.

`meteor`
 
If you try to login in the web page you can see the "Configure Fiware Login" as the next picture shows. 
![Todo List with Fiware](todolist_fiware.png?raw=true "Todo List with Fiware")

6) configure the Fiware Login

Click on "Configure Fiware Login" (after click on Sign in) and type *FIWARE IdM URL*, *Client Id* and *Client Secret* as showed in the picture.

![APInf Login Configuration](apinf-login-conf.png?raw=true "APInf Login Configuration")


[Top](#apinf-fiware)

## Testing step by step ##

**Run the test** simply clicking on "*Sign in with Fiware*". Follow the wizard to authorized the account (only the first time), using the credentials above to log in FIWARE IdM.

After logged, you can access on "Todo List" application with FIWARE IdM user (i.e. admin).

![Logged to Todo List](todolist_admin.png?raw=true "Logged to Todo List")

Now you can add task in the *todo list*!

[Top](#apinf-fiware)