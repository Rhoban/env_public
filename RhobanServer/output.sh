#!/bin/bash

ROBOT=`hostname`
ENVS=$HOME/Environments/

cd $ENVS/RhobanServer/$ROBOT &&
tail -f nohup.out

