#!/bin/bash
echo "Booting KidSize"
~/env/boot.sh
echo "Boot OK: waiting before init"
sleep 5
echo "Going to init"
~/env/rhio_cmd.sh init
echo "Init is ok: waiting before dancing"
sleep 2
echo "Going to dance: not implemented"
