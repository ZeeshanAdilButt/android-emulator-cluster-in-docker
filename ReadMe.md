# Ubuntu Server Setup Script

This repository contains scripts to automate the setup and configuration of Ubuntu servers with enhanced system monitoring, optimized swap memory, and Docker installation.

## 🚀 Features

- System monitoring tools installation
- Configurable swap memory setup (200GB)
- Docker installation and configuration
- Container cleanup utilities
- Android emulator cluster setup

## 📋 Prerequisites

- Ubuntu Server (18.04 LTS or newer)
- Root or sudo privileges
- Internet connection for package downloads

## 🔧 Initial Server Setup

### System Monitoring Tools

```bash
# Update package index
sudo apt-get update

# Install monitoring utilities
sudo apt install htop nmon glances nethogs iftop
```

### Swap Memory Configuration (200GB)

```bash
# Check current swap configuration
sudo swapon --show

# Turn off any existing swap
sudo swapoff -a

# Create a 100GB swap file
sudo fallocate -l 100G /swapfile
# Alternative if fallocate doesn't work:
# sudo dd if=/dev/zero of=/swapfile bs=1G count=100

# Set correct permissions
sudo chmod 600 /swapfile

# Format as swap
sudo mkswap /swapfile

# Enable the swap
sudo swapon /swapfile

# Make it permanent (add to fstab)
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Docker Installation

```bash
# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package index again
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation
sudo docker run hello-world
```

### Clean Docker Environment (Optional)
```bash
# Remove all containers
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
```

## 📁 Android Emulator Setup

Clone the Android Emulator Cluster repository:

```bash
cd /opt
git clone https://github.com/ZeeshanAdilButt/android-emulator-cluster-in-docker.git
cd /opt/android-emulator-cluster-in-docker
```

### Directory Structure and File Setup

Set execute permissions for all script files:

```bash
# Docker files
cd /opt/android-emulator-cluster-in-docker/docker-files
chmod +x dockerfile
chmod +x run.sh

# Main scripts
cd /opt/android-emulator-cluster-in-docker
chmod +x startup.sh
chmod +x soft-restart.sh

# Danger zone scripts
mkdir -p /opt/android-emulator-cluster-in-docker/danger
cd /opt/android-emulator-cluster-in-docker/danger
chmod +x cleanup.sh
chmod +x restart.sh
cd .. 
cd .. 
```

## 📊 System Monitoring Tools

The script installs the following monitoring utilities:

- **htop**: Interactive process viewer
- **nmon**: Performance monitoring tool
- **glances**: System monitoring tool with web interface
- **nethogs**: Net top tool grouping bandwidth per process
- **iftop**: Display bandwidth usage on an interface


## 🚀 Building and Running the Cluster

After completing all the setup steps above, you can build and run the Android emulator cluster:

### Building the Docker Image
```bash
cd /opt/android-emulator-cluster-in-docker/docker-files
docker build -t zee-docker-android-persist .
```

### Starting Containers
```bash
cd /opt/android-emulator-cluster-in-docker
./startup.sh {number of devices}
```

### Maintenance Operations

#### Soft Restart (Preserves Containers)
When you need to restart containers without removing them:
```bash
cd /opt/android-emulator-cluster-in-docker
./soft-restart.sh {container ids failing on emulator } - happens when the resources are not shared equally

# soft restart devices only if needed
./soft-restart.sh 8,26,31,29,27,20,21
```

#### Container Cleanup (Danger Zone)
To remove containers and perform cleanup:
```bash
cd /opt/android-emulator-cluster-in-docker/danger
./cleanup.sh {container ids failing on emulator }
```

#### Hard Restart (Danger Zone)
To perform a complete reset and fresh restart of all containers:
```bash
cd /opt/android-emulator-cluster-in-docker/danger
./restart.sh {container ids failing on emulator }

# recreate devices
./cleanup.sh 8,26,31,29,27,20,21
./restart.sh 8,26,31,29,27,20,21
```

### Monitoring Running Containers
```bash
docker ps
```

### Accessing Container Logs
```bash
docker logs [container_id]
```

### Accessing a Container Shell
```bash
docker exec -it [container_id] /bin/bash
```

### Monitoring Running Containers
```bash
docker ps
```

### Accessing Container Logs
```bash
docker logs [container_id]
```

### Accessing a Container Shell
```bash
docker exec -it [container_id] /bin/bash
```

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.