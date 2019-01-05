#!/bin/bash

# Load environment vars
source ./config.sh

# Increment ports on nginx config
mkdir -p ./workspace
cp /etc/nginx/sites-available/default ./workspace/default
(cat ./workspace/default | $PYTHON ./utility/nginx_increment_ports.py) > /etc/nginx/sites-available/default

rm -f ./workspace/removecontainers
#rm -f ./workspace/removeimages # TODO - Seem to be able to rebuild image and use same id

# for each of our containers
for hostConfig in ./configHosts/*; do
    source $hostConfig

    # Get existing container and image to be removed
    (docker ps -a | grep ${NAME} | $PYTHON ./utility/docker_containerid.py) > ./workspace/removecontainers
    #(docker images | grep ${NAME} | $PYTHON ./utility/docker_imageid.py) > ./workspace/removeimages

    # Build & run container and use new port
    ./utility/clone_build_run.sh
done

# Reload nginx (as config now pointed at new containers)
sudo systemctl reload nginx

# Wait 60s (for nginx to drain existing connections with old containers)
echo "Waiting 60s before stopping old containers, please wait..."
sleep 60
echo "Stopping old containers..."

# Stop and remove old containers
while read containerId; do
    if [ ! -z $containerId ]; then
        echo "Removing container $containerId"
        docker rm --force $containerId
    fi
done < ./workspace/removecontainers

# Stop and remove old images
# while read imageId; do
#     if [ ! -z $imageId ]; then
#         echo "Removing image $imageId"
#         docker rmi --force $imageId
#     fi
# done < ./workspace/removeimages
