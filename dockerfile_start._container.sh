#!/bin/bash
linux_home_folder=/home/nrcan
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
win_user=$(whoami)
container=dockerfile_btap_dev_container
image=dockerfile_btap_dev_image

echo Windows users $win_user was detected.
echo using  X server at this IP $x_display:0.0 . 

docker start $container 
echo Container $container started.
