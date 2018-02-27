
var config = require('../config'),
	lwm2mClient = require('../').client,
    async = require('async'),
    globalDeviceInfo;
    separator = '\n\n\t';
    
lwm2mClient.init(require('../config'));    
    
/*
 * Step 1 - create object
 */    
var objectUri = "/7392/0";
console.log('Create object');
createObject(objectUri);

/*
 * Step 2 - create connection 
 */ 
var host = "localhost";
var port = "5684";
var endpointName = "robot1";
var url = "/"; 
console.log('Create connection');
connect(host, port, endpointName, url);

/*
 * Step 3 - send data 
 */
 var waitTime = 5; //wait time X secs after the connection
 
setTimeout(function() {
   console.log('\n--------------------------------\nSend data after '+ waitTime +' seconds');
   var battery = Math.floor((Math.random() * 100) + 1);
   console.log('Send first data: battery = ' + battery);
   setResource(objectUri, 1, battery); 
   console.log('Send second data');
   setResource(objectUri, 2, "Hello world");
   console.log('Send third data');
   setResource(objectUri, 3, "[8,8]"); 

   console.log('\n--------------------------------\nUpdate data'); 	
   setTimeout(function() {	      	
      battery = Math.floor((Math.random() * 100) + 1);
      console.log('Update first data: battery = ' + battery);
      setResource(objectUri, 1, battery);
      
      console.log('\n--------------------------------\nWaiting to read data from Context Broker');
      setTimeout(function() {
	 checkDataContextBroker();	        
         
	 //close console	   
         setTimeout(function() {	
            exit();
         }, waitTime * 1000);
	 
      }, waitTime * 1000);
      
   },	waitTime * 1000);	
}, waitTime * 1000);


function checkDataContextBroker(){
   var http = require("http");

   var options = {
      host: 'orion',
      port: 1026,
      path: '/v2/entities/Robot:robot1/attrs/Battery',
      method: 'GET',
      headers:{
        "Fiware-Service": "smartGondor",
        "Fiware-ServicePath": "/gardens"
      } 	   
   };

   callback = function(response) {
     var str = '';

     response.on('data', function (chunk) {
        str += chunk;
     });

     response.on('end', function () {
       console.log(str);
     });
   }

   http.request(options, callback).end();
}




//commands 
//use objectUri = /7392/0
function createObject(objectUri) {
    lwm2mClient.registry.create(objectUri, handleObjectFunction);
}

//use /75001/2 0 440.81
function setResource(objectUri, resourceId, resourceValue) {
    lwm2mClient.registry.setResource(objectUri, resourceId, resourceValue, handleObjectFunction);
}

//use connect <host> <port> <endpointName> <url>  
function connect(host, port, endpointName, url) {
	lwm2mClient.register(host, port, url, endpointName, function (error, deviceInfo) {
        if (error) {
            console.log('\nError:\n--------------------------------\nCode: %s\nMessage: %s\n\n', error.name, error.message);
        } else {
            //globalDeviceInfo = deviceInfo;
            console.log('\nConnected:\n--------------------------------\nDevice location: %s', deviceInfo.location);
        }
    });
}


function printObject(result) {
    var resourceIds = Object.keys(result.attributes);
    console.log('\nObject:\n--------------------------------\nObjectType: %s\nObjectId: %s\nObjectUri: %s',
        result.objectType, result.objectId, result.objectUri);

    if (resourceIds.length > 0) {
        console.log('\nAttributes:');
        for (var i=0; i < resourceIds.length; i++) {
            console.log('\t-> %s: %s', resourceIds[i], result.attributes[resourceIds[i]]);
        }
        console.log('\n');
    }
}

function handleObjectFunction(error, result) {
    if (error) {
    	console.log('\nError:\n--------------------------------\nCode: %s\nMessage: %s\n\n', error.name, error.message);
    } else {
        printObject(result);
    }
}

function exit(){
   console.log('\nExiting client\n--------------------------------\n');
   process.exit();
}
