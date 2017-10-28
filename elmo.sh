#!/bin/bash
source ./env.sh
#ssh -YC -o SendEnv=DISPLAY 132.156.197.127
echo $DISPLAY
echo "Run this command from Elmo first to enable X for docker!!!"
echo "export DISPLAY=$DISPLAY"
ssh -YC 132.156.197.127 
