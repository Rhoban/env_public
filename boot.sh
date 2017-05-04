killall -9 RhobanServer
ROBOT=`hostname`
cd $HOME/Environments/$ROBOT/
nohup $HOME/catkin_rel/RhobanServer > out.log 2>&1 &
