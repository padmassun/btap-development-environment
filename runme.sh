#!/bin/bash
this_user=$(whoami)
DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
this_user='phylr'
echo $this_user
echo $DISPLAY
echo docker run -ti -e DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 -v/c/Users/$this_user:/home/nrcan/windows-host openstudio-dev
docker run -ti -e DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 -v/c/Users/$this_user:/home/nrcan/windows-host openstudio-dev
