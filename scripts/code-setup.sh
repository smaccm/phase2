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
echo "Get smaccmpilot code"
echo "************************************************************"

git clone https://github.com/GaloisInc/smaccmpilot-build.git
cd smaccmpilot-build

echo "************************************************************"
echo "Configure smaccmpilot code"
echo "************************************************************"

# git checkout feature/tower9
git checkout red-team-may-2015
git submodule update --init
cd tower-camkes-odroid
echo "RAMSES_PATH=$BASE_DIR/ramses-demo" > RAMSES_PATH.mk
make create-sandbox
mkdir $ODROID_APP_NAME
cd ../..

echo "************************************************************"
echo "Get camkes code"
echo "************************************************************"

mkdir camkes
cd camkes
repo init -u https://github.com/smaccm/june-drop-odroid-manifest.git
repo sync

echo "************************************************************"
echo "Link in the smaccmpilot app"
echo "************************************************************"

rm apps/$ODROID_APP_NAME
ln -s $BASE_DIR/smaccmpilot-build/tower-camkes-odroid/$ODROID_APP_NAME apps/$ODROID_APP_NAME
