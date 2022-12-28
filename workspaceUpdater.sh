#!/bin/bash
# This script will go through every directory in your workspace 
# and perform a git pull on the chosen branch so that everything is up to date.

# Set variables
WORKSPACE="~/Workspace"
BRANCH="master"

# Change directory to the desired workspace
cd $WORKSPACE

# Get the number of repos 
var=$(ls | wc -l | awk '{$1=$1};1')
DIRs=$(($var+1))

# Set the counter and start looping through the repos and updating them with git pull
COUNTER=1
while [  $COUNTER != $DIRs ]; do
    CURRENT_DIR=$(ls | sed -n "$COUNTER"p)
    cd $CURRENT_DIR
    echo "[DEBUG] Current dir is $CURRENT_DIR"
    git checkout $BRANCH
    git pull
    cd ..
    let COUNTER=COUNTER+1 
done
