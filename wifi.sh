#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./wifi.sh [field-number]"
    exit
fi

ESSID="HL_KID_$1"
HOSTNAME=`hostname`

if [ "$HOSTNAME" == "chewbacca" ]; then
    IP="192.168.100.101"
fi
if [ "$HOSTNAME" == "mowgly" ]; then
    IP="192.168.100.102"
fi
if [ "$HOSTNAME" == "django" ]; then
    IP="192.168.100.103"
fi
if [ "$HOSTNAME" == "tom" ]; then
    IP="192.168.100.104"
fi

killall -2 ping
echo "Connecting to $ESSID with $IP..."
sudo killall wpa_supplicant ;
sudo ifconfig wlan0 down ; 
sudo ifconfig wlan0 up ; 
sudo iwlist wlan0 scan|grep $ESSID ;
sudo iwconfig wlan0 mode managed essid $ESSID;
sudo ifconfig wlan0 $IP netmask 255.255.0.0 ;
echo "done, pinging field router to check it's ok"
nohup ping 192.168.0.1 > ping.log &

