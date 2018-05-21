#!/bin/bash
os_version=2.4.1
image=canmet/btap-development-environment:$os_version
canmet_server_folder=//s-bcc-nas2/Groups/Common\ Projects/HB/dockerhub_images/

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}


if [ $machine == "MinGw" ]
	then
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
	host_ip=$(wmic NICCONFIG WHERE DHCPEnabled=true Get IPAddress | gawk 'match($0,  /^{"(.*)",.*"}/, a) { print a[1] }' |  sed -n 1p)
	host_name=$(ipconfig //all | grep -m 1 "Host Name" | awk '{print $NF}')
	domain=$(ipconfig //all | grep -m 1 "Primary Dns Suffix" | awk '{print $NF}')
	if [ $domain == ":" ]
	then
		echo "Domain could not be determined. Using IP address $host_ip instead."
		x_display=$host_ip:0.0
	else
		x_display=$host_name.$domain:0.0
		echo "Host and Domain found to be: $x_display"
	fi
	#set your DISPLAY to what it should be
	export DISPLAY=$x_display
elif [ $machine == "Linux" ]
	then
	if [[ -z "${DISPLAY}" ]] 
	then
		echo "DISPLAY env variable is not set up for your linux environment. X may not be availble"
	else
		x_display=$DISPLAY
	fi
	if [ -n "$SSH_CLIENT" ]
	then
		echo found logging in through ssh. Will need to pass SSH client IP instead. 
		x_display=$(echo $SSH_CLIENT | awk '{ print $1}'):0
	fi
fi
linux_home_folder=/home/osdev

if [ "`whoami | grep +`" == "" ]
then
    win_user=$(whoami)
else
    # Specific case for Jeff's machine (whoami = W-BSC-A107313+jeffblake)!
	win_user=jeffblake
    x_display=$(ipconfig | grep -m 3 "IPv4" | tail -1 | awk '{print $NF}')
	export DISPLAY=$x_display:0.0
fi

echo "Windows User: $win_user"
echo "host_ip: $host_ip"
echo "Windows Hostname: $host_name"
echo "windows domain name: $domain"
echo "X server IP: $x_display"
echo "image name: $image"


