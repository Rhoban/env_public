#../../../../devel_nv_release/lib/RhobanServer/RhobanServer
if [ "$*" != "" ]
then
	tmux new-session -d "./novision_1.sh $*" \; split-window "tail -f  /tmp/rs.log" \; attach
else
	../../../../devel_nv_release/.private/RhobanServer/lib/RhobanServer/RhobanServer
fi
