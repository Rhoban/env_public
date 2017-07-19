if [ -e /tmp/rs.log ]
then
	rm -f /tmp/rs.log
fi;
touch /tmp/rs.log
../../../../devel_nv_release/.private/RhobanServer/lib/RhobanServer/RhobanServer 2>&1 | tee /tmp/rs.log | grep $*
