# Administrator Tasks

## Standards Project :  Merge with NREL and Submit a Pull Request
First clone a fresh copy from the repository, then switch to the feature branch..in our case nrcan
```bash
git nrcan-standards
git merge origin/master
```
You can list the conflicts using this command.
```bash
git conflicts
```

You can also get a history of what has changed.
```bash
git hist
```
Once all conflicts have been fixed and tests pass, you can push the code and issue a pull request to NREL from the NRCan branch. Instrustions on creating a pull request are [here](https://help.github.com/articles/creating-a-pull-request/).

## Update CanmetENERGY Development
The Image is created updating both the Dockerfile in this repository and the configuration helper items in this repository [here](https://github.com/phylroy/btap_utilities). Once you are satified that your image is up to date execute the following command in the Docker Quickstart Terminal. 
```bash
docker save -o //s-bcc-nas2/Groups/Common\ Projects/HB/dockerhub_images/btap-DE.img dockerfile_btap_dev_image
```
