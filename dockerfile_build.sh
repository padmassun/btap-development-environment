#!/bin/bash
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
docker build --build-arg DISPLAY=$x_display:0.0 -t dockerfile_btap_dev .
