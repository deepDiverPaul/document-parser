#!/bin/sh

# Check lockfile
if [ -f index.lock ]
then
    echo "----- Script is already running -----"
    exit
fi

echo  "----- Start -----"

date +%s > index.lock

# Update index
recollindex

rm index.lock

echo  "----- Finish -----"
