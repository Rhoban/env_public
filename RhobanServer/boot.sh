#!/bin/bash

ROBOT=`hostname`
ENVS=$HOME/Environments/

# Killing RhobanServer
killall -2 RhobanServer
sleep 0.1
killall -9 RhobanServer

# Killing the STM
sleep 0.1
killall -9 python3
sleep 0.1

# Running RhobanServer
cd $ENVS/RhobanServer/$ROBOT &&
nohup ./start_rhoban_server &

# Running the STM
cd $ENVS/RhobanServer/$ROBOT &&
nohup ./start_stm > stm_server.out 2>&1 &

