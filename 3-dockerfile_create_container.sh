#!/bin/bash
source ./env.sh
container=$1
if [ $machine == "MinGw" ]
then
	echo Windows users $win_user was detected.
	echo using  X server at this IP $x_display:0.0 .
	echo docker create -ti -e DISPLAY=$x_display:0.0 -v//c/Users/$win_user:$linux_home_folder/windows-host --name $container $image
	docker create -ti -e DISPLAY=$x_display:0.0 -v//c/Users/$win_user:$linux_home_folder/windows-host --name $container $image
elif [ $machine == "Linux" ]
then 
	echo Linux home folder $HOME was detected.
	echo X server DISPLAY is  $x_display
	echo docker create -ti -e DISPLAY=$x_display -v/$HOME:$linux_home_folder/linux-host --name $container $image
	docker create -ti -e DISPLAY=$x_display -v/$HOME:$linux_home_folder/linux-host --name $container $image
fi
echo Container has been deleted if it existed,  and recreated from last image.
