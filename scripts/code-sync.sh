#!/bin/bash

if [[ ! -e scripts/code-sync.sh ]]
then
    echo "Must be run in phase2 repository directory"
    exit 1
fi

echo "************************************************************"
echo "Syncing smaccmbuild"
echo "************************************************************"

cd smaccmpilot-build
git pull
cd ..

echo "************************************************************"
echo "Syncing camkes"
echo "************************************************************"

cd camkes
repo sync
