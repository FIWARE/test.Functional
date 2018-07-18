
'use strict';

var clUtils = require('command-node'),
    request = require('request'),
    config = require('../config'),
    parameters = {
        id: '8405',
        time: '1430908992',
        statin: '0817',
        lng: -4,
        lat: 41
    };
    
/*
 * Step 1 - showParameters
 */    
showParameters()

/*
 * Step 2 - setParameters 
 */ 
var lng = Math.floor((Math.random() * 100) + 1);    
var command = ["lng", lng];    
setParameters(command);
//display new parameters
//showParameters();

/*
 * Step 3 - prepare data mapping in exadecimal format
 */    
//here the mapping: theCounter::uint:32  theParam1::uint:32 param2::uint:8 tempDegreesCelsius::uint:8  voltage::uint:16      
var theCounter = "00000002";
var theParam1 = "00000000";
var param2 = "00";
var tmp = Math.floor((Math.random() * 255) + 1);
var tempDegreesCelsius = dec2hex(tmp, 2); //"23";
var volt = Math.floor((Math.random() * 65535) + 1);
var voltage = dec2hex(volt, 4);//"0c6f";

console.log('\nPreparing params list (in exadecimal format) \n--------------------------------'); 
console.log('theCounter: ' + theCounter + ' -> decimal = 2');
console.log('theParam1: ' + theParam1 + ' -> decimal = 0');
console.log('param2: ' + param2 + ' -> decimal = 0');
console.log('tempDegreesCelsius: ' + tempDegreesCelsius + ' -> decimal = ' + tmp);
console.log('voltage: ' + voltage + ' -> decimal = ' + volt);

/*
 * Step 4 - send data 
 */
console.log('\nData compound = ' + theCounter + ' + ' + theParam1 + ' + ' + param2 + ' + '+ tempDegreesCelsius + ' + ' + voltage );
var data = theCounter + theParam1 + param2 + tempDegreesCelsius + voltage;
console.log('Sending hex data = '+data+' according to attribute mapping: theCounter[8] + theParam1[8] + param2[2] + tempDegreesCelsius[2] + voltage[4]');
sendMeasure(data);    

/*
 * Step 4 - checkDataContextBroker & exit
 */
var waitTime = 5; //wait time X secs after the connection
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
   console.log('\nRead newer attributes from orion\n--------------------------------\n');
   var options = {
      host: 'orion',
      port: 1026,
      path: '/v2/entities/sigApp2',
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

function dec2hex(i, dim) {
   return (i+0x10000).toString(16).substr(-dim).toUpperCase();
}

function showParameters() {
    console.log('\nCurrent measure parameters:\n');
    console.log('-------------------------------------------------------')
    console.log(JSON.stringify(parameters, null, 4));
    console.log('\n');
}

function sendMeasure(data) {
    var dataOpts = {
        url: 'http://localhost:' + config.sigfox.port + '/update',
        method: 'GET',
        qs: parameters
    };
    
    dataOpts.qs.data = data;

    request(dataOpts, function (error, response, body) {
        if (error) {
            console.log('\nError sending data to the Sigfox IoT Agent: ' + error);
        } else {
            console.log('\nData successfully sent');
        }
    });
}

function setParameters(commands) {
    console.log('Update value for parameter [%s] set to [%s]', commands[0], commands[1]);
    parameters[commands[0]] = commands[1];
}

var commands = {
    'showParameters': {
        parameters: [],
        description: '\tShow the current device parameters that will be sent along with the callback',
        handler: showParameters
    },
    'setParameters': {
        parameters: ['name', 'value'],
        description: '\tSet the value for the selected parameter',
        handler: setParameters
    },
    'sendMeasure': {
        parameters: ['data'],
        description: '\tSend a measure to the defined endpoint, with the defined parameters and the data passed to ' +
            'the command',
        handler: sendMeasure
    }
};


