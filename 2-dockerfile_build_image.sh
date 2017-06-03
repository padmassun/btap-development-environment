#!/bin/bash
source ./env.sh

#docker build --build-arg DISPLAY=$x_display:0.0 -t $image .
echo $canmet_server_folder
#ls $canmet_server_folder
if test -d "$canmet_server_folder" ;
then
    echo "Found Canmet folder."
    echo "Saving Image to Canmet folder $canmet_server_folder"
	docker save -o '$canmet_server_folder/btap-DE.img' $image
fi

