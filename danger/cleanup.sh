#!/bin/bash

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <device_numbers>"
    echo "Example: $0 17,10,3,11,15"
    echo "This will stop and remove containers with those device numbers, then create new ones"
    exit 1
fi

# Store the device numbers
DEVICE_NUMBERS="$1"

# Convert comma-separated list to array
IFS=',' read -ra DEVICES <<< "$DEVICE_NUMBERS"

for i in "${DEVICES[@]}"; do
    # Remove any whitespace
    i=$(echo $i | tr -d ' ')
    CONTAINER_NAME="device-${i}-android-cluster"
    
    echo "Stopping and removing container ${CONTAINER_NAME}..."
    
    # Stop the container
    docker stop ${CONTAINER_NAME} || echo "Container ${CONTAINER_NAME} not running"
    
    # Remove the container
    docker rm ${CONTAINER_NAME} || echo "Container ${CONTAINER_NAME} not found"
done

echo "All specified containers stopped and removed."

# Call script.sh with the same numbers
echo "Creating new containers..."
./restartscript.sh "$DEVICE_NUMBERS"