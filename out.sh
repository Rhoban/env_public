#ROBOT=`hostname`
#cd $HOME/Environments/$ROBOT/
#tail -f out.log

RPID=$(ps -o pid,command | grep -v grep | grep RhobanServer | cut -d ' ' -f 2)
if [ $RPID == "" ]
then
    echo -e "\e[101mno RhobanServer running...\e[0m"
    exit 2
fi

if [ ! -d /proc/$RPID/cwd ]
then
    echo -e "\e[101mproblem with RhobanServer... check with ps\e[0m"
fi

echo -n "Print out.log from "
readlink -f /proc/$RPID/cwd
cd /proc/$RPID/cwd
tail -f out.log

