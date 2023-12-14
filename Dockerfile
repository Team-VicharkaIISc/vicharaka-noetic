FROM nvidia/cudagl:11.1.1-base-ubuntu20.04

# Minimal setup
RUN apt-get update \
 && apt-get install -y locales lsb-release
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg-reconfigure locales

# Install ROS Noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ros-noetic-desktop-full
RUN apt-get install -y --no-install-recommends python3-rosdep
RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update
RUN apt-get install -y build-essential

# Get the username from the environment during build
ARG USERNAME=$USERNAME
ARG USER_UID=$USER_UID
# Set the username dynamically
RUN useradd -u $USER_UID -ms /bin/bash $USERNAME
WORKDIR /home/$USERNAME
RUN echo hello
RUN mkdir -p /home/$USERNAME/
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc
RUN chown -R $USERNAME /home/$USERNAME/
USER $USERNAME
