# BTAP Development Environment

This image, is based upon the NREL's [nrel/openstudio](https://hub.docker.com/r/nrel/openstudio/) docker container. It contains a consistent development environment that runs the latests versions of OpenStudio and E+.This also allows NRCan staff to write helper scripts based on this environment. This environment will allow you to do a few things, create all the NECB archetype, run analysis on OS server cluster, generate geometery from eQuest files, add archetypes to our development and other things. 


## Requirements
* Windows 7+ 64 bit with a modern >=i5 computer with >=8GB RAM recommended
* Enabling virutalization in your BIO (Instructions [here](https://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html)) If you have an HP Z system like a lot of NRCan people do Enable Virtualization Technology (VTx) option when you boot your system. Hit F10 when you start your computer. In setup under Security > System Security Menu enable all VTx options. Note:Every Computer BIOS is different. It may be under advaced. Please refer to your bios manual for specific details.. Turn all virtual switch on to be consistant if there are more than one. 
* Admin rights
* Install [Docker Toolbox for Windows](https://docs.docker.com/toolbox/toolbox_install_windows/)
* Install [Xming v6 X11 server](http://sourceforge.net/projects/xming/files/Xming/6.9.0.31/Xming-6-9-0-31-setup.exe/download) Note: If you wish to use electron applications like Slack, Visual Studio Code, you will need the donation version of [Xming v7.7+](http://www.straightrunning.com/XmingNotes/#head-16) 


# Creating a Workspace in 5 Steps

## Step 0 Clone Repository

1. Launch the Docker Quickstart Terminal (as seen in install instructions)
2. Make a projects folder in your C:\Users\username folder then go into it.
```bash
mkdir /c/Users/$(whoami)/projects && cd /c/Users/$(whoami)/projects
```
3.    Clone this rep and then enter that folder.
```bash
git clone https://github.com/canmet-energy/btap-development-environment.git && cd btap-development-environment
```
4. switch to the branch name that matches the version of OpenStudio you wish to use. For example for version 2.8.1 issue this command to switch to that branch. 
```bash
git checkout 2.8.1
```

## Step 1 Ensure your Environment is Clean

This will erase ALL of your previous containers and download a freash new copy of the BTAP-DE. Careful this will erase all your previous images and containers and start fresh. It will not delete anything in your regular windows folders.
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./1_rm_images_and_containers.sh
```

## Step 2 Create The Docker BTAP-DE Image
This will create the Docker Image used for development.  This may take a long time to pull. At BCC this may take up to 4 hours, so you may wish to use the alternative for CanmetEnergy Staff.  Be patient as this will take a long time. 
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./2-dockerfile_pull_image.sh
```

## Step 3 Create a workspace container
This will create a container that you can do development in. You can create many containers based on the image that we created above. We will call this container *my_workspace*
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./3-dockerfile_create_container.sh my_workspace
```
## Step 4 Start Your Container
You can now just start your container by your container name, in this case it is *my_workspace*
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./4-dockerfile_start_container.sh my_workspace
```
# Basic Usage
After you start the container, your bash prompt should change to reflect that you are 'in' the container. To start a nice x terminal, type: 
```bash
terminator
```
This will start the terminator terminal. This is your X terminal called 'terminator this where you can execute linux commands. There are numerous tutorials on the linux console that we will not go into here.

## Windows Interop
The container was set up to be linked to your C:\Users\<your windows username> folder on windows. If you perform a directory listing "ls -l" and hit enter you should see a listing of files and folders. One of these folders is called 'windows-host' this is your shared folder to windows.  If you ls that directory, you should see your host windows user folders. The neat thing is that you can interact with that folder like it was a mounted drive. You cannot access your full windows systems the way the container is currently implemented. 

## Openstudio
OpenStudio is installed in the image, and the default ruby implemenation is linked to OpenStudio as well, so you can run ruby scripts easiy. You may also run OpenStudio by typing the following at the command prompt. The OpenStudio version is the release version. 
```bash
OpenStudioApp &
```
## OpenStudio CLI
You can run the openstudio cli by running
```bash
openstudio
```
## EnergyPlus is also available as
```bash
energyplus
```
## R 
The R language is also installed with some common NREL plugings used for buildings. 

## Nodejs
Node JS is installed and npm. 

## Sqlite with json support is installed. 

# Editors
Originally I added Netbeans and VSCode to the image. This took too much effort to maintain and made the image large. 

## nano and vim
Nano, Vim and XEmacs have been installed by default.  If you wish to install other editors. 

## Git Shortcuts for development
To checkout copies of development and make things a bit easier (in your ~/.gitconfig file)
  os = clone https://github.com/NREL/OpenStudio.git
  os-standards = clone https://github.com/NREL/openstudio-standards.git
  os-ptool =clone https://github.com/NREL/OpenStudio-PTool.git
  os-measures = clone https://github.com/NREL/OpenStudio-measures.git
  os-spreadsheet = https://github.com/NREL/OpenStudio-analysis-spreadsheet.git
  nrcan-ptool = clone https://github.com/phylroy/OpenStudio-PTool.git
  nrcan-standards = clone https://github.com/NREL/openstudio-standards.git -b nrcan 
  nrcan-measures = clone https://github.com/NREL/OpenStudio-measures.git -b nrcan
So to clone the nrcan-standards branch, you simply type. 
```bash
git nrcan-standards
```
#Troubleshooting
## You see curl failures when building image indicating network certificate failures.
This can be due to network conflicts. This has been observed on Docker for Windows v1.12.3.  One solution found was to change the mtu value to something lower in the docker host container.  You can add this by opening the Docker setting from the tray icon, going to the Docker Deamon tab and add the MTU value like below
```json
{
  "registry-mirrors": [],
  "insecure-registries": [],
  "debug": false,
  "mtu": 1400
}
```
## I only have ~20GB of space in my docker machine..I need more!
The best way to deal with this is to delete the default docker machine and create a new one with the correct size. This procudure will delete all your images and containers..so back up anything that you need! This will create a 100GB disk.  This procudure works only for Docker Toolbox and in the QuickStart Terminal. 
```bash
docker-machine rm default
docker-machine create --driver virtualbox --virtualbox-disk-size "100000" default
docker-machine env default
```

