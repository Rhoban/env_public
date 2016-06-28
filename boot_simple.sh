#!/bin/bash
killall -9 RhobanServer
ROBOT=`hostname`
cd $HOME/Environments/$ROBOT/
$HOME/Code/build/RhobanServer >$HOME/Environments/$ROBOT/out.log 2>$HOME/Environments/$ROBOT/out.log

