From ros:noetic-ros-base-focal

RUN apt-get update && apt-get install -y --no-install-recommends \
    libeigen3-dev \
    git \
    byobu \
    vim \
    python3-pip \
    python3-catkin-tools \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /opt/cse_ws/src
WORKDIR /opt/cse_ws/src
RUN git clone https://github.com/wlwsjl/cse.git
RUN rosdep install --from-paths . --ignore-src -r -y

WORKDIR /opt/cse_ws
RUN rosdep update
RUN catkin config  --extend /opt/ros/noetic
RUN catkin build

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

