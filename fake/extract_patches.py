#!/usr/bin/env python3

import argparse
import os
import sys
import subprocess
from prepare import *

"""
TODO:
- the output folder is not chosen properly
"""

def gatherLogs(pipelineName):
    """
    Prepare the environment for rhoban kid_size binary. Update symbolic links
    and analyze metadata from log.
    """
    updatePipeline(pipelineName)
    log_name = getWorkingLogName()
    output_folder = "label_data/" + log_name
    tmp_folder = "ground_truth"
    forbidden_folders = [output_folder, tmp_folder]
    for folder in forbidden_folders:
        if os.path.isdir(folder):
            print("Folder '{:}' should not exist!".format(folder))
            exit(-1)
    for folder in forbidden_folders:
        systemOrRaise(["mkdir", "-p", folder])
    # TODO: currently KidSize still returns not 0 when stopped by vision
    if os.system("./KidSize") != 0:
        print("Error in KidSize")
        exit(-1)
    systemOrRaise(["mv", tmp_folder, output_folder])
    systemOrRaise(["rm","-rf", tmp_folder])

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--vive", action="store_true",
                        help="Use vive based logs (default: labelled logs)")
    parser.add_argument("logs", type=str,help="path to logs", nargs="+")
    args = parser.parse_args()


    if len(sys.argv) < 2:
        print("Usage: " + sys.argv[0] + " <pathsToLogs>")
        exit(-1)

    pipelineName = "labels_roi_extractor.json"
    viveRequired = False
    if args.vive:
        pipelineName = "vive_roi_extractor.json"
        viveRequired = True
    for path in args.logs:
        print("Treating '{:}'".format(path))
        prepareEnv(path, viveRequired)
        gatherLogs(pipelineName)
