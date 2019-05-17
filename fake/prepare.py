#!/usr/bin/python3

import os
import sys
import json

def prepareEnv(log_path):
    """
    Prepare the environment for rhoban kid_size binary. Update symbolic links
    and analyze metadata from log.
    """
    if not os.path.isdir(log_path):
        print(log_path + " is not a directory, cannot prepare Env")
        exit(-1)

    os.system("rm -rf workingLog && ln -sf {:} workingLog".format(log_path))

    metadata = {}
    with open("workingLog/metadata.json") as json_file:
        metadata = json.load(json_file)

    robot = metadata["robot"]

    robot_elements = { "calibration.json", "sigmaban.urdf" }

    for e in robot_elements:
        os.system("ln -sf ../{:}/{:}".format(robot, e))

    os.system("ln -sf ../strategies/with_grass.json kickStrategy_with_grass.json")
    os.system("ln -sf ../strategies/against_grass.json kickStrategy_counter_grass.json")
    os.system("ln -sf ../common/kicks/sigmaban_plus_kicks.json KickModelCollection.json")

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
