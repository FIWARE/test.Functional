# Functional tests #

The functional tests, that are intended to check the API REST of the FIWARE GEs published in the [FIWARE Catalogue](https://catalogue.fiware.org/), namely if the service answers to the call as expected (e.g. Status code as defined in the documentation). The tests are based on JMeter scripts in order to have a standard method of testing the APIs provided by GEs. JMeter was chosen as test functional tool also in order to automate the test process.

The functional testing results are recorded in a GitHub repository that contains the automatic scripts and commands to execute functional API tests for each Generic Enabler by using Jmeter tool. Each JMeter project is a file that can be imported into jmeter GUI and easily analyzed and executed. The REST request endpoints configured into the JMeter project file contain the IP address of the host where the tests have been performed. Each GE component must be successfully installed according to the guidelines reported in the installation and Administration guides. The [Generic Enabler](https://catalogue.fiware.org/enablers) documentation is available on the FIWARE Catalogue in the section dedicated to the documentation of each specific component. 

For each Generic Enabler version in the the GitHub repository is available a READ.me file with a summary of the installation steps to be performed to execute the test. In the GitHb repository, for each GE there is a folder with the name convention <GE chapter name>.<GE name>, inside can be found different sub-folders for each version of the GE tested (x.y.z). 

For each GE version are provided in the related GitHub sub-folder: 

* The **README.md** file that contains the specific instructions related on how to install the testing environment (GE and JMeter tool), how to setup all components and how to execute the test.

* The JMeter script file with the name convention <GE name>-<version>.jmx. It is the input file for the JMeter tool and it contains all APIs call using data provided principally by official  GE API documentation.

* The “results” subfolder with the JMeter output files in CSV format. The file name convention is <GE name>-<GE version>_<date and time of the test execution>.csv. The result of the test is a table where, for each tested API, there is the information about the success of the test or the error message in case of failure. 

* Any additional file for dedicated configuration that is necessary to execute the test, such as, possibly, JMeter plugins, properties files for specific GE or test environment, etc. Anyway, in the given GE README.md file there are the instructions that explain how to manage those files.     

