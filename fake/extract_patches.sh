#TODO check number of parameters
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 robotName <log1> <log2> ..."
    exit
fi

robotName=$1

for ((idx = 2; idx <= $#; ++idx)); do
    logFolder=${!idx}
    logName=$(basename $logFolder)

    # Prepare environment
    ./prepare.sh ${robotName} ${logFolder}
    
    # Ensure patches folder are created and empty
    rm -rf patches/ball patches/goal
    mkdir -p patches/ball patches/goal
    
    # Get logs
    ./run.sh
    
    # Zip the patches to a folder with the log name in patches
    rm -rf patches/${logName}
    mkdir patches/${logName}
    cd patches/ball
    zip ../${logName}/balls.zip *.png
    cd ../..
    cd patches/goal
    zip ../${logName}/goals.zip *.png
    cd ../..
done
