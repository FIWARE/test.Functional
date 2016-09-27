# test.Functional.NGSI_API.test

Repository NGSI_API.test contains work established on testing GEi's with NGSI v1 & v2 compliance.
An Model based testing approach was established.
You will find three main folder for each NGSI version:
	-	Test Description : an HTML version of the test produced where you can find abstract tests with a description of the expected behaviour and check the tracability between tests and requirements.  
	- 	Test Model : The Model realised in order to generate abstract test case. It is an CertifyIt project made with and only compatible with IBM RSA.
	-	Test execution : you can find an XML execution report containing for each test case one or more test steps. Each test step defines an operation on NGSI and contains an URL, a HTTP method, a payload, headers, assertions and execution results. You will also find a SQL dump file containing the test data used to build the xml execution/result file. 
