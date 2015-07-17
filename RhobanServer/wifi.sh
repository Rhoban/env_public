#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./wifi.sh [field-letter]"
    exit
fi

ESSID="HL_KID_$1"
HOSTNAME=`hostname`

if [ "$HOSTNAME" == "chewbacca" ]; then
    IP="192.168.16.101"
fi
if [ "$HOSTNAME" == "mowgly" ]; then
    IP="192.168.16.102"
fi
if [ "$HOSTNAME" == "django" ]; then
    IP="192.168.16.103"
fi
if [ "$HOSTNAME" == "tom" ]; then
    IP="192.168.16.104"
fi

echo "Connecting to $ESSID with $IP..."
sudo killall wpa_supplicant ;
sudo ifconfig wlan0 down ; 
sleep 1 ; 
sudo ifconfig wlan0 up ; 
sudo iw wlan0 scan|grep $ESSID ;
sudo iw dev wlan0 set type managed ;
sudo iw dev wlan0 connect $ESSID ;
sudo ifconfig wlan0 $IP netmask 255.255.0.0 ;
echo "done"
