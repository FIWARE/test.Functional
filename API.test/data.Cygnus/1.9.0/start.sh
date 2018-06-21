#!/bin/bash


echo "Start Cygnus"
export FLUME_HOME=/usr/cygnus
$FLUME_HOME/bin/cygnus-flume-ng agent --conf $FLUME_HOME/conf -f $FLUME_HOME/conf/agent_ngsi_api.conf -n cygnus-ngsi -p 5080 -Dflume.root.logger=INFO,console,LOGFILE -Duser.timezone=UTC



