#!/bin/bash
#Check if X server is running. 
if [ "`ps | grep Xming`" == "" ]
then
#If not running try to start it. 
if [ -d "/c/Program Files/Xming/" ]
then
  /c/Program\ Files/Xming/Xming.exe -ac -multiwindow -clipboard  -dpi 108 &
elif [ -d "/c/Program Files (x86)/Xming/" ]
then
  /c/Program\ Files\ \(x86\)/Xming/Xming.exe -ac -multiwindow -clipboard  -dpi 108 &
else
	echo "Could not find Xming installed on your system either /c/Program Files/Xming or /c/Program Files (x86)/Xming  . Please install Xming, ideally the donation version in the default location." 
	exit
fi
fi
linux_home_folder=/home/osdev
host_ip=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
host_name=$(ipconfig //all | grep -m 1 "Host Name" | awk '{print $NF}')
domain=$(ipconfig //all | grep -m 1 "Primary Dns Suffix" | awk '{print $NF}')
x_display=$host_name.$domain
win_user=$(whoami)
image=canmet/btap-development-environment:2.2.1
canmet_server_folder=//s-bcc-nas2/Groups/Common\ Projects/HB/dockerhub_images/
echo "Windows User: $win_user"
echo "Windows Hostname: $host_name"
echo "X server IP: $x_display"
echo "image name: $image"

