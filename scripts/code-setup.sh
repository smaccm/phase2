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

git checkout feature/tower9
git submodule update --init
cd smaccmpilot-stm32f4/src/smaccm-flight/
echo "RAMSES_PATH=$BASE_DIR/ramses-demo" > RAMSES_PATH.mk
make create-sandbox
mkdir $ODROID_APP_NAME
cd $BASE_DIR

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

rm apps/can_proxy_odroid_test
ln -s $BASE_DIR/smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-flight/$ODROID_APP_NAME apps/$ODROID_APP_NAME
