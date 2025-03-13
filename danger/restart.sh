#!/bin/bash

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <device_numbers>"
    echo "Example: $0 0,5,7,9"
    echo "Example: $0 1"
    exit 1
fi

# Base host ports
BASE_VNC_PORT=6080
BASE_ADB_PORT=5555
BASE_SELENIUM_PORT=4444

# Convert comma-separated list to array
IFS=',' read -ra DEVICE_NUMBERS <<< "$1"

for i in "${DEVICE_NUMBERS[@]}"; do
    # Remove any whitespace
    i=$(echo $i | tr -d ' ')
    
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