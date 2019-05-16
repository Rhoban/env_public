#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <data_folder>"
    exit
fi

# Reading current config
VISION_CONFIG=$( basename $(readlink -f vision_config.json) )
LOG_NAME=$( basename $(readlink -f workingLog) )
TMP_OUTPUT="ground_truth"


DST="$1/${LOG_NAME}"

if [ ${VISION_CONFIG} != "vive_roi_extractor.json" ]; then
  echo "Unexpected link for vision_config.json: '${VISION_CONFIG}'"
fi

if [ -e ${DST} ]; then
  echo "'${DST}' already exists"
  exit -1
fi

if [ -e ${TMP_OUTPUT} ]; then
  echo "'${TMP_OUTPUT}' already exists"
  exit -1
fi

mkdir -p ${DST}
mkdir ${TMP_OUTPUT}

./KidSize

# Cleaning created data
mv ${TMP_OUTPUT}/* ${DST}
rm -rf  ${TMP_OUTPUT}
