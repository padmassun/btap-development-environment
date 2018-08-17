## Documentation of automating the update process of necb test and data viz.

The purpose of this document is to explain the automation processess of
+ running NECB standards' QAQC (Quality Assurance, Quality Control) tests to generate the simulations.json, and
+ have the latest parallel coordinate data viz running on Elmo.

New results for NECB test and data viz has to be updated everyday. The NECB test should run if the repository gets updated.
This processess should start even if Elmo is has been restarted.

Every time Elmo is restarted, it should start the docker container for the data viz and NECB test container. This can be achieved by writing a script that will update and start and update the docker containers. This script will get executed by cron when Elmo is restarted. This is done by adding the following line to the file after executing `crontab -e`, where `/home/nrcan/after_reboot.sh` is the absolute path of the script file to be executed.

```shell
@reboot /home/nrcan/after_reboot.sh
```
The following script will stop and erase all the docker containers and recreate the dataviz and necb test container.

```shell
#stop and erase all the docker containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
# navigate to the root of the data viz directory and update the repository
cd ~/parallel-coordinates/ && git pull
# build the container fron scratch
docker build -t nodeserver .
#map the port to 8080 and run the node server
docker run -d -p 8080:8080 --name node nodeserver
cd ~/projects/btap-test-necb
#pull the latest canmet/btap-test-necb image from docker hub, and run it
docker run --name necb -d -it canmet/btap-test-necb
```

Source:
+ NECB test container: https://github.com/canmet-energy/btap-test-necb
  * The NECB test container has an inside cron job that runs the necb tests everyday at 6PM if the Openstudio-Standards repository gets updated
+ Data viz: https://github.com/canmet-energy/parallel-coordinates
