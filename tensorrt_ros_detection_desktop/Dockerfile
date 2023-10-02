FROM nvcr.io/nvidia/tensorrt:22.07-py3

CMD ["bash"]
RUN echo 'Etc/UTC' > /etc/timezone \
#    && ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime \
#    && apt-get update \
    && apt-get install -q -y --no-install-recommends tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO noetic

RUN apt update && apt-get install -y --no-install-recommends \
    ros-noetic-ros-core=1.5.0-1* \
    && rm -rf /var/lib/apt/lists/*

COPY ./ros_entrypoint.sh /

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    byobu \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-ros-base=1.5.0-1* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    byobu \
    vim \
    python3-pip \
    #libgstreamer1.0-dev \
    #python-jinja2 \
    #python3-jinja2 \
    ros-noetic-perception=1.5.0-1* \
    #ros-noetic-gazebo-plugins \
    python3-catkin-tools \
    ros-noetic-xacro \
    #ros-noetic-joint-state-publisher \
    #ros-noetic-robot-state-publisher \
    #ros-noetic-gazebo-ros-pkgs \
    #ros-noetic-gazebo-ros-control \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install toml
RUN python3 -m pip install markupsafe==2.0.1

RUN mkdir ros_ws
WORKDIR /workspace/ros_ws
RUN mkdir src
WORKDIR /workspace/ros_ws/src
RUN git clone https://github.com/AntoineRichard/detect_and_track.git
WORKDIR /workspace/ros_ws
RUN catkin config  --extend /opt/ros/noetic
RUN catkin build

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
