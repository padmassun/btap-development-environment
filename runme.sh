#!/bin/bash
this_user=$(whoami)
docker run -ti -e DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 -v/c/Users/$this_user:/home/nrcan/windows-host openstudio-dev
