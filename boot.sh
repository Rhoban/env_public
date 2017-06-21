killall -9 RhobanServer
ulimit -c unlimited
ROBOT=`hostname`
cd $HOME/env/$ROBOT/
export LD_LIBRARY_PATH=$HOME/catkin_rel/
nohup $HOME/catkin_rel/RhobanServer > out.log 2>&1 &
