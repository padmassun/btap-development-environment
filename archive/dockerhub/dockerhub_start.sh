linux_home_folder=/root
x_display=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}')
this_user=$(whoami)
container_name=btap_dev
dockerhub_image=phylroy/btap-development-environment
docker start btap_dev
