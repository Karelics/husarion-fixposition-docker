ARG ROS_DISTRO=humble

FROM husarnet/ros:${ROS_DISTRO}-ros-core

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

# Install Fixposition driver
RUN apt-get update && apt-get install -y \
        python3-pip \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-vcstool \
        git && \
    apt-get upgrade -y && \
    . /opt/ros/${ROS_DISTRO}/setup.bash && \
    git clone -b 7.0.2 https://github.com/fixposition/fixposition_driver.git /ros2_ws/src/fixposition_driver && \
    rm -rf /ros2_ws/src/fixposition_driver/fixposition_driver_ros1 /ros2_ws/src/fixposition_driver/fixposition_odometry_converter_ros1 && \
    rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --cmake-args -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release && \
    rm -r /ros2_ws/src /ros2_ws/log  /ros2_ws/build && \
    export SUDO_FORCE_REMOVE=yes && \
    apt-get remove -y \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-vcstool \
        git && \       
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo $(cat /ros2_ws/src/fixposition_driver/fixposition_driver_ros2/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt