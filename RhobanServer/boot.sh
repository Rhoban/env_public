#!/bin/bash

ROBOT=`hostname`
ENVS=$HOME/Environments/

# Killing RhobanServer
killall -2 RhobanServer
sleep 0.1
killall -9 RhobanServer

# Running RhobanServer
cd $ENVS/RhobanServer/$ROBOT &&
nohup $HOME/RhobanCode/RhobanServer/release/RhobanServer &
