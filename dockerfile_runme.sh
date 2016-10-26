#!/bin/bash
linux_home_folder=/root
this_user=$(whoami)
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
container_name= dockerfile_btap_dev
echo $this_user
echo $x_display
echo docker run -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$this_user:$linux_home_folder/windows-host $container_name
docker run -ti -e DISPLAY=$x_display:0.0 -v/c/Users/$this_user:$linux_home_folder/windows-host $container_name
