
'use strict';

var fs = require('fs'),
    defaultConfig = require('../client-config.js'),
    mqtt = require('mqtt'),
    async = require('async'),
    _ = require('underscore'),
    mqttClient,
    config = {
        host: defaultConfig.mqtt.host,
        port: defaultConfig.mqtt.port,
        apikey: defaultConfig.device.apikey,
        deviceId: defaultConfig.device.id
    },
    separator = '\n\n\t',
    token;

/*
 * Step 1 - connect to MQTT Broker
 */ 
var command = [];  
connect(command);
    
/*
 * Step 2 - showConfig
 */
command = [];
 getConfig(command);  
    
/*
 * Step 3 - singleMeasure  -  [t, 33]
 */
var temperature = Math.floor((Math.random() * 100)); 
command = ['t', temperature.toString()]; 
console.log('Send to orion singleMeasure: t=' + temperature);       
singleMeasure(command); 
    
/*
 * Step 4 - multipleMeasure  -  [t=33;l=22]
 */
setTimeout(function() { 
   var temperature = Math.floor((Math.random() * 100)); 
   var luminosity = Math.floor((Math.random() * 100)); 
   command = ['t='+temperature+';l='+luminosity];  
   console.log('Send to orion multipleMeasure: t=' + temperature + ', l=' +luminosity);   
   multipleMeasure(command);
}, 1500);	


/*
 * Step 5 - checkDataContextBroker & exit
 */
var waitTime = 10; //wait time X secs after the connection
setTimeout(function() {
      checkDataContextBroker();
	 //close console	   
         setTimeout(function() {	
            exit();
         }, waitTime * 100);
}, waitTime * 1000);	  


function exit(){
   console.log('\nExiting client\n--------------------------------\n');
   process.exit();
}

function checkDataContextBroker(){
   var http = require("http");
   console.log('\nRead newer data from orion\n--------------------------------\n');
   var options = {
      host: 'orion',
      port: 1026,
      path: '/v2/entities/LivingRoomSensor',
      method: 'GET',
      headers:{
        "Fiware-Service": "howtoService",
        "Fiware-ServicePath": "/howto"
      } 	   
   };

   var callback = function(response) {
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
 
function setConfig(commands) {
    config.host = commands[0];
    config.port = commands[1];
    config.apikey = commands[2];
    config.deviceId = commands[3];
}

function getConfig(commands) {
    console.log('\nCurrent configuration:\n\n');
    console.log(JSON.stringify(config, null, 4));
    console.log('\n');
}

function mqttPublishHandler(error) {
    if (error) {
        console.log('There was an error publishing to the MQTT broker: %s', error);
    } else {
        console.log('Message successfully published');
    }
}

function checkConnection(fn) {
    return function(commands) {
        if (mqttClient) {
            fn(commands);
        } else {
            console.log('Please, check your configuration and connect before using MQTT commands.');
        }
    }
}

function singleMeasure(commands) {
    var topic = '/' + config.apikey + '/' + config.deviceId + '/attrs/' + commands[0];

    mqttClient.publish(topic, commands[1], null, mqttPublishHandler);
}

function parseMultipleAttributes(attributeString) {
    var result,
        attributes,
        attribute;

    if (!attributeString) {
        result = null;
    } else {
        attributes = attributeString.split(';');
        result = {};

        for (var i = 0; i < attributes.length; i++) {
            attribute = attributes[i].split('=');
            result[attribute[0]] = attribute[1];
        }
    }

    return result;
}

function multipleMeasure(commands) {
    var values = parseMultipleAttributes(commands[0]),
        topic = '/' + config.apikey + '/' + config.deviceId + '/attrs';

    mqttClient.publish(topic, JSON.stringify(values), null, mqttPublishHandler);
}

function connect(commands) {
    console.log('\nConnecting to MQTT Broker...');

    mqttClient = mqtt.connect('mqtt://' + config.host, defaultConfig.mqtt.options);
}

function exitClient() {
    process.exit(0);
}

var commands = {
    'config': {
        parameters: ['host', 'port', 'apiKey', 'deviceId'],
        description: '\tConfigure the client to emulate the selected device, connecting to the given host.',
        handler: setConfig
    },
    'showConfig': {
        parameters: [],
        description: '\tConfigure the client to emulate the selected device, connecting to the given host.',
        handler: getConfig
    },
    'connect': {
        parameters: [],
        description: '\tConnect to the MQTT broker.',
        handler: connect
    },
    'singleMeasure': {
        parameters: ['attribute', 'value'],
        description: '\tSend the given value for the selected attribute to the MQTT broker.',
        handler: checkConnection(singleMeasure)
    },
    'multipleMeasure': {
        parameters: ['attributes'],
        description: '\tSend a collection of attributes to the MQTT broker, using JSON format. The "attributes"\n' +
            '\tstring should have the following syntax: name=value[;name=value]*',
        handler: checkConnection(multipleMeasure)
    },
    'exit': {
        parameters: [],
        description: '\tExit the client',
        handler: exitClient
    }
};

