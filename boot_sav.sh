killall -9 RhobanServer
ROBOT=`hostname`

BACKUP_DIR=$HOME/BACKUP/$ROBOT

ENV_DIR=$HOME/Environments/$ROBOT/
RS_BINDIR=$HOME/Code/build/

if [ ! -d $BACKUP_DIR ]
then
    mkdir -p $BACKUP_DIR
fi


case "$1" in
    "list") ls -1rt $BACKUP_DIR ;;
    "run" ) if [ "$2" = "" -o  ! -d "$BACKUP_DIR/$2" ]
	    then
		echo "no such backup"
		exit 1;
	    else
		ENV_DIR=$BACKUP_DIR/$2/env
		RS_BINDIR=$BACKUP_DIR/$2
	    fi
	    ;;
    "") 
	echo "compute md5"
	# compute binaries md5sum
	md5=$(tempfile)
	
	( for binary in $RS_BINDIR/RhobanServer
	  do
	      echo $binary
	      ldd $binary | grep -v '/lib/' | grep -v vdso | grep -v lib64 | cut -d ' ' -f 3
	  done ) | while read file
		   do
		       md5sum $file
		   done >> $md5
	# scan all backups and diff md5file
	found=0
	for d in $BACKUP_DIR/*
	do
	    if [ -d "$d" ]
	    then
		if diff $md5 "$d/bin_md5"
		then
		    echo "binaries are already known in $d"
		    ENV_DIR=$d/env
		    RS_BINDIR=$d
		    found=1
		fi
	    fi
	done
	if [ $found -eq 0 ]
	then
	    echo "making binary backup"
	    DEST_DIR=$BACKUP_DIR/$(date "+%Y_%m_%d_%H-%M")
	    mkdir $DEST_DIR
	    cat $md5 | tr -s [:blank:] | cut -d ' ' -f 2 | xargs cp -t $DEST_DIR
	    mv $md5 $DEST_DIR/bin_md5
	    echo "copying environment too"
	    cp -R $ENV_DIR $DEST_DIR/env
	    ENV_DIR=$DEST_DIR/env
	    RS_BINDIR=$DEST_DIR
	fi
	;;

esac

echo "Running from $RS_BINDIR with environment $ENV_DIR"

cd $ENV_DIR
export LD_LIBRARY_PATH=$RS_BINDIR:$LD_LIBRARY_PATH
nohup $RS_BINDIR/RhobanServer > out.log 2>&1 &
