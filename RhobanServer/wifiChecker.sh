#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./wifiChecker.sh [field-letter]" ;
    exit ;
fi

FIELD="$1" ;

while [ 1 ]; do
    echo `date +%c` ": Checking wifi connection..." ;
    ISCONNECTED=0 ;
    ping -n -q -W 1 -c 1 192.168.0.1 > /dev/null;
    TEST1=$? ;
    if [ $TEST1 -eq 0 ]; then
        ISCONNECTED=1
    fi

    if [ $ISCONNECTED -eq 0 ]; then
        echo "We are not connected. Reconnection..." ;
        bash /home/rhoban/wifi.sh $FIELD;
    fi
    if [ $ISCONNECTED -eq 1 ]; then
        echo "OK, we are connected" ;
    fi

    sleep 5 ;
done;



