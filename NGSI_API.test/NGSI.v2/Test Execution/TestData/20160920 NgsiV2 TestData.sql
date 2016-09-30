-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Mar 20 Septembre 2016 à 14:22
-- Version du serveur: 5.5.47-0ubuntu0.14.04.1
-- Version de PHP: 5.5.9-1ubuntu4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `NgsiV2Tests`
--

-- --------------------------------------------------------

--
-- Structure de la table `attributes`
--

CREATE TABLE IF NOT EXISTS `attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attributename` varchar(255) NOT NULL,
  `attributepayloadtype` varchar(255) NOT NULL,
  `attributepayloadstring` mediumtext NOT NULL,
  `attributedatapayloadstring` mediumtext NOT NULL,
  `attributevaluetype` varchar(255) NOT NULL,
  `attributevaluepayloadstring` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=33 ;

--
-- Contenu de la table `attributes`
--

INSERT INTO `attributes` (`id`, `attributename`, `attributepayloadtype`, `attributepayloadstring`, `attributedatapayloadstring`, `attributevaluetype`, `attributevaluepayloadstring`) VALUES
(1, 'ATTR1', 'JSON', ' {\n  "ATTR1": {\n           "type": "boolean",\n           "value": "true"\n           }\n}', '{\n           "type": "boolean",\n           "value": "true"\n           }', 'NOT_JSON', 'true'),
(2, 'ATTR2', 'JSON', ' {\n  "ATTR2": {\n           "type": "String",\n           "value": "anyString"\n           }\n}', '{\n           "type": "String",\n           "value": "anyString"\n           }', 'NOT_JSON', '"anyString"'),
(3, 'ID', 'JSON', ' {\n  "id": {\n           "type": "Number",\n           "value": "1225"\n           }\n}', '{\n           "type": "Number",\n           "value": "1225"\n           }', 'NOT_JSON', '1225'),
(5, 'ANY', 'EMPTY', '', '', 'EMPTY', ''),
(6, 'ANY', 'JSON_ERROR', ' {\n  "any": {\n           "type": "String",,\n           "value": "ngsiType"\n           }\n}', '{\n           "type": "String",,\n           "value": "ngsiType"\n           }', 'INVALID', 'ngsiType'),
(8, 'ATTR3', 'JSON', ' {\n  "ATTR3": {\n           "type": "Number",\n           "value": "2525"\n           }\n}', '{\n           "type": "Number",\n           "value": "2525"\n           }', 'NOT_JSON', '2525'),
(9, 'ATTR4', 'JSON', ' {\r\n  "ATTR4": {\r\n           "type": "String",\r\n           "value": ""\r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value": ""\r\n           }', 'NOT_JSON', 'null'),
(10, 'ATTR5', 'JSON', ' {\n  "ATTR5": {\n           "type": "String",\n           "value": "any"\n           }\n}', '{\r\n           "type": "String",\r\n           "value": "any"\r\n           }', 'NOT_JSON', '"any"'),
(11, 'ATTR1', 'JSON', ' {\n  "ATTR1": {\n           "type": "boolean",\n          "value":{\n "attrValueName": "temperature",\n  "value": "25"\n}\n           }\n}', '{\n           "type": "boolean",\n           "value": {\n "attrValueName": "temperature",\n  "value": "25"\n}\n           }', 'JSON', '{\n "attrValueName": "temperature",\n  "value": "25"\n}'),
(12, 'ATTR2', 'JSON', ' {\n  "ATTR2": {\n           "type": "String",\n           "value":{\n           "attrValueName": "humidity",\n           "value": "80"\n           }\n           }\n}', '{\r\n           "type": "String",\r\n           "value": {\r\n           "attrValueName": "humidity",\r\n           "value": "80"\r\n           }\r\n           }', 'JSON', '{\r\n           "attrValueName": "humidity",\r\n           "value": "80"\r\n           }'),
(13, 'ATTR3', 'JSON', ' {\n  "ATTR3": {\n           "type": "Number",\n           "value": {\n           "attrValueName": "tempAverage",\n           "value": "25.25"\n           }\n           }\n}', '{\n           "type": "Number",\n           "value": {\n           "attrValueName": "tempAverage",\n           "value": "25.25"\n           }\n           }', 'JSON', '{\r\n           "attrValueName": "tempAverage",\r\n           "value": "25.25"\r\n           }'),
(14, 'ATTR4', 'JSON', ' {\n  "ATTR4": {\n           "type": "String",\n           "value": {\n           "attrValueName": "AvgHumidity",\n           "value": "60"\n           }\n           }\n}', '{\n           "type": "String",\n           "value":{\n           "attrValueName": "AvgHumidity",\n           "value": "60"\n           }\n           }', 'JSON', '{\r\n           "attrValueName": "AvgHumidity",\r\n           "value": "60"\r\n           }'),
(15, 'ATTR5', 'JSON', ' {\n  "ATTR5": {\n           "type": "String",\n           "value": {\n           "attrValueName": "powerConsumption",\n           "value": "2500"\n           }\n           }\n}', '{\r\n           "type": "String",\r\n           "value":{\r\n           "attrValueName": "powerConsumption",\r\n           "value": "2500"\r\n           }\r\n           }', 'JSON', '{\r\n           "attrValueName": "powerConsumption",\r\n           "value": "2500"\r\n           }'),
(16, 'TYPE', 'JSON', ' {\n  "type": {\n           "type": "String",\n           "value": "ngsiType"\n           }\n}', '{\r\n           "type": "String",\r\n           "value":"ngsiType"\r\n           }', 'NOT_JSON', '"ngsiType"'),
(17, 'TYPE', 'JSON', ' {\n  "type": {\n           "type": "String",\n           "value":{\n           "attrValueName": "ngsiType",\n           "value":"ngsiEntityn"\n           }\n           }\n}', '{\r\n           "type": "String",\r\n           "value":{\r\n           "attrValueName": "ngsiType",\r\n           "value":"ngsiEntityn"\r\n           }\r\n           }', 'JSON', '{\n           "attrValueName": "ngsiType",\n           "value":"ngsiEntityn"\n           }'),
(18, 'ID', 'JSON', ' {\n  "id": {\n           "type": "Number",\n           "value":{\n           "attrValueName": "id",\n           "value": "1225"\n           }\n           }\n}', '{\r\n           "type": "Number",\r\n           "value":{\r\n           "attrValueName": "id",\r\n           "value": "1225"\r\n           }\r\n           }', 'JSON', '{\n           "attrValueName": "id",\n           "value": "1225"\n           }'),
(19, 'ATTR1', 'JSON', ' {\r\n  "ATTR1": {\r\n           "type": "boolean",\r\n          "value":\r\n           }\r\n}', '{\r\n           "type": "boolean",\r\n           "value": \r\n           }', 'EMPTY', ''),
(20, 'ATTR1', 'JSON', ' {\r\n  "ATTR1": {\r\n           "type": "boolean",\r\n          "value":invalid\r\n           }\r\n}', '{\r\n           "type": "boolean",\r\n           "value": invalid\r\n}', 'INVALID', 'invalid'),
(21, 'ATTR2', 'JSON', ' {\r\n  "ATTR2": {\r\n           "type": "String",\r\n           "value":\r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value": \r\n           }', 'EMPTY', ''),
(22, 'ATTR2', 'JSON', ' {\r\n  "ATTR2": {\r\n           "type": "String",\r\n           "value":invalid\r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value": invalid\r\n           }', 'INVALID', 'invalid'),
(23, 'ATTR3', 'JSON', ' {\r\n  "ATTR3": {\r\n           "type": "Number",\r\n           "value": \r\n           }\r\n}', '{\r\n           "type": "Number",\r\n           "value": \r\n           }', 'EMPTY', ''),
(24, 'ATTR3', 'JSON', ' {\r\n  "ATTR3": {\r\n           "type": "Number",\r\n           "value": invalid\r\n           }\r\n}', '{\r\n           "type": "Number",\r\n           "value": invalid\r\n           }', 'INVALID', 'invalid'),
(25, 'ATTR4', 'JSON', ' {\r\n  "ATTR4": {\r\n           "type": "String",\r\n           "value": \r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value": \r\n           }', 'EMPTY', ''),
(26, 'ATTR4', 'JSON', ' {\r\n  "ATTR4": {\r\n           "type": "String",\r\n           "value": invalid\r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value": invalid\r\n           }', 'INVALID', 'invalid'),
(27, 'TYPE', 'JSON', ' {\r\n  "type": {\r\n           "type": "String",\r\n           "value": \r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value":\r\n           }', 'EMPTY', ''),
(28, 'TYPE', 'JSON', ' {\r\n  "type": {\r\n           "type": "String",\r\n           "value": invalid\r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value": invalid\r\n           }', 'INVALID', 'invalid'),
(29, 'ID', 'JSON', ' {\r\n  "id": {\r\n           "type": "Number",\r\n           "value":\r\n           }\r\n}', '{\r\n           "type": "Number",\r\n           "value":\r\n}', 'EMPTY', ''),
(30, 'ID', 'JSON', ' {\r\n  "id": {\r\n           "type": "Number",\r\n           "value": invalid\r\n           }\r\n}', '{\r\n           "type": "Number",\r\n           "value": invalid\r\n}', 'INVALID', 'invalid'),
(31, 'ATTR5', 'JSON', ' {\r\n  "ATTR5": {\r\n           "type": "String",\r\n           "value": \r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value":\r\n           }', 'EMPTY', ''),
(32, 'ATTR5', 'JSON', ' {\r\n  "ATTR5": {\r\n           "type": "String",\r\n           "value": invalid\r\n           }\r\n}', '{\r\n           "type": "String",\r\n           "value": invalid\r\n           }', 'INVALID', 'invalid');

