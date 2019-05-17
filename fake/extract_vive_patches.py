#!/usr/bin/python3

import os
import sys
import subprocess
from prepare import *

def gatherLogs():
    """
    Prepare the environment for rhoban kid_size binary. Update symbolic links
    and analyze metadata from log.
    """
    vision_config = subprocess.check_output("basename $(readlink -f vision_config.json)", shell = True).decode("ascii").strip()
    if (vision_config != "vive_roi_extractor.json"):
        print("Unexpected link for vision_config.json: '{:}'".format(vision_config))
        exit(-1)
    log_name = subprocess.check_output("basename $(readlink -f workingLog)", shell = True).decode("ascii").strip()
    output_folder = "vive_data/" + log_name
    tmp_folder = "ground_truth"
    forbidden_folders = [output_folder, tmp_folder]
    for folder in forbidden_folders:
        if os.path.isdir(folder):
            print("Folder '{:}' should not exist!".format(folder))
            exit(-1)
    for folder in forbidden_folders:
        os.system("mkdir -p " + folder)
    # TODO: currently KidSize still returns 0 when stopped with ctrl-c
    if not os.system("./KidSize"):
        print("Failed to quit KidSize properly")
        exit(-1)
    os.system("mv {:}/* {:}".format(tmp_folder, output_folder))
    os.system("rm -rf " + tmp_folder)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: " + sys.argv[0] + " <pathsToLogs>")
        exit(-1)
    for path in sys.argv[1:]:
        print("Treating '{:}'".format(path))
        prepareEnv(path, True)
        gatherLogs()
