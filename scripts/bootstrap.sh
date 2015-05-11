#!/bin/bash
#
# This is the main build script for the May 15 SMACCM ODROID red team drop.
# Running this script should produce an image for the odroid and an image
# for the pixhawk.
#
# This script should work on Ubuntu 12.04 amd64 server edition with
# at least 20gb hard-drive space
#
# Must be run with sudo. Will display and save output to output.txt
#
###########################################################################

export BUILD_DIR_NAME=smaccmcopter-ph2-build

# Save all output to output.txt
exec > >(tee output.txt)
exec 2>&1

echo "************************************************************"
echo "Get git"
echo "************************************************************"

# Work around Ubuntu APT bug
sudo rm -rf /var/lib/apt/lists/*

sudo apt-get update
sudo apt-get -y install git

echo "************************************************************"
echo "Get phase2 repository"
echo "************************************************************"

git clone https://github.com/smaccm/phase2.git $BUILD_DIR_NAME
cd $BUILD_DIR_NAME

echo "************************************************************"
echo "Call subscript"
echo "************************************************************"

(exec sudo "scripts/system-setup.sh")
(exec "scripts/code-setup.sh")
