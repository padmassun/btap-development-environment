# btap_utilities
Helper files for the BTAP development environment

## Creating an OpenStudio-Server AMI
To create an AMI of OpenStudio Server, Create a new Ubuntu instance on Amazon with atleast 2 (4 recommended) from the `c` series (e.g. `c5.xlarge`). Atleast make sure that there is enough disk space.

Copy `create_ami_image_on_aws.sh` file from this repo over to that instance, and edit `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `VERSION`, `EXTENSION`, `SERVER_BRANCH`, and `SERVER_SHA`. Then execute the script. When prompted for docker username and password, enter them as requested. 
