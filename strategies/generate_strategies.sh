#!/bin/sh

#Path to binary
BIN="${HOME}/rhoban/workspace/devel_release/lib/kid_size/KickStrategy"

FLAGS=""
# Specifiying kick model collection file
FLAGS="${FLAGS} -j ../common/kicks/sigmaban_plus_kicks.json"
# Specifiying resolution
FLAGS="${FLAGS} -d 5 -a 0.25"
# Adding time tolerance
FLAGS="${FLAGS} -t 5"
# Adding excentric strategy
FLAGS="${FLAGS} -e"

#Running learning with grass
${BIN} ${FLAGS} -c with_grass.csv >with_grass.json

#Running learning against grass
${BIN} ${FLAGS} -c against_grass.csv -o 0 -w >against_grass.json
