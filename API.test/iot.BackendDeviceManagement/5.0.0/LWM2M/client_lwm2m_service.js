
var config = require('../config'),
    clUtils = require('command-node'),
	lwm2mClient = require('../').client,
    async = require('async'),
    globalDeviceInfo;
    separator = '\n\n\t';
    
lwm2mClient.init(require('../config'));    
    
/*
 * Step 1 - create object
 */    
console.log('Create objects');
var objectUri = ["/6/0", "/3303/0", "/3312/0"];
createObject(objectUri[0]);
createObject(objectUri[1]);
createObject(objectUri[2]);

/*
 * Step 2 - create connection 
 */ 
var host = "localhost";
var port = "5684";
var endpointName = "weather1";
var url = "/weatherBaloon"; 
console.log('Create connection');
connect(host, port, endpointName, url);

/*
 * Step 3 - send data 
 */
var waitTime = 5; //wait time X secs after the connection
setTimeout(function() {  
   console.log('\n--------------------------------\nSend data');
   console.log('Send Longitude and Latitude');
   setResource(objectUri[0], 0, 1);
   setResource(objectUri[0], 1, -4);
   console.log('Send Temperature');
   setResource(objectUri[1], 0, 23);
   
   var i = Math.floor((Math.random() * 6));
   var power = ["On", "Off", "ON", "OFF", "0", "1"]	
   console.log('Send Power: ' + power[i]);
   setResource(objectUri[2], 0, power[i]);

   setTimeout(function() {
      checkDataContextBroker();	        
      //close console	   
      setTimeout(function() {	
         exit();
      }, waitTime * 1000);
      
   },	waitTime * 1000);
}, waitTime * 1000);


function checkDataContextBroker(){
   var http = require("http");

   var options = {
      host: 'orion',
      port: 1026,
      path: '/v2/entities/weather1:WeatherBaloon',
      method: 'GET',
      headers:{
        "Fiware-Service": "service",
        "Fiware-ServicePath": "/path"
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
            clUtils.handleError(error);
        } else {
            //globalDeviceInfo = deviceInfo;
            //setHandlers(deviceInfo);
            console.log('\nConnected:\n--------------------------------\nDevice location: %s', deviceInfo.location);
            //clUtils.prompt();	
        }
    });
}

function handleWrite(objectType, objectId, resourceId, value, callback) {
    console.log('\nValue written:\n--------------------------------\n');
    console.log('-> ObjectType: %s', objectType);
    console.log('-> ObjectId: %s', objectId);
    console.log('-> ResourceId: %s', resourceId);
    console.log('-> Written value: %s', value);
   // clUtils.prompt();

    callback(null);
}

function handleExecute(objectType, objectId, resourceId, value, callback) {
    console.log('\nCommand executed:\n--------------------------------\n');
    console.log('-> ObjectType: %s', objectType);
    console.log('-> ObjectId: %s', objectId);
    console.log('-> ResourceId: %s', resourceId);
    console.log('-> Command arguments: %s', value);
    //clUtils.prompt();

    callback(null);
}

function handleRead(objectType, objectId, resourceId, value, callback) {
    console.log('\nValue read:\n--------------------------------\n');
    console.log('-> ObjectType: %s', objectType);
    console.log('-> ObjectId: %s', objectId);
    console.log('-> ResourceId: %s', resourceId);
    console.log('-> Read Value: %s', value);
    //clUtils.prompt();

    callback(null);
}
function setHandlers(deviceInfo) {
    lwm2mClient.setHandler(deviceInfo.serverInfo, 'write', handleWrite);
    lwm2mClient.setHandler(deviceInfo.serverInfo, 'execute', handleExecute);
    lwm2mClient.setHandler(deviceInfo.serverInfo, 'read', handleRead);
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
        clUtils.handleError(error);
    } else {
        printObject(result);
    }
}

function exit(){
   console.log('Close client');
   console.log('\nExiting client\n--------------------------------\n');
   process.exit();
}
