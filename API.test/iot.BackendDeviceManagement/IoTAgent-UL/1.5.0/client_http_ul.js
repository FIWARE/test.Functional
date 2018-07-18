
'use strict';

var fs = require('fs'),
    defaultConfig = require('../client-config.js'),
    mqtt = require('mqtt'),
    request = require('request'),
    async = require('async'),
    _ = require('underscore'),
    mqttClient,
    config = {
        binding: defaultConfig.defaultBinding,
        host: defaultConfig.mqtt.host,
        port: defaultConfig.mqtt.port,
        httpPort: defaultConfig.http.port,
        apikey: defaultConfig.device.apikey,
        deviceId: defaultConfig.device.id,
        httpPath: defaultConfig.http.path
    },
    separator = '\n\n\t',
    token;

/*
 * Step 1 - selectProtocol - HTTP
 */
var protocol = ['HTTP'];
selectProtocol(protocol);      
       
/*
 * Step 2 - showConfig
 */
var command = [];
getConfig(command);  
    
/*
 * Step 3 - singleMeasure  -  [/1234/myDeviceId/attrs, a|33]
 */
var a = Math.floor((Math.random() * 100));
var param = 'a|' + a; 
console.log('Send to orion singleMeasure: a=' + a);    
command = ['/1234/myDeviceId/attrs', param];    
singleMeasure(command); 

/*
 * Step 4 - multipleMeasure  -  [a=33;b=22]
 */
setTimeout(function() { 
   var a = Math.floor((Math.random() * 100)); 
   var b = Math.floor((Math.random() * 100)); 
   command = ['a='+a+';b='+b];  
   console.log('Send to orion multipleMeasure: a=' + a + ', b=' +b);   
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
      path: '/v2/entities/MQTT_Device',
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
    config.httpPath = commands[4];
    config.httpPort = commands[5];
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

function httpPublishHandler(error, response, body) {
    if (error) {
        console.log('There was an error publishing an HTTP measure: %s', error);
    } else if (response.statusCode !== 200 && response.statusCode !== 201) {
        console.log('Unexpected status [%s] sending HTTP measure: %s', response.statusCode, body);
    } else {
        console.log('HTTP measure accepted');
    }
}

function checkConnection(fn) {
    return function(commands) {
        if (mqttClient || config.binding === 'HTTP') {
            fn(commands);
        } else {
            console.log('Please, check your configuration and connect before using MQTT commands.');
        }
    }
}

function singleMeasure(commands) {
    if (config.binding === 'MQTT') {
        var topic = '/' + config.apikey + '/' + config.deviceId + '/attrs/' + commands[0];
	    
        mqttClient.publish(topic, commands[1], null, mqttPublishHandler);
    } else {
        var httpRequest = {
            url: 'http://' + config.host + ':' + config.httpPort + config.httpPath,
            method: 'GET',
            qs: {
                i: config.deviceId,
                k: config.apikey,
                d: commands[0] + '|' + commands[1]
            }
        };

        request(httpRequest, httpPublishHandler);
    }
}

function sendCommandResult(commands) {
    var topic = '/' + config.apikey + '/' + config.deviceId + '/cmdexe',
        payload = config.deviceId + '@' + commands[0] + '|' + commands[1];

    mqttClient.publish(topic, payload, null, mqttPublishHandler);
}

function parseMultipleAttributes(attributeString) {
    var result,
        attributes,
        attribute;

    if (!attributeString) {
        result = null;
    } else {
        attributes = attributeString.split(';');
        result = '';

        for (var i = 0; i < attributes.length; i++) {
            attribute = attributes[i].split('=');
            result += attribute[0] + '|' + attribute[1];

            if (i !== attributes.length -1) {
                result += '|';
            }
        }
    }

    return result;
}

function multipleMeasure(commands) {
    var values = parseMultipleAttributes(commands[0]),
        topic = '/' + config.apikey + '/' + config.deviceId + '/attrs';

    if (config.binding === 'MQTT') {
        mqttClient.publish(topic, values, null, mqttPublishHandler);
    } else {
        var httpRequest = {
            url: 'http://' + config.host + ':' + config.httpPort + config.httpPath,
            method: 'GET',
            qs: {
                i: config.deviceId,
                k: config.apikey,
                d: values
            }
        };

        request(httpRequest, httpPublishHandler);
    }
}

function connect(commands) {
    console.log('\nConnecting to MQTT Broker...');
    mqttClient = mqtt.connect('mqtt://' + config.host, defaultConfig.mqtt.options);
}

function selectProtocol(commands) {
    var allowedProtocols = ['HTTP', 'MQTT'];

    if (allowedProtocols.indexOf(commands[0]) >= 0) {
        config.binding = commands[0];
    } else {
        console.log('\nTried to select wrong protocol [%s]. Allowed values are: MQTT and HTTP.');
    }
}

function exitClient() {
    process.exit(0);
}

var commands = {
    'config': {
        parameters: ['host', 'port', 'apiKey', 'deviceId', 'httpPath', 'httpPort'],
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
    'mqttCommand': {
        parameters: ['command', 'result'],
        description: '\tSend the result of a command to the MQTT Broker.',
        handler: checkConnection(sendCommandResult)
    },
    'selectProtocol': {
        parameters: ['newProtocol'],
        description: '\tSelects which transport protocol to use when sending measures to the target system (HTTP or MQTT).',
        handler: selectProtocol
    }
};

