killall -9 RhobanServer
ROBOT=`hostname`
cd $HOME/Environments/$ROBOT/
export LD_LIBRARY_PATH=$HOME/catkin_rel/
nohup $HOME/catkin_rel/RhobanServer > out.log 2>&1 &
