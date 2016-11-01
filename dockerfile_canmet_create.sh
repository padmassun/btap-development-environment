#!/bin/bash
#docker rm btap_dev
docker load -i //s-bcc-nas2/Groups/Common\ Projects/HB/dockerhub_images/btap-DE.img
./dockerfile_create_container.sh
