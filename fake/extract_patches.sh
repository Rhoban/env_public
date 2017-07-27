#TODO check number of parameters

robotName=$1
logFolder=$2

# Prepare environment
./prepare.sh ${robotName} ${logFolder}

# Ensure patches folder are created and empty
rm -rf patches/ball patches/goal
mkdir -p patches/ball patches/goal

# Get logs
./run.sh

# Zip the patches to logFolder
cd patches/ball
zip ${logFolder}/balls.zip *.png
cd ../..
cd patches/goal
zip ${logFolder}/goals.zip *.png
cd ../..

