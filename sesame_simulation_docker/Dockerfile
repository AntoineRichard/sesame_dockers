FROM focal_cuda11_4_noetic

CMD ["bash"]
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    byobu \
    vim \
    python3-pip \
    libgstreamer1.0-dev \
    python-jinja2 \
    python3-jinja2 \
    ros-noetic-perception=1.5.0-1* \
    ros-noetic-gazebo-plugins \
    python3-catkin-tools \
    ros-noetic-xacro \
    ros-noetic-joint-state-publisher \
    ros-noetic-robot-state-publisher \
    ros-noetic-gazebo-ros-pkgs \
    ros-noetic-gazebo-ros-control \
    xvfb

RUN python3 -m pip install toml
RUN python3 -m pip install markupsafe==2.0.1

RUN mkdir -p /opt/sesame_ws/src
WORKDIR /opt/sesame_ws/src

RUN git clone https://github.com/AntoineRichard/grvc-ual-3.1-noetic.git grvc-ual
RUN git clone https://github.com/AntoineRichard/PX4-V1.10.2-gz11.git Firmware
RUN git clone https://github.com/AntoineRichard/VineyardGazebo.git vineyard
RUN git clone https://github.com/AntoineRichard/sesame_ul_uavs.git
RUN rosdep install --from-paths . --ignore-src -r -y

WORKDIR /opt/sesame_ws/src/Firmware
RUN git submodule update --init --recursive
RUN make -j8
RUN DONT_RUN=1 make px4_sitl_default gazebo

WORKDIR /opt/sesame_ws/src/grvc-ual
RUN apt-get update
RUN ./configure_mavros.sh

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sesame_ws
RUN rosdep update
RUN catkin config  --extend /opt/ros/noetic
RUN catkin build

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

