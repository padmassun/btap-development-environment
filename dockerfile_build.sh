#!/bin/bash
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
container_name=dockerfile_btap_dev
docker build --build-arg DISPLAY=$x_display:0.0 -t $container_name .
