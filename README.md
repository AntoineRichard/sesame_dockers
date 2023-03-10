# Sesame Dockers
This git provides the necessary components required to build our docker containers.\
To install docker one can refere to: https://docs.docker.com/desktop/

Or run the following commands: 
```
# Docker install
sudo apt install docker.io

# Nvidia docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

# Building the containers
To build the containers used for the sesame project, we provide different docker files. 
The total disk space required to build them is about 16Gb.
This significant size is due to the installation of ROS, Gazebo and the CUDA toolchain.
We install the CUDA toolchain as this is required to run and compile our neural-networks.

First, we will build the base image. It creates a docker with Nvidia-Cuda-11.4 and ROS Noetic.
```
docker build cuda11.4_ros_noetic_docker -t focal_cuda11_4_noetic
```
If you don't have an Nvidia graphics card, you can use the following:
```
docker build ros_noetic_docker -t ros_noetic_base_docker
```
Then we will build our simulation environments
```
docker build sesame_simulation_docker -t sesame_simulation_focal_cuda11_4_noetic
```
If you don't have an Nvidia GPU, you can run the following instead:
```
docker build sesame_simulation_docker_no_nvidia -t sesame_simulation_focal_noetic
```

With the docker build, the simulation can now be started from within the docker like so:
```
# Start the docker (--gpus all allows the container to access the GPUs from the host device)
```
./sesame_simulation_docker_no_nvidia/run.sh
```
```
./sesame_simulation_docker/run.sh
```
# Inside the docker start the simulation
roslaunch sesame_ul_uavs aerolab_one_drone.launch
```
