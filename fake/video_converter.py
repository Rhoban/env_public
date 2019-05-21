#!/usr/bin/python3

# Convert logs with a format based on multiple images to a video format

import argparse
from prepare import *

def treatLog(log_path):
    prepareEnv(log_path)
    log_name = getWorkingLogName()
    updatePipeline("video_converter.json")
    systemOrRaise(["./KidSize"])
    os.system(["mv movie_recorder_output.avi movie_recorder_output_metadata.pb workingLog/")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("log_path", type=str,help="path to log folder")
    args = parser.parse_args()
    treatLog(args.log_path)
