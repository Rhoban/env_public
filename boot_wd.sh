#!/bin/bash
ROBOT=`hostname`
cd $HOME/Environments/
nohup python -u ./wd.py > $HOME/Environments/$ROBOT/out.log &
tail -f $HOME/Environments/$ROBOT/out.log
