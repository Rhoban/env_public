ROBOT=`hostname`

BACKUP_DIR=$HOME/BACKUP/$ROBOT

ENV_DIR=$HOME/Environments/$ROBOT/
RS_BINDIR=$HOME/Code/build/



if [ ! -d $BACKUP_DIR ]
then
    mkdir -p $BACKUP_DIR
fi


# generate liste of md5 in $1
function compute_binaries_md5 {
    ( for binary in $RS_BINDIR/RhobanServer
      do
	  echo $binary
	  ldd $binary | grep -v '/lib/' | grep -v vdso | grep -v lib64 | cut -d ' ' -f 3
      done ) | while read file
	       do
		   md5sum $file
	       done >> $1
}

function compute_env_md5 {
    flist=$(tempfile)
    find $ENV_DIR -type f -not -iname "*log*" -not -name "*bin" | grep -v Logs >> $flist
    echo $ENV_DIR/$(grep bin $ENV_DIR/LocalisationTest.xml | tr '<' '>' | tr -d [:space:] | cut -d  '>' -f 3) >> $flist
    find $ENV_DIR/.. -maxdepth 1 -perm -u=x -type f >> $flist
    IFS=''
    cat $flist | while read f
                 do
		    md5sum $f | cut -d ' ' -f 1
		 done >> $1
    unset IFS
}

# copy environment and script in $1
function copy_env {
    dest_dir=$1
    mkdir $dest_dir
    # ignore logs and lut bin
    rsync --copy-links  -r --exclude "Logs" --exclude "log_*" --exclude "*bin" $ENV_DIR $dest_dir
    # keep only usefull lut bin
    cp $ENV_DIR/$(grep bin $ENV_DIR/LocalisationTest.xml | tr '<' '>' | tr -d [:space:] | cut -d  '>' -f 3) $dest_dir
    echo -e "\t copy scripts"
    cp $(find $ENV_DIR/.. -maxdepth 1 -perm -u=x -type f) $dest_dir
    compute_env_md5 $dest_dir/env_md5
}


function check_backup {
    if [ !  -d "$1" ]
    then
	echo -e "\e[101m$1:no such backup...\e[0m"
	exit 2
    fi
}

function check_backup_env {
    check_backup $1
    if [ !  -d "$1/$2" ]
    then
	echo -e "\e[101m$1/$2: no such env...\e[0m"
	exit 2
    fi
}

case "$1" in
    "help")
	cat <<EOF
./boot_sav.sh command args

commands
  * ignore: backup functions: use default binaries (deps) and default env (Environments)
  * list: list all available binary backups (last one at bottom)
  * list backup_name: list all available environments for a binary backup
  * restore backup_name: restore last environment available for the binary backup 
  * restore backup_name env_name: restore specific environment for a bin. backup
  * alias backup_name backup_alias_name
  * alias backup_name env_name env_alias_name
  * alias backup_name env_name backup_alias_name env_alias_name 
  * run backup_name: run using backup binary and last env of this binary
  * run backup_name env_name: run using backup binary and specific env 
  * send backup_name hostname: send binaries over ssh

