From ros:noetic-ros-base-focal

RUN apt-get update && apt-get install -y --no-install-recommends \
    libeigen3-dev \
    git \
    byobu \
    vim \
    python3-pip \
    python3-catkin-tools \
    python3-numpy \
    python3-pandas \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/nav_ws/src
WORKDIR /opt/nav_ws/src
RUN git clone https://github.com/AntoineRichard/sesame_navigation.git 
RUN apt-get update
RUN rosdep install --from-paths . --ignore-src -r -y

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /opt/nav_ws
RUN rosdep update
RUN catkin config  --extend /opt/ros/noetic
RUN catkin build

RUN apt-get update && apt-get install -y --no-install-recommends ros-noetic-perception=1.5.0-1* && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install opencv-contrib-python

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

