#!/bin/bash

if [[ $(id -u) -ne 0 ]]
then
    echo "Must be run as root"
    exit 1
fi

if [[ ! -e scripts/code-build.sh ]]
then
    echo "Must be run in phase2 repository directory"
    exit 1
fi

source "scripts/variables.sh"

# Save all output to output.txt
exec >> >(tee output.txt)
exec 2>&1

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
