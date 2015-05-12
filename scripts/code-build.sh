#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

source "variables.sh"
cd ..

echo "************************************************************"
echo "Build smaccmpilot"
echo "************************************************************"

cd smaccmpilot-build/tower-camkes-odroid
cabal run serial-test -- --out-dir=$ODROID_APP_NAME
make -C $ODROID_APP_NAME
cd ../..

echo "************************************************************"
echo "Build kernel image via camkes"
echo "************************************************************"

cd camkes
make

cd images
mkimage -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel -O qnx -d capdl-loader-experimental-image-arm-exynos5 odroid-image

if [[ ! -e odroid-image ]]
then
    echo "Failed to build odroid-image"
    exit 1
fi

echo "************************************************************"
echo "Odroid image: $PWD/odroid-image"
echo "************************************************************"
