#!/bin/bash 
REPOSRC=https://github.com/NREL/openstudio-standards.git
LOCALREPO=/tmp/openstudio-standards/

# We do it this way so that we can abstract if from just git later on
LOCALREPO_VC_DIR=$LOCALREPO/.git

if [ ! -d $LOCALREPO_VC_DIR ]
then
    git clone $REPOSRC $LOCALREPO
else
    cd $LOCALREPO
    git pull $REPOSRC
fi
cd /tmp/openstudio-standards/openstudio-standards 
git checkout nrcan 
bundle install
bundle exec rake install
