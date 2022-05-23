#!/usr/bin/env bash

# Expose the X server on the host.
# This only works if the user is root though!

ROBOT_IP=172.16.0.2
GRASP_SERVER_CONFIG=grasp_server_config.yaml
# Set to use custom table height, otherwise default for config will be used
TABLE_HEIGHT=""
# Set serial numbers of cameras
HAND_CAMERA_SERIAL=""
SETUP_CAMERA_SERIAL=""


xhost +local:root
# --rm: Make the container ephemeral (delete on exit).
# -it: Interactive TTY.
# --gpus all: Expose all GPUs to the container.
docker run \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev:/dev \
  -e DISPLAY=$DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  --network=host \
  --privileged \
  ghcr.io/hsp-panda/ros_panda_setup_graspa:latest \
  /bin/bash -i -c 'roslaunch panda_grasp_server GRASPA_reachability_calibration.launch \
                                robot_ip:='"${ROBOT_IP}"' \
                                table_height:='"${TABLE_HEIGHT}"' \
                                grasp_server_config:='"${GRASP_SERVER_CONFIG}"' \
                                setup_camera_serial:='"${SETUP_CAMERA_SERIAL}"' \
                                hand_camera_serial:='"${HAND_CAMERA_SERIAL}"' '

xhost -local:root
