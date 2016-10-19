#!/bin/bash
docker build --build-arg DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 -t openstudio-dev .
