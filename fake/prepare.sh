#!/bin/bash

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
    echo "Usage: prepare.sh robotName"
    echo "Or"
    echo "Usage: prepare.sh robotName pathToLogs"
    exit
fi
robot=$1
echo "Preparing the fake env for the robot '$robot'"
env=$(dirname `pwd`)
echo "env path is $env"

declare -a elements=("calibration.json" "sigmaban.urdf" "camera_calib.yml")

for i in "${elements[@]}"
do
    if ln -sf "$env/$robot/$i" .
    then
        echo "Success."
    else
        echo "Warning : $i ln -sf failed !!!!!!!!!!!!"
        exit
    fi
done

echo "Linking to Sigmaban V2 strategies"
ln -sf ../strategies/with_grass.json kickStrategy_with_grass.json
ln -sf ../strategies/against_grass.json kickStrategy_counter_grass.json
ln -sf ../common/kicks/sigmaban_plus_kicks.json KickModelCollection.json

if [ "$#" -eq 2 ]; then
    echo "Setting the log path to '$2'"
    rm -rf workingLog
    ln -sf $2 workingLog
fi
