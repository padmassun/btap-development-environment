#!/bin/bash
linux_home_folder=/home/nrcan
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
win_user=$(whoami)
container=dockerhub_btap_dev_container
image=phylroy/btap-development-environment
echo Windows users $win_user was detected.
echo using  X server at this IP $x_display:0.0 . 
echo docker create -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$win_user:$linux_home_folder/windows-host --name $container $image
docker rm $container
docker create -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$win_user:$linux_home_folder/windows-host --name $container $image
echo Container has been deleted if it existed,  and recreated from last image.
