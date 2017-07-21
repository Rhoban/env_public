if [ -e ../../../../devel_nv_release/.private/RhobanServer/lib/RhobanServer/RhobanServer ]
then 
	../../../../devel_nv_release/.private/RhobanServer/lib/RhobanServer/RhobanServer $*
else
	../../../../devel_nv_debug/lib/RhobanServer/RhobanServer $*
fi;
