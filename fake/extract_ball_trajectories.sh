#TODO check number of parameters
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <robotName> <log1> <log2> ..."
    exit
fi

robotName=$1

outputFile="ballTrajectories.csv"
tmpFile="test.tmp"
binary="../../../../devel_release/lib/kid_size/KidSize"

# Adding header to output file
echo "log,time,xWorld,yWorld,vxWorld,vyWorld,xSelf,ySelf,vxSelf,vySelf" > ${outputFile}

for ((idx = 2; idx < $#; ++idx)); do
    logDir=${!idx}
    logName=$(basename ${logDir})
    echo "extractin ball status from '${logName}'"
    ./prepare.sh ${robotName} ${logDir}
    ${binary} 2>&1 | grep "\[vision_robocup\] ballStatusEntry:" > ${tmpFile}
    sed "s|.*\[vision_robocup\] ballStatusEntry: |${logName},|g" ${tmpFile} >> ${outputFile}
done

rm -rf ${tmpFile}
