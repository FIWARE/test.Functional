# Cygnus and Storages #

* [Introduction](#introduction)

## Introduction ##

Cygnus is an easy to use, powerful, and reliable system to process and distribute data. Internally, Cygnus is based on (Apache NiFi)[https://nifi.apache.org/docs.html], NiFi is a dataflow system based on the concepts of flow-based programming.
  
In the this section it's presented a list of functional test for different storage systems.
For any test, the script sends data to Orion, and Orion sends data (attribute), via subscription, in the storage. 
After, the script checks if the attribute is really stored in the storage.

1. [Mongo DB](cygnus.mongo)

2. [MySQL database](cygnus.mysql)

3. [PostgreSQL database](cygnus.postgres)


[Top](#cygnus-and-storages)