ROBOT=`hostname`
cd $HOME/env/$ROBOT/
tail -f out.log | grep -v ballStatusEntry
