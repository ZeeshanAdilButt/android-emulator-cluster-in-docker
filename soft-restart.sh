#!/bin/bash

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <device_numbers>"
    echo "Example: $0 0,5,7,9"
    echo "Example: $0 1"
    exit 1
fi

# Convert comma-separated list to array
IFS=',' read -ra DEVICE_NUMBERS <<< "$1"

for i in "${DEVICE_NUMBERS[@]}"; do
    # Remove any whitespace
    i=$(echo $i | tr -d ' ')
    
    CONTAINER_NAME="device-${i}-android-cluster"
    
    echo "Processing container ${CONTAINER_NAME}..."
    
    # Check if container exists
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "Stopping container ${CONTAINER_NAME}..."
        docker stop ${CONTAINER_NAME}
        
        echo "Restarting container ${CONTAINER_NAME}..."
        docker start ${CONTAINER_NAME}
    else
        echo "Warning: Container ${CONTAINER_NAME} not found!"
    fi
done

echo "All specified containers have been restarted."