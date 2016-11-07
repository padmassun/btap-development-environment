#!/bin/bash
linux_home_folder=/home/nrcan
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
this_user=$(whoami)
container_name=dockerhub_btap_dev_container
dockerhub_image=phylroy/btap-development-environment
echo Windows users $this_user was detected.
echo using  X server at this IP $x_display:0.0 . 
echo docker create -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$this_user:$linux_home_folder/windows-host --name $container_name $dockerhub_image
docker rm $container_name
docker create -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$this_user:$linux_home_folder/windows-host --name $container_name $dockerhub_image
echo Container r to last clean build
