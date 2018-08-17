#/bin/bash
export AWS_ACCESS_KEY_ID=<write_access_key_here>
export AWS_SECRET_ACCESS_KEY=<write_secret_access_key_here>
VERSION=2.4.3
EXTENSION=nrcan-dl-rc0
TAG=$VERSION-$EXTENSION
SERVER_BRANCH=pad_nrcan_2.4.3
# if the SERVER_SHA is left as '', the server corresponding to the
# latest commit on that branch will be made
SERVER_SHA=''

read -p "Docker Username:" DOCKER_USER_ID
read -s -p "Docker Password:" DOCKER_PASSWORD
echo

sudo apt-get update
sudo apt-get -y install python python-pip docker wget ruby apt-transport-https ca-certificates curl software-properties-common

#docker install
sudo apt-get -y remove docker docker-engine docker.io
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


#Packer
wget https://releases.hashicorp.com/packer/1.1.3/packer_1.1.3_linux_amd64.zip
wget http://s3.amazonaws.com/openstudio-resources/server/api/v3/amis.json
unzip packer_1.1.3_linux_amd64.zip -d packer
sudo mv packer/packer /usr/local/bin

#Build Server
git clone https://github.com/NREL/OpenStudio-server.git -b $SERVER_BRANCH
cd OpenStudio-server

if [ $SERVER_SHA -ge 5 ]
then
    git checkout $SERVER_SHA
fi

sudo docker-compose build

#Update Docker Hub
RSERVERID=`sudo docker images | awk '$1 ~ /nrel\/openstudio-rserve/ { print $3 }'`
OSSERVERID=`sudo docker images | awk '$1 ~ /nrel\/openstudio-server/ { print $3 }'`
sudo docker tag $RSERVERID canmet/openstudio-rserve:$TAG
sudo docker tag $OSSERVERID canmet/openstudio-server:$TAG
sudo docker login -u $DOCKER_USER_ID -p $DOCKER_PASSWORD
sudo docker push canmet/openstudio-rserve:$TAG
sudo docker push canmet/openstudio-server:$TAG

#Create Amazon AMI
cd ci/gitlab
sudo pip install -r requirements.txt
cp ../../docker/deployment/openstudio_server_docker_base.json .
cp ../../docker/deployment/user_variables.json.template .


sudo -E python build_deploy_ami.py -o ~/ -n 'Development Build of CANMETEnergy.' -v --generated_by 'CanmetENERGY' --ami_version $VERSION --ami_extension $EXTENSION --dockerhub_repo 'canmet' --write_json --enable_custom_build
