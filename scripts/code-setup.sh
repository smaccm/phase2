#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

source "variables.sh"
cd ..

BASE_DIR=$PWD

echo "************************************************************"
echo "Get camkes code"
echo "************************************************************"

mkdir camkes
cd camkes
repo init -u https://github.com/smaccm/june-drop-odroid-manifest.git
repo sync

