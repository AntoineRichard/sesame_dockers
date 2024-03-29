#!/usr/bin/env bash

TAG="cse"

## Forward custom volumes and environment variables
CUSTOM_VOLUMES=()
CUSTOM_ENVS=()
while getopts ":v:e:" opt; do
    case "${opt}" in
        v) CUSTOM_VOLUMES+=("${OPTARG}") ;;
        e) CUSTOM_ENVS+=("${OPTARG}") ;;
        *)
            echo >&2 "Usage: ${0} [-v VOLUME] [-e ENV] [TAG] [CMD]"
            exit 2
            ;;
    esac
done
shift "$((OPTIND - 1))"

## Determine TAG and CMD positional arguments
if [ "${#}" -gt "0" ]; then
    if [[ $(docker images --format "{{.Tag}}" "${TAG}") =~ (^|[[:space:]])${1}($|[[:space:]]) || $(wget -q https://registry.hub.docker.com/v2/repositories/${TAG}/tags -O - | grep -Poe '(?<=(\"name\":\")).*?(?=\")') =~ (^|[[:space:]])${1}($|[[:space:]]) ]]; then
        # Use the first argument as a tag is such tag exists either locally or on the remote registry
        TAG="${TAG}:${1}"
        CMD=${*:2}
    else
        CMD=${*:1}
    fi
fi

## GPU
# Otherwise just run with DRIs
if [[ $(getent group video) ]]; then
    GPU_OPT="--device=/dev/dri:/dev/dri --group-add video"
else
    GPU_OPT="--device=/dev/dri:/dev/dri"
fi

## GUI
# To enable GUI, make sure processes in the container can connect to the x server
XAUTH=/tmp/.docker.xauth
if [ ! -f ${XAUTH} ]; then
    touch ${XAUTH}
    chmod a+r ${XAUTH}

    XAUTH_LIST=$(xauth nlist "${DISPLAY}")
    if [ -n "${XAUTH_LIST}" ]; then
        # shellcheck disable=SC2001
        XAUTH_LIST=$(sed -e 's/^..../ffff/' <<<"${XAUTH_LIST}")
        echo "${XAUTH_LIST}" | xauth -f ${XAUTH} nmerge -
    fi
fi
# GUI-enabling volumes
GUI_VOLUMES=(
    "${XAUTH}:${XAUTH}"
    "/tmp/.X11-unix:/tmp/.X11-unix"
    "/dev/input:/dev/input"
)
# GUI-enabling environment variables
GUI_ENVS=(
    XAUTHORITY="${XAUTH}"
    QT_X11_NO_MITSHM=1
    DISPLAY="${DISPLAY}"
)

## Additional volumes
# Synchronize timezone with host
CUSTOM_VOLUMES+=("/etc/localtime:/etc/localtime:ro")

## Additional environment variables
# Synchronize ROS_MASTER_URI with host
if [ -n "${ROS_MASTER_URI}" ]; then
    CUSTOM_ENVS+=("ROS_MASTER_URI=${ROS_MASTER_URI}")
fi
# Synchronize IGN_PARTITION with host
if [ -n "${IGN_PARTITION}" ]; then
    CUSTOM_ENVS+=("IGN_PARTITION=${IGN_PARTITION}")
fi

DOCKER_RUN_CMD=(
    docker run
    --interactive
    --tty
    --rm
    --network host
    --ipc host
    --privileged
    --security-opt "seccomp=unconfined"
    "${GUI_VOLUMES[@]/#/"--volume "}"
    "${GUI_ENVS[@]/#/"--env "}"
    "${GPU_OPT}"
    "${GPU_ENVS[@]/#/"--env "}"
    "${CUSTOM_VOLUMES[@]/#/"--volume "}"
    "${CUSTOM_ENVS[@]/#/"--env "}"
    "${TAG}"
    "${CMD}"
)

echo -e "\033[1;30m${DOCKER_RUN_CMD[*]}\033[0m" | xargs

# shellcheck disable=SC2048
exec ${DOCKER_RUN_CMD[*]}
