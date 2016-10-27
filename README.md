# NRCan's BTAP Development Environment

This image, is based upon the NREL's [nrel/openstudio](https://hub.docker.com/r/nrel/openstudio/) docker container. It contains a consistent development environment that runs the latests versions of OpenStudio, E+ and PAT, as well as two IDEs that are popular at NRCan. This also allows NRCan staff to write helper scripts based on this environment.   

 * [Visual Studio Code]()
 	* With Ruby extentions pre-installed.
 * [NetBeans]()
 	* With Ruby plugin ready to be installed by user. (could not automate this)  


## Requirements
* Windows 7+ 64 bit with a modern >=i5 computer with >=8GB RAM recommended
* Enabling virutalization in your BIO (Instructions [here](https://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html))
* Admin rights
* Install [Docker Toolbox for Windows](https://docs.docker.com/toolbox/toolbox_install_windows/)
* Install [Xmin X11 server](http://sourceforge.net/projects/xming/files/Xming/6.9.0.31/Xming-6-9-0-31-setup.exe/download)



## Setup

### Clone Repository
1. Launch the Docker Quickstart Terminal (as seen in install instructions)
2. Make a projects folder in your C:\Users\username folder then go into it.
```bash
mkdir /c/Users/$(whoami)/projects && cd /c/Users/$(whoami)/projects

```
3.    Clone this rep and then enter that folder.
```bash
git clone https://github.com/phylroy/btap-development-environment.git && cd btap-development-environment
```

## Usage
### Always start Xming before anything.
You can do this by running this from your Terminal
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./startx.sh
```

### Build Fresh Environment from DockerHub
This will erase ALL of your previous containers and download a freash new copy of the BTAP-DE. Careful this will erase your previous instance and all files that are in the image. This will also take a long time depending on your internet connection (If you are at BCC...it could take an hour or two)

```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./dockerhub_create.sh
```

### Start the Environment
This will launch the container and launch the Terminator Bash Shell.
```bash

```

### Optional: Revert Environment
You screwed up your environment...No problem! This will revert your BTAP-DE environment to the state is was in when it was new. Careful this will erase your previous instance and all files that are in the image. Note this will not update to the most recent version.  
1. Ensure you have Xming Running
```bash
./dockerhub_revert.sh
```
