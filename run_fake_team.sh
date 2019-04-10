#!/bin/bash

killall -9 KidSizeNoVision behavior_viewer
sleep 1

ports[0]=9998
ports[1]=10000
ports[2]=10003

robot_id=1

for port in ${ports[@]}
do
    dst=tmp_robot_${port}
    rm -rf $dst
    mkdir $dst
    cp -r fake/* $dst
    cd $dst
    sed -i "s/id.value = [0-9]/id.value = ${robot_id}/g" rhio/referee/values.conf
    ./KidSizeNoVision -p ${port} > out.log 2>&1 &
    robot_id=$((robot_id + 1))
    BehaviorViewer 127.0.0.1 ${port} &
    cd ..
done
