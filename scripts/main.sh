#!/bin/bash
#
# This is the main build script for the May 15 SMACCM ODROID red team drop.
# Running this script should produce an image for the odroid and an image
# for the pixhawk.
#
# This script should work on Ubuntu 12.04 amd64 server edition with
# at least 20gb hard-drive space
#
###########################################################################

date

(exec sudo "./system-setup.sh")
(exec "./code-setup.sh")
(exec "./code-build.sh")

if [[ ! -e ../camkes/images/odroid-image ]]
then
    echo "Failed to build odroid-image"
    exit 1
fi
