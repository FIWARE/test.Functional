#  Orion Context Broker:  functional test guidelines #
# 1st DRAFT WORK IN PROGRESS VERSION! #

Orion is the FIWARE GE reference implementation of the ContextBroker Generic Enabler by Telefonica available at its [GitHub repository](https://github.com/telefonicaid/fiware-orion). 


## Testing environment ##



## Overall preliminary setup ##


> ContextBroker:

> JMeter:



##Testing step by step##

1. *TODO*
2. *TODO*
3. Open a shell on JMeter server and **start the test** using the command `<jmeter-path>/jmeter.sh -n -t <JMETER-SCRIPT-PATH>OrionContextBroker-1.3.0.jmx`
6. **Retrieve the results** of JMeter session test once it has ended. They are colleceted in a csv file which is placed in the same JMeter execution folder and named as following: `OrionContextBroker-1.3.0_yyyy-MM-dd HHmmss.csv`
