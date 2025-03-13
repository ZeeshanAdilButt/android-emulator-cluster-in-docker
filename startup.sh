#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <number_of_containers>"
    echo "Example: $0 5"
    exit 1
fi

# Get number of containers from first argument
NUM_CONTAINERS=$1

# Base host ports
BASE_VNC_PORT=6080
BASE_ADB_PORT=5555
BASE_SELENIUM_PORT=4444

memoryLimit="2950m"    # 2560 MB limit
cpuLimit="1.0"         # 1 CPU
memoryswap="10240m"    # 10240 MB swap

for ((i=0; i<NUM_CONTAINERS; i++)); do
    VNC_PORT=$((BASE_VNC_PORT + i))
    ADB_PORT=$((BASE_ADB_PORT + i))
    SELENIUM_PORT=$((BASE_SELENIUM_PORT + i))
    CONTAINER_NAME="device-${i}-android-cluster"
    
    echo "Starting container ${CONTAINER_NAME} with VNC port ${VNC_PORT}, ADB port ${ADB_PORT} and Selenium port ${SELENIUM_PORT}..."
    
    docker run -d \
        --restart always \
        -p ${VNC_PORT}:6080 \
        -p ${SELENIUM_PORT}:4444 \
        -p ${ADB_PORT}:5555 \
        -e EMULATOR_DEVICE="Nexus 4" \
        -e WEB_VNC=true \
        -e DEBUG=true \
        --device /dev/kvm:/dev/kvm \
        --name ${CONTAINER_NAME} \
        zee-docker-android-persist
done

echo "All containers started."