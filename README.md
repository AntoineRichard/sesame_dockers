# Sesame Dockers
This git provides the necessary components required to build our docker containers.\
To install docker one can refere to: https://docs.docker.com/desktop/

Or run the following command: 
```
sudo apt install docker.io
```

# Building the containers
To build the containers used for the sesame project, we provide different docker files. 
The total disk space required to build them is about 16Gb.
This significant size is due to the installation of both ROS and the CUDA toolchain.
We install the CUDA toolchain as this is required to run and compile our neural-networks.

First we will build the base image. It creates a docker with Nvidia-Cuda-11.4 and ROS Noetic.
```
docker build cuda11.4_ros_noetic_docker -t focal_cuda11_4_noetic
```
Then we will build our simulation environments
```
docker build sesame_simulation_docker -t sesame_simulation_focal_cuda11_4_noetic
```
With the docker build the simulation can now be started from within the docker like so:
