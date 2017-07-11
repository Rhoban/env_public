if [ "$#" -ne 1 && "$#" -ne 2]; then
    echo "Usage: prepare.sh robotName"
    echo "Or"
    echo "Usage: prepare.sh robotName pathToLogs"    
    exit
fi
robot=$1
echo "Preparing the fake env for the robot 'robot'"
env=$(dirname `pwd`)
echo "env path is $env"

declare -a elements=("cameraModel.params" "sigmaban.urdf" "camera_calib.yml")

for i in "${elements[@]}"
do
    echo "Deleting $i from fake and replacing it by $robot's..."
    rm $i
    if cp "$env/$robot/$i" .
    then
        echo "Success."
    else
        echo "Warning : $i cp failed !!!!!!!!!!!!"
        exit
    fi
    
done

if [ "$#" -eq 2 ]; then
    echo "Setting the log path to '$2'"
    rm workingLog
    ln -sf $2 workingLog
fi