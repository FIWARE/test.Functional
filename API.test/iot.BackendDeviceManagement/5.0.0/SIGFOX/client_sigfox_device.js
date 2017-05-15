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
showParameters();

/*
 * Step 3 - send data 
 */
var data = "000000020000000000230c6f";
sendMeasure(data);    

var waitTime = 5; //wait time X secs after the connection
setTimeout(function() {
      checkDataContextBroker();
},	waitTime * 1000);	    

function checkDataContextBroker(){
   var http = require("http");

   var options = {
      host: 'orion',
      port: 1026,
      path: '/v2/entities/sigApp2/attrs/lng',
      method: 'GET',
      headers:{
        "Fiware-Service": "service",
        "Fiware-ServicePath": "/path"
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

function showParameters() {
    console.log('\nCurrent measure parameters:\n\n');
    console.log('-------------------------------------------------------')
    console.log(JSON.stringify(parameters, null, 4));
    console.log('\n');
    //clUtils.prompt();
}

function sendMeasure(commands) {
    var dataOpts = {
        url: 'http://localhost:' + config.sigfox.port + '/update',
        method: 'GET',
        qs: parameters
    };

    dataOpts.qs.data = commands[0];

    request(dataOpts, function (error, response, body) {
        if (error) {
            console.log('\nError sending data to the Sigfox IoT Agent: ' + error);
        } else {
            console.log('\nData successfully sent');
        }

        //clUtils.prompt();
    });
}

function setParameters(commands) {
    console.log('\nValue for parameter [%s] set to [%s]', commands[0], commands[1]);
    parameters[commands[0]] = commands[1];
    //clUtils.prompt();
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

//clUtils.initialize(commands, 'SIGFOX Test> ');

