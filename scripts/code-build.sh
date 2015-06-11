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
#cabal run $TOWER_APP_NAME -- --src-dir=$ODROID_APP_NAME
cabal run $TOWER_APP_NAME -- --src-dir=$ODROID_APP_NAME --lib-dir=ivory_serial
make -C $ODROID_APP_NAME
cd $ODROID_APP_NAME
sed -i.old 's/.*void callback_/\/\/ callback_/' $(find . -name "smaccm_*.h")
cd ../../..

echo "************************************************************"
echo "Build kernel image via camkes"
echo "************************************************************"

cabal info mtl

cd camkes
ln -s ../../smaccmpilot-build/tower-camkes-odroid/smaccmpilot/libivory_serial libs/libivory_serial
make ${ODROID_APP_NAME}_defconfig
make

cd images
if [[ -e capdl-loader-experimental-image-arm-exynos5 ]]
then
    mkimage -a 0x48000000 -e 0x48000000 -C none -A arm -T kernel -O qnx -d capdl-loader-experimental-image-arm-exynos5 odroid-image
fi

if [[ ! -e odroid-image ]]
then
    echo "Failed to build odroid-image"
    exit 1
fi

echo "************************************************************"
echo "Odroid image: $PWD/odroid-image"
echo "************************************************************"