without any option:
* 
EOF
	;;
    "send")
	check_backup $BACKUP_DIR/$2
	a=$(mktemp -p /tmp -d ${ROBOT}_SSH_XXX)
	d=$a/$2
	mkdir -p $d
	echo $d
	cp $BACKUP_DIR/$2/*so $BACKUP_DIR/$2/RhobanServer $d
	scp -r $d $3:BACKUP/$3/
	rm -rf $a
	exit
	;;
    "ignore")	
	;;
    "list")
	if [ "$2" != "" ]
	then
	    check_backup "$BACKUP_DIR/$2"
	    echo "environments available for $2:"
	    #ls -1rt $BACKUP_DIR/$2 | grep env_
	    ls -lrt $BACKUP_DIR/$2/ | grep ^[dl] | tr -s [:blank:] | cut -d " " -f 9- 
	else
	    echo "backups available:"
	    ls -lrt $BACKUP_DIR | tr -s [:blank:] | cut -d " " -f 9-
	fi
	exit ;;
    "alias")
	BALIAS=""
	EALIAS=""
	case  $# in
	    3) BNAME=$2; BALIAS=$3 ;;
	    4) BNAME=$2; ENAME=$3; EALIAS=$4 ;;
	    5) BNAME=$2; ENAME=$3; BALIAS=$4 ; EALIAS=$5 ;;
	esac
	cd $BACKUP_DIR
	if [ "$BALIAS" !=  "" ]
	then
	    if [ ! -d "$BNAME" ]
	    then
		echo -e "\e[101mno such backup...\e[0m"
	    else
		ln -s "$BNAME" "$BALIAS"
	    fi
	fi
	if [ "$EALIAS" != "" ]
	then
	    cd $BNAME
	    if [ !  -d "$ENAME" ]
	    then
		echo -e "\e[101mno such env...\e[0m"
	    else
		ln -s "$ENAME" "$EALIAS"
	    fi
	fi
	exit
	;;
    "restore")
	if [ !  -d "$BACKUP_DIR/$2" ]
	then
	    echo -e "\e[101mno such backup...\e[0m"
	    exit 2
	fi
	if [ "$3" == "" ]
	then
	    REST_ENV=$(ls -1rtd $BACKUP_DIR/$2/env_* | tail -1)
	else
	    REST_ENV="$BACKUP_DIR/$2/$3"
	fi
	if [ ! -d "$REST_ENV" ]
	then
	    echo -e "\e[101mno such environment ($REST_ENV)...\e[0m"
	    exit 2
	fi
	if [ -d $HOME/Environments/$ROBOT ]
	then
	    echo -e "\e[101mRemove environment (Y/N)? ($HOME/Environments/$ROBOT)\e[0m"
	    read resp
	    if [ "$resp" == "Y" ]
	    then
		d=$(mktemp -p /tmp -d ${ROBOT}_BACK_XXX)
		echo "move Environments/$ROBOT in $d"
		mv $HOME/Environments/$ROBOT $d
	    fi
	fi
	cp -R $REST_ENV $HOME/Environments/$ROBOT
	;;
    "run" ) if [ "$2" = "" -o  ! -d "$BACKUP_DIR/$2" ]
	    then
		echo -e "\e[101mno such backup...\e[0m"
		exit 1;
	    else
       		RS_BINDIR="$BACKUP_DIR/$2"
		if [ "$3" == "" ]
		then
		    echo "using the last environment"
		    ENV_DIR=$(ls -1rtd $BACKUP_DIR/$2/env_* | tail -1)
		    if [ ! -d "$ENV_DIR" ]
		    then
			ENV_DIR=$HOME/Environments/$ROBOT
		    fi
		else
		    if [ -d "$BACKUP_DIR/$2/$3" ]
		    then
			ENV_DIR="$BACKUP_DIR/$2/$3"
			RS_BINDIR=$BACKUP_DIR/$2
		    else			
			echo -e "\e[101mno such environment for backup...\e[0m"
			exit 2
		    fi
		fi
	    fi
	    ;;
    "") 
	echo "compute md5"
	# compute binaries md5sum
	md5=$(tempfile)
	compute_binaries_md5 $md5
	# scan all backups and diff md5file
	found=0
	for d in $BACKUP_DIR/*
	do
	    if [ -d "$d" ]
	    then
		if diff $md5 "$d/bin_md5" 2>&1 > /dev/null
		then
		    echo "binaries are already known in $d"
		    echo "check for environment with environment md5"
		    efound=0
		    envmd5=$(tempfile)
		    compute_env_md5 $envmd5
		    for e in $d/env_*
		    do
			if [ -d "$e" ]
			then
			    if diff $envmd5 $e/env_md5 2>&1 > /dev/null
			    then
				echo "environment is also known"
				efound=1
			    fi
			fi
		    done
		    if [ $efound -eq 0 ]
		    then
			echo "backup environment"
			ENV_COPY=$d/env_$(date "+%Y_%m_%d_%H-%M")
			copy_env $ENV_COPY
		    fi
		    rm -f $envmd5
		    #ENV_DIR=$d/env
		    #RS_BINDIR=$d
		    found=1
		fi
	    fi
	done
	if [ $found -eq 0 ]
	then
	    echo "making binary backup:"
	    echo -e "\t copy md5, lib and exec"
	    DEST_DIR=$BACKUP_DIR/$(date "+%Y_%m_%d_%H-%M")
	    mkdir $DEST_DIR
	    cat $md5 | tr -s [:blank:] | cut -d ' ' -f 2 | xargs cp -t $DEST_DIR
	    mv $md5 $DEST_DIR/bin_md5
	    echo -e "\t remove rpath from executable"
	    chrpath -d $DEST_DIR/RhobanServer
	    echo -e "\t copy environment"
	    ENV_COPY=$DEST_DIR/env_$(date "+%Y_%m_%d_%H-%M")
	    copy_env $ENV_COPY

	    #ENV_DIR=$ENV_COPY
	    #RS_BINDIR=$DEST_DIR
	fi
	rm -f $md5
	;;

esac

killall -9 RhobanServer
echo "Running from $RS_BINDIR with environment $ENV_DIR"

cd $ENV_DIR
export LD_LIBRARY_PATH=$RS_BINDIR:$LD_LIBRARY_PATH
#echo "LD_LIBRARY_PATH is " $LD_LIBRARY_PATH
#pwd
nohup $RS_BINDIR/RhobanServer > out.log 2>&1 &
#$RS_BINDIR/RhobanServer 
