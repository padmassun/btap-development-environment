#!/bin/bash
docker rm btap_dev
docker load -i //s-bcc-nas2/Groups/Common\ Projects/HB/dockerhub_images/btap-DE.img
              # //s-bcc-nas2/Groups/Common Projects/HB/dockerhub_images/btap-DE.img
./dockerhub_create.sh
