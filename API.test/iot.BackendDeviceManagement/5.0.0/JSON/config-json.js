var config = {};

config.mqtt = {
    host: 'localhost',
    port: 1883,
    defaultKey: '1234',
    thinkingThingsPlugin: true
};

config.http = {
    port: 7896
};

config.amqp = {
    port: 5672,
    exchange: 'amq.topic',
    queue: 'iota_queue',
    options: {durable: true}
};

config.iota = {
    logLevel: 'DEBUG',
    contextBroker: {
        host: 'orion',
        port: '1026'
    },
    server: {
        port: 4041
    },
    deviceRegistry: {
        type: 'memory'
    },
    types: {},
    service: 'service',
    subservice: '/path',
    providerUrl: 'http://localhost:4041',
    deviceRegistrationDuration: 'P1M',
    defaultType: 'Thing',
    defaultResource: '',
    defaultKey: '1234',
    compressTimestamp: true
};

config.defaultTransport = 'MQTT';

module.exports = config;
