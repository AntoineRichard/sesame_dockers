#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/opt/sesame_ws/devel/setup.bash"
exec "$@"
