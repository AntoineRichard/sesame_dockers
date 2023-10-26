#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/workspace/ros_ws/devel/setup.bash" --
exec "$@"
