# test.Functional.API.test

Repository API.test contains the automatic scripts and commands to execute functional API tests for each Generic Enables.
The xml files have been produced using tool soapUI 4.5.1 SMARTBEAR.
Each soupUI project contains the set of functional tests related to a specific Generic Enabler.
Each soupUI project is an xml file that can be imported into soapUI and easily analyzed and executed.
A soapUI project contains a test suite composed by more test cases. 
A test case is the REST request calling the API to test.
The REST request endpoints configured into the soupUI project file contain the IP address of the host where the tests have been performed. 
Each component must be successfully installed according to the guidelines reported in the Installation and Administration guides. 
The Generic Enabler documentation is available on the FIWARE catalogue http://catalogue.fiware.org/enablers in section dedicated to the documentation of each specific component.
