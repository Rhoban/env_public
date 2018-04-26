#TODO check number of parameters
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 folderName"
    exit
fi

objTypes[0]="ball"
objTypes[1]="goal"
objTypes[2]="robots"

dstFolder="patches/results"


folderName=$1

robots=$(ls ${folderName})

# Cleaning existing results
rm -rf $dstFolder
mkdir -p $dstFolder

for robot in ${robots[@]}; do
    echo ${robot}
    robotPath=${folderName}/${robot}
    seqNames=$(ls ${robotPath})
    for seqName in ${seqNames[@]}; do
        echo "-> ${seqName}"
        seqFolder=${robotPath}/${seqName}


        # Prepare environment
        ./prepare.sh ${robot} ${seqFolder}
        
        # Ensure patches folder are created and empty
        for objType in ${objTypes[@]}; do
            rm -rf patches/${objType}
            mkdir -p patches/${objType}
        done
        # Get logs
        ./run.sh

        # Move objTypes inside folder
        seqDst=${dstFolder}/${robot}/${seqName}
        mkdir -p ${seqDst}
        for objType in ${objTypes[@]}; do
            mv patches/${objType} ${seqDst}
        done
    done
done

# Zip the logs to an archive
cd ${dstFolder}
tar -czf patches.tar.gz *
