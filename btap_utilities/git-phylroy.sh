#!/bin/bash
dropbox.py start 
mkdir ~/.credentials/
cp ~/Dropbox/linux/client_secret.json ~/.credentials/
cp ~/Dropbox/linux/aws_config.yml ~/
dropbox.py stop
git config --global user.email "phylroy.lopez@gmail.com"
git config --global user.name "phylroy"