-- --------------------------------------------------------

--
-- Structure de la table `batchspayload`
--

CREATE TABLE IF NOT EXISTS `batchspayload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opname` varchar(255) NOT NULL,
  `payloadtype` varchar(255) NOT NULL,
  `entityid` varchar(255) NOT NULL,
  `entitytype` varchar(255) NOT NULL,
  `attributename` varchar(255) NOT NULL,
  `payloadstring` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=29 ;

--
-- Contenu de la table `batchspayload`
--

INSERT INTO `batchspayload` (`id`, `opname`, `payloadtype`, `entityid`, `entitytype`, `attributename`, `payloadstring`) VALUES
(1, 'batchQueryById', 'JSON', 'ENTITY_ID_1', '', '', '{\n  "entities": [\n    {      \n      "id": "ENTITY_ID_1"\n    }\n  ]\n}'),
(2, 'batchQueryById', 'JSON', 'ENTITY_ID_2', '', '', '{\n  "entities": [\n    {      \n      "id": "ENTITY_ID_2"\n    }\n  ]\n}'),
(3, 'batchQueryById', 'JSON', 'ENTITY_ID_3', '', '', '{\r\n  "entities": [\r\n    {      \r\n      "id": "ENTITY_ID_3"\r\n    }\r\n  ]\r\n}'),
(4, 'batchQueryById', 'JSON', 'ENTITY_ID_4', '', '', '{\r\n  "entities": [\r\n    {      \r\n      "id": "ENTITY_ID_4"\r\n    }\r\n  ]\r\n}'),
(5, 'batchQueryById', 'JSON', 'ENTITY_ID_5', '', '', '{\r\n  "entities": [\r\n    {      \r\n      "id": "ENTITY_ID_5"\r\n    }\r\n  ]\r\n}'),
(6, 'batchQueryById', 'JSON', 'ENTITY_ID_6', '', '', '{\r\n  "entities": [\r\n    {      \r\n      "id": "ENTITY_ID_6"\r\n    }\r\n  ]\r\n}'),
(7, 'batchQueryById', 'JSON', 'ENTITY_ID_7', '', '', '{\n  "entities": [\n    {      \n      "id": "ENTITY_ID_7"\n    }\n  ]\n}'),
(8, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_1', 'ENTITY_TYPE1', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_1",  \r\n      "type": "ENTITY_TYPE1"\r\n    }\r\n  ]\r\n}'),
(9, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_1', 'ENTITY_TYPE2', '', '{\r\n  "entities": [\r\n    {      \r\n      "id": "ENTITY_ID_1",\r\n      "type": "ENTITY_TYPE2"\r\n    }\r\n  ]\r\n}'),
(10, 'batchQueryByAttribute', 'JSON', '', '', 'ATTR1', '{  \r\n  "attributes": [\r\n    "ATTR1"\r\n  ]\r\n}'),
(11, 'batchQueryByAttribute', 'JSON', '', '', 'ATTR2', '{  \r\n  "attributes": [\r\n    "ATTR2"\r\n  ]\r\n}'),
(12, 'batchQueryByAttribute', 'JSON', '', '', 'ATTR3', '{  \r\n  "attributes": [\r\n    "ATTR3"\r\n  ]\r\n}'),
(13, 'batchQueryByAttribute', 'JSON', '', '', 'ATTR4', '{  \r\n  "attributes": [\r\n    "ATTR4"\r\n  ]\r\n}'),
(14, 'batchQueryByAttribute', 'JSON', '', '', 'ATTR5', '{  \r\n  "attributes": [\r\n    "ATTR5"\r\n  ]\r\n}'),
(15, 'ANY', 'JSON_ERROR', 'ANY', 'ANY', 'ANY', '{  \r\n  "attributes": [\r\n    "ATTR5",,\r\n  ]\r\n}'),
(16, 'ANY', 'EMPTY', 'ANY', 'ANY', 'ANY', ''),
(17, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_2', 'ENTITY_TYPE1', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_2",  \r\n      "type": "ENTITY_TYPE1"\r\n    }\r\n  ]\r\n}'),
(18, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_2', 'ENTITY_TYPE2', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_2",  \r\n      "type": "ENTITY_TYPE2"\r\n    }\r\n  ]\r\n}'),
(19, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_3', 'ENTITY_TYPE1', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_3",  \r\n      "type": "ENTITY_TYPE1"\r\n    }\r\n  ]\r\n}'),
(20, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_3', 'ENTITY_TYPE2', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_3",  \r\n      "type": "ENTITY_TYPE2"\r\n    }\r\n  ]\r\n}'),
(21, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_4', 'ENTITY_TYPE1', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_4",  \r\n      "type": "ENTITY_TYPE1"\r\n    }\r\n  ]\r\n}'),
(22, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_4', 'ENTITY_TYPE2', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_4",  \r\n      "type": "ENTITY_TYPE2"\r\n    }\r\n  ]\r\n}'),
(23, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_5', 'ENTITY_TYPE1', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_5",  \r\n      "type": "ENTITY_TYPE1"\r\n    }\r\n  ]\r\n}'),
(24, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_5', 'ENTITY_TYPE2', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_5",  \r\n      "type": "ENTITY_TYPE2"\r\n    }\r\n  ]\r\n}'),
(25, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_6', 'ENTITY_TYPE1', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_6",  \r\n      "type": "ENTITY_TYPE1"\r\n    }\r\n  ]\r\n}'),
(26, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_6', 'ENTITY_TYPE2', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_6",  \r\n      "type": "ENTITY_TYPE2"\r\n    }\r\n  ]\r\n}'),
(27, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_7', 'ENTITY_TYPE1', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_7",  \r\n      "type": "ENTITY_TYPE1"\r\n    }\r\n  ]\r\n}'),
(28, 'batchQueryByIdAndType', 'JSON', 'ENTITY_ID_7', 'ENTITY_TYPE2', '', '{\r\n  "entities": [\r\n    {    \r\n      "id": "ENTITY_ID_7",  \r\n      "type": "ENTITY_TYPE2"\r\n    }\r\n  ]\r\n}');

-- --------------------------------------------------------

--
-- Structure de la table `headers`
--

CREATE TABLE IF NOT EXISTS `headers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `headerspayload` varchar(255) NOT NULL,
  `headerspayloadvalue` varchar(255) NOT NULL,
  `headersresponse` varchar(255) NOT NULL,
  `headersresponsevalue` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Contenu de la table `headers`
--

INSERT INTO `headers` (`id`, `headerspayload`, `headerspayloadvalue`, `headersresponse`, `headersresponsevalue`) VALUES
(1, 'CONTENT_TYPE_JSON_HEADER', '{Content-Type = application/json}', 'ACCEPT_JSON_HEADER', '{Accept = application/json}'),
(2, 'CONTENT_TYPE_ERROR_HEADER', '{Content-Type=application/xml}', 'ACCEPT_ERROR_HEADER', '{Accept=application/xml}'),
(3, 'CONTENT_TYPE_TEXT_HEADER', '{Content-Type = text/plain}', 'ACCEPT_TEXT_HEADER', '{Accept = text/plain}');

-- --------------------------------------------------------

--
-- Structure de la table `payloads`
--

CREATE TABLE IF NOT EXISTS `payloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opname` varchar(255) NOT NULL,
  `entityid` varchar(255) NOT NULL,
  `entitytype` varchar(255) NOT NULL,
  `payloadtype` varchar(255) NOT NULL,
  `payloadstring` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=93 ;

--
-- Contenu de la table `payloads`
--

INSERT INTO `payloads` (`id`, `opname`, `entityid`, `entitytype`, `payloadtype`, `payloadstring`) VALUES
(1, 'ALL_OPS', 'ANY', 'ANY', 'EMPTY', ''),
(4, 'createEntity', 'ENTITY_ID_2', 'ENTITY_TYPE1', 'JSON', '{\n"id": "ENTITY_ID_2",\n"type": "ENTITY_TYPE1"\n}'),
(5, 'ALL_OPS', 'ANY', 'ANY', 'JSON_ERROR', '        {\n            "id": "any"\n            "type": "any",\n            \n            "ATTR1": \n            {\n               \n                "type": "float",\n                "value": "23"\n            }\n            \n        }'),
(7, 'createEntity', 'ENTITY_ID_5', 'ENTITY_TYPE2', 'JSON', '{\n "id": "ENTITY_ID_5",\n "type": "ENTITY_TYPE2"\n}'),
(8, 'createEntity', 'ENTITY_ID_5', 'ENTITY_TYPE1', 'JSON', '        {\n            "id": "ENTITY_ID_5",\n            "type": "ENTITY_TYPE1"            \n            \n        }'),
(9, 'createEntity', 'ENTITY_ID_6', 'ENTITY_TYPE1', 'JSON', '        {\r\n            "id": "ENTITY_ID_6",\r\n            "type": "ENTITY_TYPE1"            \r\n            \r\n        }'),
(10, 'createEntity', 'ENTITY_ID_7', 'ENTITY_TYPE1', 'JSON', '        {\r\n            "id": "ENTITY_ID_7",\r\n            "type": "ENTITY_TYPE1"            \r\n            \r\n        }'),
(11, 'createEntity', 'ENTITY_ID_4', 'ENTITY_TYPE1', 'JSON', '        {\r\n            "id": "ENTITY_ID_4",\r\n            "type": "ENTITY_TYPE1"            \r\n            \r\n        }'),
(12, 'batchAppend', 'ENTITY_ID_2', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(13, 'batchAppend', 'ENTITY_ID_5', 'ENTITY_TYPE2', 'JSON', '{\n  "actionType": "APPEND",\n  "entities": [\n   {\n 		"id": "ENTITY_ID_5",\n		"type": "ENTITY_TYPE2"\n	}\n  ]\n}'),
(14, 'batchAppend', 'ENTITY_ID_5', 'ENTITY_TYPE1', 'JSON', '{\n  "actionType": "APPEND",\n  "entities": [\n   {\n        "id": "ENTITY_ID_5",\n       "type": "ENTITY_TYPE1"                      \n   }\n  ]\n}        '),
(15, 'batchAppend', 'ENTITY_ID_6', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}'),
(16, 'batchAppend', 'ENTITY_ID_7', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}        '),
(17, 'batchAppend', 'ENTITY_ID_4', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE1"                        \r\n        }\r\n  ]\r\n}        '),
(18, 'batchDelete', 'ENTITY_ID_2', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(19, 'batchDelete', 'ENTITY_ID_5', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n 		"id": "ENTITY_ID_5",\r\n		"type": "ENTITY_TYPE2"\r\n	}\r\n  ]\r\n}'),
(20, 'batchDelete', 'ENTITY_ID_6', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}'),
(21, 'batchDelete', 'ENTITY_ID_7', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}        '),
(22, 'batchDelete', 'ENTITY_ID_4', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE1"                        \r\n        }\r\n  ]\r\n}        '),
(23, 'batchDelete', 'ENTITY_ID_5', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_5",\r\n       "type": "ENTITY_TYPE1"                      \r\n   }\r\n  ]\r\n}        '),
(24, 'batchStrictAppend', 'ENTITY_ID_2', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(25, 'batchStrictAppend', 'ENTITY_ID_5', 'ENTITY_TYPE2', 'JSON', '{\n  "actionType": "APPEND_STRICT",\n  "entities": [\n   {\n 		"id": "ENTITY_ID_5",\n		"type": "ENTITY_TYPE2"\n	}\n  ]\n}'),
(26, 'batchStrictAppend', 'ENTITY_ID_6', 'ENTITY_TYPE1', 'JSON', '{\n  "actionType": "APPEND_STRICT",\n  "entities": [\n   {\n        "id": "ENTITY_ID_6",\n        "type": "ENTITY_TYPE1"                        \n    }\n  ]\n}'),
(27, 'batchStrictAppend', 'ENTITY_ID_7', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}        '),
(28, 'batchStrictAppend', 'ENTITY_ID_4', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE1"                        \r\n        }\r\n  ]\r\n}        '),
(29, 'batchStrictAppend', 'ENTITY_ID_5', 'ENTITY_TYPE1', 'JSON', '{\n  "actionType": "APPEND_STRICT",\n  "entities": [\n   {\n        "id": "ENTITY_ID_5",\n       "type": "ENTITY_TYPE1"                      \n   }\n  ]\n}        '),
(30, 'batchUpdate', 'ENTITY_ID_2', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(31, 'batchUpdate', 'ENTITY_ID_5', 'ENTITY_TYPE2', 'JSON', '{\n  "actionType": "UPDATE",\n  "entities": [\n   {\n 		"id": "ENTITY_ID_5",\n		"type": "ENTITY_TYPE2"\n	}\n  ]\n}'),
(32, 'batchUpdate', 'ENTITY_ID_6', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}'),
(33, 'batchUpdate', 'ENTITY_ID_7', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}        '),
(34, 'batchUpdate', 'ENTITY_ID_4', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE1"                        \r\n        }\r\n  ]\r\n}        '),
(36, 'batchUpdate', 'ENTITY_ID_5', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_5",\r\n       "type": "ENTITY_TYPE1"                      \r\n   }\r\n  ]\r\n}        '),
(39, 'batchUpdateUsingAppend', 'ENTITY_ID_2', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(40, 'batchUpdateUsingAppend', 'ENTITY_ID_5', 'ENTITY_TYPE2', 'JSON', '{\n  "actionType": "APPEND",\n  "entities": [\n   {\n 		"id": "ENTITY_ID_5",\n		"type": "ENTITY_TYPE2"\n	}\n  ]\n}'),
(41, 'batchUpdateUsingAppend', 'ENTITY_ID_6', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}'),
(42, 'batchUpdateUsingAppend', 'ENTITY_ID_7', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE1"                        \r\n    }\r\n  ]\r\n}        '),
(43, 'batchUpdateUsingAppend', 'ENTITY_ID_4', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE1"                        \r\n        }\r\n  ]\r\n}        '),
(44, 'batchUpdateUsingAppend', 'ENTITY_ID_5', 'ENTITY_TYPE1', 'JSON', '{\n  "actionType": "APPEND",\n  "entities": [\n   {\n        "id": "ENTITY_ID_5",\n       "type": "ENTITY_TYPE1"                      \n   }\n  ]\n}        '),
(45, 'batchAppend', 'ENTITY_ID_1', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(46, 'batchDelete', 'ENTITY_ID_1', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(47, 'batchStrictAppend', 'ENTITY_ID_1', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(48, 'batchUpdate', 'ENTITY_ID_1', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(49, 'batchUpdateUsingAppend', 'ENTITY_ID_1', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n 		"id": "ENTITY_ID_1",\r\n		"type": "ENTITY_TYPE1"\r\n	}\r\n  ]\r\n}'),
(50, 'batchAppend', 'ENTITY_ID_3', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(51, 'batchStrictAppend', 'ENTITY_ID_3', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(52, 'createEntity', 'ENTITY_ID_1', 'ENTITY_TYPE1', 'JSON', '{\r\n"id": "ENTITY_ID_1",\r\n"type": "ENTITY_TYPE1"\r\n}'),
(53, 'createEntity', 'ENTITY_ID_1', 'ENTITY_TYPE2', 'JSON', '{\r\n"id": "ENTITY_ID_1",\r\n"type": "ENTITY_TYPE2"\r\n}'),
(54, 'createEntity', 'ENTITY_ID_2', 'ENTITY_TYPE2', 'JSON', '{\r\n"id": "ENTITY_ID_2",\r\n"type": "ENTITY_TYPE2"\r\n}'),
(55, 'createEntity', 'ENTITY_ID_3', 'ENTITY_TYPE1', 'JSON', '{\r\n"id": "ENTITY_ID_3",\r\n"type": "ENTITY_TYPE1"\r\n}'),
(56, 'createEntity', 'ENTITY_ID_3', 'ENTITY_TYPE2', 'JSON', '{\r\n"id": "ENTITY_ID_3",\r\n"type": "ENTITY_TYPE2"\r\n}'),
(57, 'createEntity', 'ENTITY_ID_4', 'ENTITY_TYPE2', 'JSON', '        {\r\n            "id": "ENTITY_ID_4",\r\n            "type": "ENTITY_TYPE2"            \r\n            \r\n        }'),
(58, 'createEntity', 'ENTITY_ID_6', 'ENTITY_TYPE2', 'JSON', '        {\r\n            "id": "ENTITY_ID_6",\r\n            "type": "ENTITY_TYPE2"            \r\n            \r\n        }'),
(59, 'createEntity', 'ENTITY_ID_7', 'ENTITY_TYPE2', 'JSON', '        {\r\n            "id": "ENTITY_ID_7",\r\n            "type": "ENTITY_TYPE2"            \r\n            \r\n        }'),
(60, 'batchAppend', 'ENTITY_ID_1', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(61, 'batchAppend', 'ENTITY_ID_2', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(62, 'batchAppend', 'ENTITY_ID_3', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(63, 'batchAppend', 'ENTITY_ID_4', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE2"                        \r\n        }\r\n  ]\r\n}        '),
(64, 'batchAppend', 'ENTITY_ID_6', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}'),
(65, 'batchAppend', 'ENTITY_ID_7', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}        '),
(66, 'batchStrictAppend', 'ENTITY_ID_1', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(67, 'batchStrictAppend', 'ENTITY_ID_2', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(68, 'batchStrictAppend', 'ENTITY_ID_3', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(69, 'batchStrictAppend', 'ENTITY_ID_4', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE2"                        \r\n        }\r\n  ]\r\n}        '),
(70, 'batchStrictAppend', 'ENTITY_ID_6', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}'),
(71, 'batchStrictAppend', 'ENTITY_ID_7', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND_STRICT",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}        '),
(72, 'batchUpdate', 'ENTITY_ID_1', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(73, 'batchUpdate', 'ENTITY_ID_2', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(74, 'batchUpdate', 'ENTITY_ID_3', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(75, 'batchUpdate', 'ENTITY_ID_3', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(76, 'batchUpdate', 'ENTITY_ID_4', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE2"                        \r\n        }\r\n  ]\r\n}        '),
(77, 'batchUpdate', 'ENTITY_ID_6', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}'),
(78, 'batchUpdate', 'ENTITY_ID_7', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "UPDATE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}        '),
(79, 'batchDelete', 'ENTITY_ID_1', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_1",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(80, 'batchDelete', 'ENTITY_ID_2', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(81, 'batchDelete', 'ENTITY_ID_3', 'ENTITY_TYPE1', 'JSON', '\r\n\r\n{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE1"\r\n   }\r\n  ]\r\n}'),
(82, 'batchDelete', 'ENTITY_ID_3', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_3",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(83, 'batchDelete', 'ENTITY_ID_4', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE2"                        \r\n        }\r\n  ]\r\n}        '),
(84, 'batchDelete', 'ENTITY_ID_6', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}'),
(85, 'batchDelete', 'ENTITY_ID_7', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "DELETE",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}        '),
(86, 'batchUpdateUsingAppend', 'ENTITY_ID_1', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n 		"id": "ENTITY_ID_1",\r\n		"type": "ENTITY_TYPE2"\r\n	}\r\n  ]\r\n}'),
(87, 'batchUpdateUsingAppend', 'ENTITY_ID_2', 'ENTITY_TYPE2', 'JSON', '\r\n\r\n{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n     "id": "ENTITY_ID_2",\r\n     "type": "ENTITY_TYPE2"\r\n   }\r\n  ]\r\n}'),
(88, 'batchUpdateUsingAppend', 'ENTITY_ID_3', 'ENTITY_TYPE1', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n 		"id": "ENTITY_ID_3",\r\n		"type": "ENTITY_TYPE1"\r\n	}\r\n  ]\r\n}'),
(89, 'batchUpdateUsingAppend', 'ENTITY_ID_3', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n 		"id": "ENTITY_ID_3",\r\n		"type": "ENTITY_TYPE2"\r\n	}\r\n  ]\r\n}'),
(90, 'batchUpdateUsingAppend', 'ENTITY_ID_4', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n	{\r\n       "id": "ENTITY_ID_4",\r\n       "type": "ENTITY_TYPE2"                        \r\n        }\r\n  ]\r\n}        '),
(91, 'batchUpdateUsingAppend', 'ENTITY_ID_6', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_6",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}'),
(92, 'batchUpdateUsingAppend', 'ENTITY_ID_7', 'ENTITY_TYPE2', 'JSON', '{\r\n  "actionType": "APPEND",\r\n  "entities": [\r\n   {\r\n        "id": "ENTITY_ID_7",\r\n        "type": "ENTITY_TYPE2"                        \r\n    }\r\n  ]\r\n}        ');

-- --------------------------------------------------------

--
-- Structure de la table `subscriptions`
--

CREATE TABLE IF NOT EXISTS `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opname` varchar(255) NOT NULL,
  `subscriptionid` varchar(255) NOT NULL,
  `payloadtype` varchar(255) NOT NULL,
  `payloadstring` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Contenu de la table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `opname`, `subscriptionid`, `payloadtype`, `payloadstring`) VALUES
(1, 'createSubscription', 'SUBSCRIPTION_1', 'JSON', '{\n  "description": "subscription 1",\n  "subject": {\n    "entities": [\n      {\n        "idPattern": ".*",\n        "type": "Room"\n      }\n    ],\n    "condition": {\n      "attrs": [\n        "temperature"\n      ],\n      "expression": {\n        "q": "temperature>40"\n      }\n    }\n  },\n  "notification": {\n    "http": {\n      "url": "http://localhost:1234"\n    },\n    "attrs": [\n      "temperature",\n      "humidity"\n    ]\n  },\n  "expires": "2016-12-30T14:00:00.00Z",\n  "throttling": 5\n}'),
(2, 'createSubscription', 'SUBSCRIPTION_2', 'JSON', '{\n  "description": "subscription 2",\n  "subject": {\n    "entities": [\n      {\n        "idPattern": ".*",\n        "type": "Room"\n      }\n    ],\n    "condition": {\n      "attrs": [\n        "temperature"\n      ],\n      "expression": {\n        "q": "temperature>40"\n      }\n    }\n  },\n  "notification": {\n    "http": {\n      "url": "http://localhost:1234"\n    },\n    "attrs": [\n      "temperature",\n      "humidity"\n    ]\n  },\n  "expires": "2016-12-30T14:00:00.00Z",\n  "throttling": 5\n}'),
(3, 'createSubscription', 'SUBSCRIPTION_3', 'JSON', '{\r\n  "description": "subscription 3",\r\n  "subject": {\r\n    "entities": [\r\n      {\r\n        "idPattern": ".*",\r\n        "type": "Room"\r\n      }\r\n    ],\r\n    "condition": {\r\n      "attrs": [\r\n        "temperature"\r\n      ],\r\n      "expression": {\r\n        "q": "temperature>40"\r\n      }\r\n    }\r\n  },\r\n  "notification": {\r\n    "http": {\r\n      "url": "http://localhost:1234"\r\n    },\r\n    "attrs": [\r\n      "temperature",\r\n      "humidity"\r\n    ]\r\n  },\r\n  "expires": "2016-12-30T14:00:00.00Z",\r\n  "throttling": 5\r\n}'),
(4, 'createSubscription', 'ANY', 'EMPTY', ''),
(5, 'createSubscription', 'ANY', 'JSON_ERROR', '{\r\n  "description": "subscription 1",\r\n  "subject": {\r\n    "entities": [\r\n      {\r\n        "idPattern": ".*",\r\n        "type": "Room"\r\n      }\r\n    ],\r\n    "condition": {\r\n      "attrs": [\r\n        "temperature"\r\n      ],\r\n      "expression": {\r\n        "q": "temperature>40"\r\n      }\r\n    }\r\n  },\r\n  "notification": {{\r\n    "http": {\r\n      "url": "http://localhost:1234"\r\n    },\r\n    "attrs": [\r\n      "temperature",\r\n      "humidity"\r\n    ]\r\n  },\r\n  "expires": "2016-12-30T14:00:00.00Z",\r\n  "throttling": 5\r\n}'),
(6, 'updateSubscriptionByID', 'SUBSCRIPTION_1', 'JSON', '{\n  "description": "subscription 1 updated",\n  "subject": {\n    "entities": [\n      {\n        "idPattern": ".*",\n        "type": "Room"\n      }\n    ],\n    "condition": {\n      "attrs": [\n        "temperature"\n      ],\n      "expression": {\n        "q": "temperature<10"\n      }\n    }\n  },\n  "notification": {\n    "http": {\n      "url": "http://localhost:1234"\n    },\n    "attrs": [\n      "temperature",\n      "humidity"\n    ]\n  },\n  "expires": "2017-12-30T14:00:00.00Z",\n  "throttling": 5\n}'),
(7, 'updateSubscriptionByID', 'SUBSCRIPTION_2', 'JSON', '{\n  "description": "subscription 2 updated",\n  "subject": {\n    "entities": [\n      {\n        "idPattern": ".*",\n        "type": "Room"\n      }\n    ],\n    "condition": {\n      "attrs": [\n        "temperature"\n      ],\n      "expression": {\n        "q": "temperature<0"\n      }\n    }\n  },\n  "notification": {\n    "http": {\n      "url": "http://localhost:1234"\n    },\n    "attrs": [\n      "temperature",\n      "humidity"\n    ]\n  },\n  "expires": "2018-12-30T14:00:00.00Z",\n  "throttling": 5\n}'),
(8, 'updateSubscriptionByID', 'SUBSCRIPTION_3', 'JSON', '{\n  "description": "subscription 3 updated",\n  "subject": {\n    "entities": [\n      {\n        "idPattern": ".*",\n        "type": "Room"\n      }\n    ],\n    "condition": {\n      "attrs": [\n        "temperature"\n      ],\n      "expression": {\n        "q": "temperature<15"\n      }\n    }\n  },\n  "notification": {\n    "http": {\n      "url": "http://localhost:1234"\n    },\n    "attrs": [\n      "temperature",\n      "humidity"\n    ]\n  },\n  "expires": "2020-12-30T14:00:00.00Z",\n  "throttling": 5\n}'),
(9, 'updateSubscriptionByID', 'ANY', 'EMPTY', ''),
(10, 'updateSubscriptionByID', 'ANY', 'JSON_ERROR', '{\n  "description": "any subscription",\n  "subject": {\n    "entities": [\n      {\n        "idPattern": ".*",,,\n        "type": "Room"\n      }\n    ],\n    "condition": {\n      "attrs": [\n        "temperature"\n      ],\n      "expression": {\n        "q": "temperature>40"\n      }\n    }\n  },\n  "notification": {{\n    "http": {\n      "url": "http://localhost:1234"\n    },\n    "attrs": [\n      "temperature",\n      "humidity"\n    ]\n  },\n  "expires": "2016-12-30T14:00:00.00Z",\n  "throttling": 5\n}');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
