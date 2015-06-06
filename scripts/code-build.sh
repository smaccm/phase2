#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

source "variables.sh"
cd ..

cd camkes
make vm_defconfig
make

cd images
ls
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
