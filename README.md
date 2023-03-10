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
Start the docker without nvidia gpus
```
./sesame_simulation_docker_no_nvidia/run.sh
```
Start the docker with nvidia gpus
```
./sesame_simulation_docker/run.sh
```
# Inside the docker start the simulation
```
roslaunch sesame_ul_uavs aerolab_one_drone.launch
```
Or run a full scenario:
```
roslaunch sesame_ul_uavs aerolab_two_drones.launch
```
Wait for the simulation to start, once its ready you should see something like that (it can take a couple minutes to spin up):
```
[INFO] [1678302219.790588, 4.000000]: Safety pilot simulator for robot id [2]: arming [/uav_2/mavros/cmd/arming]
[ INFO] [1678302220.351252091, 4.560000000]: UAL 2 ready!
[ WARN] [1678302231.807167530, 16.000000000]: GF: timeout, retries left 2
[ WARN] [1678302231.807313367, 16.000000000]: WP: timeout, retries left 2
[ WARN] [1678302232.808159510, 17.000000000]: WP: timeout, retries left 1
[ERROR] [1678302234.992471798, 19.184000000]: FCU: IGN REQUEST LIST: Busy
[ERROR] [1678302235.044295198, 19.236000000]: FCU: IGN REQUEST LIST: Busy
[ WARN] [1678302235.989469453, 20.180000000]: GF: timeout, retries left 2
[ WARN] [1678302235.989521137, 20.180000000]: RP: timeout, retries left 2
[ERROR] [1678302235.992677881, 20.184000000]: FCU: IGN REQUEST LIST: Busy
[ WARN] [1678302236.989915355, 21.180000000]: RP: timeout, retries left 1
```
Then send a flight plan to the drones!
```
roslaunch sesame_ul_uavs simple_mission.launch namespace:=uav_1 flight_plan_path:=$(rospack find sesame_ul_uavs)/cfg/grid_pattern_aerolab.yaml
roslaunch sesame_ul_uavs simple_mission.launch namespace:=uav_2 flight_plan_path:=$(rospack find sesame_ul_uavs)/cfg/observer_position.yaml
```
In rviz you should be able to see the drones moving!
