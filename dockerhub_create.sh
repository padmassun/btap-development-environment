#!/bin/bash
linux_home_folder=/root
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
this_user=$(whoami)
container_name=btap_dev
dockerhub_image=phylroy/btap-development-environment
echo $this_user
echo using  X server at this IP $x_display
echo docker create -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$this_user:$linux_home_folder/windows-host --name $container_name $dockerhub_image
docker create -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$this_user:$linux_home_folder/windows-host --name $container_name $dockerhub_image
