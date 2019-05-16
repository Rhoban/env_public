#!/usr/bin/python3

import os
import sys
import json

if len(sys.argv) != 2:
    print("Usage: " + sys.argv[0] + " <pathToLog>")

log_dir = sys.argv[1]

if not os.path.isdir(log_dir):
    print(log_dir + " is not a directory")
    exit(-1)

os.system("rm -rf workingLog && ln -sf {:} workingLog".format(log_dir))

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
