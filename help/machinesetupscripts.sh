# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# mkdir -p /opt/docker-android/docker && chmod -R 777 /opt/docker-android/docker && for i in {0..39}; do mkdir -p "/opt/docker-android/device-${i}-android-cluster" && chmod -R 777 "/opt/docker-android/device-${i}-android-cluster"; done

# Create the docker-android directory
mkdir docker-android

# Verify the directory has been created
ls

# move to docker android folder
cd /opt/docker-android

#created docker directory and move to it
mkdir docker
cd docker

# remove any existing docker file and create new one with permission and paste the correct docker file
rm dockerfile
touch dockerfile
chmod +x dockerfile
vi dockerfile

## remove any existing run file and create new one with permission and paste the correct run file needed by docker file
rm run.sh
touch run.sh
chmod +x run.sh
vi run.sh

cd docker-files
# build the image to be used by docker container
docker build -t zee-docker-android-persist .
cd ..

# remove any existing startup file and create new one with permission and paste the correct staartup file
rm startup.sh
touch startup.sh
chmod +x startup.sh
vi startup.sh


# remove any existing soft-restart file and create new one with permission and paste the correct soft-restart file -- used to restart the container without removing them
touch soft-restart.sh
chmod +x soft-restart.sh
vi soft-restart.sh

# make a danger directory that contains script to clean up and restart containers after removing
mkdir danger
cd danger


# remove any existing cleanup file and create new one with permission and paste the correct cleanup file
rm cleanup.sh
touch cleanup.sh
chmod +x cleanup.sh
vi cleanup.sh

# remove any existing cleanup file and restart (hard) new one with permission and paste the correct restart (hard) file
rm restart.sh
touch restart.sh
chmod +x restart.sh
vi restart.sh

cd ..
# back from danger in the docker-android directory so you can run the related commands


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#scripts
#fresh start
#remove all containers
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
./startup.sh 30

# move to docker android folder
cd /opt/docker-android

#initial start
./startup.sh 25

#connect adb on upto 40 devices  - not all machines run 40 devices so it will connect to first x devices which were run as per above script
for i in {5555..5594}; do adb connect localhost:$i; done

adb devices


# soft restart devices only if needed
./soft-restart.sh 8,26,31,29,27,20,21


# DANGER

# recreate devices
./cleanup.sh 8,26,31,29,27,20,21
./restart.sh 8,26,31,29,27,20,21