#!/bin/bash

# Killing RhobanServer
killall -2 RhobanServer
sleep 0.1
killall -9 RhobanServer

# Killing the STM
sleep 0.1
killall -9 python3
sleep 0.1
