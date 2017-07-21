#../../../../devel_nv_release/lib/RhobanServer/RhobanServer
if [ "$*" != "" ]
then
    which tmux > /dev/null
    if [ $? -eq 1 ]
    then
	echo "need tmux to use grep mode"
    else
	tmux new-session -d "./novision_1.sh $*" \; split-window "tail -F  /tmp/rs.log" \; attach
    fi
else
    ../../../../devel_nv_release/.private/RhobanServer/lib/RhobanServer/RhobanServer
fi
