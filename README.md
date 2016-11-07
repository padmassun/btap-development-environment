# BTAP Development Environment

This image, is based upon the NREL's [nrel/openstudio](https://hub.docker.com/r/nrel/openstudio/) docker container. It contains a consistent development environment that runs the latests versions of OpenStudio, E+ and PAT, as well as two IDEs that are popular at NRCan. This also allows NRCan staff to write helper scripts based on this environment. This environment will allow you to do a few things, create all the NECB archetype, run analysis on OS server cluster, generate geometery from eQuest files, add archetypes to our development and other things. 

 * [Visual Studio Code]()
 	* With Ruby extentions pre-installed.
 * [NetBeans]()
 	* With Ruby plugin ready to be installed by user. (could not automate this)  


## Requirements
* Windows 7+ 64 bit with a modern >=i5 computer with >=8GB RAM recommended
* Enabling virutalization in your BIO (Instructions [here](https://docs.fedoraproject.org/en-US/Fedora/13/html/Virtualization_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html))
* Admin rights
* Install [Docker Toolbox for Windows](https://docs.docker.com/toolbox/toolbox_install_windows/)
* Install [Xming v6 X11 server](http://sourceforge.net/projects/xming/files/Xming/6.9.0.31/Xming-6-9-0-31-setup.exe/download) Note: If you wish to use electron applications like Slack, Visual Studio Code, you will need the donation verion of [Xming v7.7+](http://www.straightrunning.com/XmingNotes/#head-16) 


# Creating a Workspace in 5 Steps

## Step 0 Clone Repository

1. Launch the Docker Quickstart Terminal (as seen in install instructions)
2. Make a projects folder in your C:\Users\username folder then go into it.
```bash
mkdir /c/Users/$(whoami)/projects && cd /c/Users/$(whoami)/projects
```
3.    Clone this rep and then enter that folder.
```bash
git clone https://github.com/phylroy/btap-development-environment.git && cd btap-development-environment
```

## Step 1 Ensure your Environment is Clean

This will erase ALL of your previous containers and download a freash new copy of the BTAP-DE. Careful this will erase all your previous images and containers and start fresh. It will not delete anything in your regular windows folders.
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./1_rm_images_and_containers.sh
```

## Step 2 Create The Docker BTAP-DE Image
This will create the Docker Image used for development.  This may take a long time to build. At BCC this may take up to 4 hours, so you may wish to use the alternative for CanmetEnergy Staff.  Be patient as this will take a long time. 
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./2-dockerfile_build_image.sh
```

## Step 2 Alternative: Fast Method for CANMET Staff
BCC has very slow internet speed. To speed up very long download times, a version of the phylroy/btap-development-environment will be kept on the network drive. The above is the preferred method, but this is faster, but may not be always up to date. This should take 10-15 minutes.
```bash
cd /c/Users/$(whoami)/projects/btap-development-environment && ./2-dockerfile_canmet_fast_build_image.sh
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
After you start the container, you should see a new terminal with a red bar over that top. This is your X terminal called 'terminator this where you can execute linux commands. There are numerous tutorials on the linux console that we will not go into here.
## Windows Interop
The container was set up to be linked to your C:\User\<your windows username> folder on windows. If you perform a directory listing "ls -l" and hit enter you should see a listing of files and folders. One of these folders is called 'windows-host' this is your shared folder to windows.  If you ls that directory, you should see your host windows user folders. The neat thing is that you can interact with that folder like it was a mounted drive.
## Openstudio
OpenStudio is installed in the image, and the default ruby implemenation is linked to OpenStudio as well, so you can run ruby scripts easiy. You may also run OpenStudio by typing the following at the command prompt. The OpenStudio version is the release version. 
```bash
Openstudio &
```
You can run PAT also the same way
```bash
PAT &
```
## Netbeans
Netbeans 8.2 has already been installed. To start Netbeans type the following
```bash
netbeans &
```
### Installing Ruby Support for NetBeans
Ruby support for Netbeans allows you to develop with Ruby and OpenStudio a bit easier. It is not required, but I think it helps. The plugin in needs to be installed by hand every time you reset the container. Luckyly it only takes a few steps.

1. Launch Netbeans and go to Tools->Plugins
2. Click on the Downloaded tab and click 'Add Plugins'
3. Select the "Files of Type" and select 'All Files'
4. Navigate to your home /home/nrcan/ruby_netbeans_plugin
5. Select all .jar and nbm files.
6. Click okay and continue agreeing to all prompts
7. It will ask to restart.


### To-do : cloning the repositories in windows-host
### To-do : Creating an new netbeans project using existing sources
### To-do : Running the NECB archetypes locally
### To-do : Running the NECB archetypes on Amazon
### To-do : Getting OSM files from OS Server using the BTAPResults measure
### To-do : Adding a new NECB archetypes
### To-do : Converting OSM to JSON files
### To-do : Add nginx and mongodb for D3 student work
### To-do : Add equest to osm as part of the btap_utilities

