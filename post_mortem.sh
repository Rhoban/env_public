#!/bin/sh
# Run gdb on last core produced

if [ $(ps -e | grep KidSize | wc -l ) -gt 0 ]
then
  echo "A KidSize process is running" 
  exit(-1)
fi
ROBOT=`hostname`
export LD_LIBRARY_PATH=$HOME/catkin_rel/
gdb -c $HOME/env/$ROBOT/ $HOME/catkin_rel/KidSize
