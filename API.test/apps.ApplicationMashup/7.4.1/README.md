# Application Mashup WireCloud #

* [Introduction](#introduction)
* [Testing environment](#testing-environment)
* [Overall preliminary setup](#overall-preliminary-setup)
* [Testing step by step](#testing-step-by-step)


## Introduction ##

WireCloud builds on cutting-edge end-user development, RIA and semantic technologies to offer a next-generation end-user centred web application mashup platform provided by [CoNWet](conwet.com) available at its [GitHub repository](https://github.com/Wirecloud/wirecloud). 

[Top](#application-mashup-wirecloud)

## Testing environment ##

The testing environment can be easily set up through a FIWARE Lab, which is based on the cloud operating system OpenStack. 
In order to test this GE, two Virtual Machines you needed, which are: 

1. **Application Mashup - WireCloud GE** - follow the instruction to [deploy a dedicated WireCloud instance](https://catalogue-server.fiware.org/enablers/application-mashup-wirecloud).
2. **JMeter** - select "base_ubuntu_16.04" image in the FIWARE Cloud Portal to install JMeter on Ubuntu Virtual Machine.

[Top](#application-mashup-wirecloud)

## Overall preliminary setup ##

Once the HW necessary for the test described previously at **Testing Environment** chapter has been setup, the following preliminary steps need to be accomplished before to start the test process:

### 1. Application Mashup - WireCloud ###

Before to deploy or install WireCloud you need to create an application in your Identity Manager because WireCloud uses an *OAuth2 authentication*; in this test we are using the Identity Manager of FIWARE Lab (https://account.lab.fiware.org).

So please login and create an application from web interface of FIWARE Lab and use `http(s)://${wirecloud_server}/complete/fiware/` in the **Callback URL** as figure showed.

![wirecloud](wirecloud.png?raw=true "Creating of the application")

Please let take notes of **Client ID** and **Client Secret** values; you need them in the next steps.


If there isn't available a dedicate instance, please follow these instructions to install KeyRock manually following these instructions (tested on Ubuntu 16.04): 

**1) deploy an Ubuntu 16.04 VM (tested with medium flavor) and connect on it in SSH**

**2) install pip (with Python 2.7.12) in `/home/ubuntu` folder** (see the doc at this [link](https://wirecloud.readthedocs.io/en/stable/installation_guide/#debianubuntu))

> `wget https://bootstrap.pypa.io/get-pip.py`

> `sudo python get-pip.py`

> `pip -V`

pip 18.1 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)

**3) update packages**

> `sudo apt-get update`

> `sudo apt-get install python python-pip --no-install-recommends -y`

> `sudo apt-get upgrade -y`

> `sudo apt-get update`

**4) install dependecies**

> `sudo pip install "setuptools>18.5"`

> `sudo apt-get install build-essential python-dev libxml2-dev libxslt1-dev zlib1g-dev libpcre3-dev libcurl4-openssl-dev libjpeg-dev`

> `sudo pip install pyOpenSSL ndg-httpsclient pyasn1`

> `sudo pip install wirecloud`

and to test version, type:

> `wirecloud-admin --version`

and in this test it's `1.2.0`

> `sudo adduser --system --group --shell /bin/bash wirecloud`
   
> `cd /opt`

> `sudo wirecloud-admin startproject wirecloud_instance`

**5) install postgres**

> `sudo apt-get install postgresql`

> `sudo su postgres`

create **wc_user** user (with password: **wc_user**) and **wirecloud** as database name 

> `createuser wc_user -P`

> `createdb --owner=wc_user wirecloud`

> `exit`

please edit file `/etc/postgresql/X.X/main/pg_hba.conf` as follow:

> `sudo nano /etc/postgresql/9.5/main/pg_hba.conf`

set *trust* method instead of *peer* for all users 

	# TYPE  DATABASE        USER            ADDRESS                 METHOD
	# "local" is for Unix domain socket connections only
	local   all             all                                     trust

and restart postgres

> `sudo service postgresql restart`


**6) edit file setting.py in the `/opt/wirecloud_instance/` with postgres database and credentials**

> `sudo nano wirecloud_instance/settings.py`

and use this configuration (for postgres):

	DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',       # Add 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'wirecloud',           # Or path to database file if using sqlite3.
        # The following settings are not used with sqlite3:
        'USER': 'wc_user',
        'PASSWORD': 'wc_user',
        'HOST': '',                      # Empty for localhost through domain sockets or '127.0.0.1' for localhost through TCP.
        'PORT': '',                      # Set to empty string for default.
    }
   
install psycopg2

> `sudo pip install psycopg2`

> `sudo pip install psycopg2-binary`

**7) populate the database**

> `sudo pip install requests`

> `sudo pip install docopt`

> `sudo python manage.py migrate`

and create superuser: admin/admin

> `sudo python manage.py createsuperuser`

	Username (leave blank to use 'root'): admin
	Email address: admin@email.com
	Password: ***** (admin)
	Password (again): ***** (admin)
	Superuser created successfully.

> `sudo python manage.py populate`

**8) Integration with Identity Manager**

Before to start the WireCloud it's necessary to configure it with the Identity Manager of FIWARE Lab in order to get the token. 
The instruction are available at this [link](https://wirecloud.readthedocs.io/en/stable/installation_guide/#integration-with-the-idm-ge)

> `sudo pip install "social-auth-app-django"`

edit the **settings.py** and **urls.py** files (these files are provided in this folder) in this way

*settings.py*
   
> `sudo nano wirecloud_instance/settings.py`
   
*8.1 - remove wirecloud.oauth2provider and add social_django in INSTALLED_APPS*

	INSTALLED_APPS += (
    # 'django.contrib.sites',
    #'wirecloud.oauth2provider',
    'social_django',
    'wirecloud.fiware',
    'haystack'
    )

*8.2 - add AUTHENTICATION_BACKENDS in the 'Login/logout URLs' section*

	AUTHENTICATION_BACKENDS = (
    'wirecloud.fiware.social_auth_backend.FIWAREOAuth2',
    )

*8.3 - add IdM address with Client ID and Client Secret info at the end of settings.py file*

	FIWARE_IDM_SERVER = "https://account.lab.fiware.org"
	SOCIAL_AUTH_FIWARE_KEY = "14f4a2b23d2c4d87b808cadd3210ccd3"
	SOCIAL_AUTH_FIWARE_SECRET = "0d4edcb7757b4339a7bc67b470400790"

*urls.py*

> `sudo nano wirecloud_instance/urls.py`

*8.4 - add the following import line at the beginning of the file* 

> `from wirecloud.fiware import views as wc_fiware`


*8.5 remove url django_auth.login with wc_fiware.login*

    # url(r'^login/?$', django_auth.login, name="login"),
    url(r'^login/?$', wc_fiware.login, name="login"),

*8.6 Add social-auth-app-django url endpoints at the end of the pattern list* 

	url('', include('social_django.urls', namespace='social')),

rerun again to take the changes

> `sudo python manage.py migrate; sudo python manage.py collectstatic --noinput`


and start **WireCloud** at **8000** port in this way

> `sudo python manage.py runserver 0.0.0.0:8000 --insecure`

**9) Authorize WireCloud with IdM**

At this point you have to **authorize** the access in WireCloud with FIWARE credentials. 

In order to do this use the browser to connect at this link (http://wirecloud:8000) and make the login with FIWARE credentials to authorize wirecloud application.

### 2. JMeter ###

Open the **/etc/hosts** file by using this command:

> `sudo nano /etc/hosts` 

and add WireCloud IP of previous VM with **wirecloud** alias according to your instance: 

> `192.168.111.157 wirecloud`


Copy in the **/tmp/** folder the **WireCloud-7.4.1.jmx**, **CoNWeT_bae-details_0.1.1.wgt** and **file.properties** files.

Please copy also the `auth-token.sh` file (provided in this folder) in `/home/ubuntu` folder and edit it using the Client ID and Client Secret values above.


> `cd /home/ubuntu/`

> `sudo chmod +x auth-token.sh`

> `./auth-token.sh your_email your_password`

the script provides the **token** which you have to set in the `file.properties` file:

> `token = Bearer <TOKEN_FROM_SCRIPT>`


#### Install JMeter 4.0 on Ubuntu 16.04 ####

1. `sudo add-apt-repository ppa:webupd8team/java` - add Java in the repository

2. `sudo apt-get update` - to refresh packages metadata

3. `sudo apt-get install oracle-java8-installer` - Java 8 is pre-requisite for JMeter 4.0

4. `sudo wget -c http://ftp.ps.pl/pub/apache/jmeter/binaries/apache-jmeter-4.0.tgz` - download JMeter 4.0

5. `sudo tar -xf apache-jmeter-4.0.tgz` - unpack JMeter

[Top](#application-mashup-wirecloud)

## Testing step by step ##

**Run the test** with the follow command: 

`./apache-jmeter-4.0/bin/jmeter -n -t /tmp/WireCloud-7.4.1.jmx`

**Retrieve the results** of JMeter session test once it has ended. They are collected in a **csv file** which is placed in the same folder where you are using the jmx file and named as following: 

`wirecloud-7.4.1_yyyy-MM-dd HHmmss.csv`

[Top](#application-mashup-wirecloud)