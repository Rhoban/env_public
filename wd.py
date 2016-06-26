#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import socket
import signal
import time
import sys

ROBOT=socket.gethostname()
HOME=os.environ['HOME']

# ROBOT=`hostname`
# cd $HOME/Environments/$ROBOT/
# $HOME/Code/build/RhobanServer


WATCHDOG_TIME = 10

moveschedulerfile = '/tmp/moveschedulerIsAlive'
pipelinefile = '/tmp/pipelineIsAlive'

pid = ''
# global logfile = '/tmp/out.log'


#cmd = ['./test_wd', 'test']

cmd=['/bin/bash','boot.sh']

rhioinit = ['rhio',  'localhost',  'init']
rhiorobocup = ['rhio',  'localhost',  'robocup']

done = 0


def watchdog(sig, stack):
    global pid
    # print "Watchdog"

    if(pid.poll() is not None):
        print "Process has terminated. Rerun."
        run()

    elif(not os.path.isfile(moveschedulerfile) or not os.path.isfile(pipelinefile)):
        print moveschedulerfile
        print pipelinefile
        print os.path.isfile(moveschedulerfile)
        print os.path.isfile(pipelinefile)

        print "Process has frozen? Rerun."
        # kill and restart
        if(pid.poll() is None):
            os.kill(pid.pid, signal.SIGTERM)
            time.sleep(3)
        if(pid.poll() is None):
            print "Still not dead?"
            os.kill(pid.pid, signal.SIGKILL)
        run()
    else:
        os.remove(moveschedulerfile)
        os.remove(pipelinefile)

    signal.alarm(WATCHDOG_TIME)


def sigint(sig,  stack):
    # signal.signal(signal.SIGINT, original_sigint)
    global pid
    global done
    print "CTRL-C"
    if(done < 5):
        done += 1
        if(pid.poll() is None):
            print "Killing process"
            os.kill(pid.pid, signal.SIGINT)
    else:
        print "Ok we quit."
        sys.exit()


def run():
    global pid
    global logfile
    global cmd
    print "Launching ", cmd
    # pid = subprocess.Popen(cmd, stdout=logfile)
    pid = subprocess.Popen(cmd)
    time.sleep(5)
    print rhioinit
    r1 = subprocess.Popen(rhioinit)
    #r1.wait()
    time.sleep(3)
    print rhiorobocup
    r2 = subprocess.Popen(rhiorobocup)
    #r2.wait()
    time.sleep(3)
    
if __name__ == '__main__':
    signal.signal(signal.SIGALRM, watchdog)
    # original_sigint = signal.getsignal(signal.SIGINT)
    signal.signal(signal.SIGINT, sigint)
    signal.alarm(WATCHDOG_TIME)

    run()

    while(1):
        time.sleep(1)
