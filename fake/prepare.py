#!/usr/bin/python3

import os
import json
import subprocess
import sys

def systemOrRaise(args):
    """
    Execute a system command and raise a RuntimeError on failure.
    Input/output is captured and output is returned.
    """
    result = subprocess.run(args, stdout = subprocess.PIPE, stderr = subprocess.STDOUT)
    out_str = result.stdout.decode("ascii").strip()
    if result.returncode == 0:
        return out_str
    else:
        raise RuntimeError("Failed to execute system '" + str(args) + "' output: " + out_str)

def getWorkingLogName():
    return systemOrRaise(["basename","$(readlink -f workingLog)"])

def updatePipeline(pipeline_file):
    return systemOrRaise(["ln", "-sf", "../common/vision_filters/" + pipeline_file, "vision_config.json"])

def prepareEnv(log_path, require_tracker = False):
    """
    Prepare the environment for rhoban kid_size binary. Update symbolic links
    and analyze metadata from log.
    """
    if not os.path.isdir(log_path):
        print(log_path + " is not a directory, cannot prepare Env")
        exit(-1)

    os.system("rm -rf workingLog && ln -sf {:} workingLog".format(log_path))

    calibration_path = log_path + "/calibration.json"
    if os.path.isdir(calibration_path):
        os.system("ln -sf " + calibration_path + " workingLog/calibration.json");
    else:
        print("No calibration.json found")

    metadata = {}
    with open("workingLog/metadata.json") as json_file:
        metadata = json.load(json_file)

    if "tracker_serial" in metadata:
        tracker_serial = metadata["tracker_serial"]
        print ("Setting tracker_serial to " + tracker_serial)
        cmd = "sed -i 's/tracker_serial.value = .*/tracker_serial.value = {:}/g' rhio/vive/values.conf".format(tracker_serial)
        os.system(cmd)
    elif require_tracker:
        print("Tracker is not available while required for log '{:}'".format(log_path))
        exit(-1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: " + sys.argv[0] + " <pathToLog>")
        exit(-1)
    prepareEnv(sys.argv[1])

