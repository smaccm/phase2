#!/bin/bash

if [[ ! -e scripts/code-sync.sh ]]
then
    echo "Must be run in phase2 repository directory"
    exit 1
fi

echo "************************************************************"
echo "Syncing to latest version of code"
echo "************************************************************"

cd smaccmpilot-build
git pull
cd ..

cd camkes
repo sync
