#!/bin/bash

ESSID="HL_KID_D"
IP="10.42.0.122"

iwconfig wlan0 | grep ESSID | grep $ESSID > /dev/null
if [ $? -eq 1 ] ;
then
    ifconfig wlan0 down ; sleep 1 ; ifconfig wlan0 up ; iwconfig wlan0 mode managed ; iwconfig wlan0 key off ; iwconfig wlan0 essid $ESSID ; ifconfig wlan0 $IP
fi;

