killall -9 RhobanServer
ROBOT=`hostname`
cd $HOME/Environments/$ROBOT/
nohup $HOME/bin/RhobanServer > out.log 2>&1 &
