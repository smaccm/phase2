#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

cd ..
BASE_DIR=$PWD
set -e

if [[ $TRAVIS != "true" ]] && [ -e "PATH" ];
then
    export PATH=`cat PATH`
fi


echo "************************************************************"
echo "Get smaccmpilot code"
echo "************************************************************"

git clone https://github.com/GaloisInc/smaccmpilot-build.git
cd smaccmpilot-build

echo "************************************************************"
echo "Configure smaccmpilot code"
echo "************************************************************"

git submodule update --init
cd smaccmpilot-stm32f4/src/smaccm-flight
make create-sandbox
cd $BASE_DIR

echo "************************************************************"
echo "Get camkes code"
echo "************************************************************"

mkdir camkes
cd camkes
repo init -u https://github.com/smaccm/june-drop-odroid-manifest.git -m phase2.xml || true
repo sync || true

cd apps
echo "RAMSES_PATH=$BASE_DIR/ramses-demo" > RAMSES_PATH.mk

