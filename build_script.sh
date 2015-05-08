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

BUILD_DIR_NAME=smaccmcopter-ph2-build
ODROID_APP_NAME=output
CAMKES_DIR_NAME=camkes
GALOIS_DIR_NAME=smaccmpilot-build

BASE_DIR=$PWD

if [[ $(id -u) -ne 0 ]]
then
    echo "Please run as root"
    exit 1
fi

# Save all output to output.txt
exec > >(tee output.txt)
exec 2>&1

mkdir $BUILD_DIR_NAME
cd $BUILD_DIR_NAME

echo "************************************************************"
echo "Configure APT"
echo "************************************************************"

# Work around Ubuntu APT bug
rm -rf /var/lib/apt/lists/*

apt-get update
apt-get -y install python-software-properties

add-apt-repository -y ppa:ubuntu-toolchain-r/test
add-apt-repository -y ppa:linaro-maintainers/toolchain
add-apt-repository -y ppa:terry.guo/gcc-arm-embedded
add-apt-repository -y ppa:webupd8team/java

apt-get update

# we have to do this to say yes to the java 8 license agreement
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

apt-get -y install gcc-4.8 git libgmp3-dev zlib1g-dev software-properties-common \
                   make libtinfo-dev libncurses5-dev  \
                   gcc-arm-linux-gnueabi python-tempita python-pip libxml2-utils  \
                   gcc-arm-none-eabi oracle-java8-installer

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50

pip install --upgrade pip
hash -r
pip install jinja2 ply pyelftools


HASKELL_TARBALL=haskell-platform-2014.2.0.0-unknown-linux-x86_64.tar.gz
if [ ! -e $HASKELL_TARBALL ]
then
  echo "************************************************************"
  echo "Install the haskell platform"
  echo "************************************************************"
  wget --progress=dot:mega https://www.haskell.org/platform/download/2014.2.0.0/$HASKELL_TARBALL
  tar -xzf $HASKELL_TARBALL --directory /
  /usr/local/haskell/ghc-7.8.3-x86_64/bin/activate-hs
fi

echo "************************************************************"
echo "Update cabal"
echo "************************************************************"

cabal update
cabal install cabal-install

export PATH=/home/smaccm/.cabal/bin/cabal:$PATH

cabal install alex happy
cabal install MissingH data-ordlist split

echo "************************************************************"
echo "Download ramses"
echo "************************************************************"

git clone https://github.com/smaccm/phase2.git ramses

echo "************************************************************"
echo "download galois code"
echo "************************************************************"

git clone https://github.com/GaloisInc/smaccmpilot-build.git $GALOIS_DIR_NAME
cd $GALOIS_DIR_NAME

git checkout feature/tower9
git submodule update --init
cd tower-camkes-odroid
make create-sandbox

cabal run serial-test -- --out-dir=$ODROID_APP_NAME
cd $ODROID_APP_NAME

echo "RAMSES_PATH=$BASE_DIR/$BUILD_DIR_NAME/ramses/ramses-demo" > ../RAMSES_PATH.mk
make

echo "************************************************************"
echo "get repo and the camkes stuff"
echo "************************************************************"

cd $BASE_DIR/$BUILD_DIR_NAME

curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > repo
chmod 755 repo

mkdir $CAMKES_DIR_NAME
cd $CAMKES_DIR_NAME

../repo init -u https://github.com/smaccm/may-drop-odroid-manifest.git 
../repo sync

echo "************************************************************"
echo "linking in the galois app"
echo "************************************************************"

ln -s $BASE_DIR/$BUILD_DIR_NAME/$GALOIS_DIR_NAME/tower-camkes-odroid/$ODROID_APP_NAME apps/$ODROID_APP_NAME

# Put our odroid app into the top-level Kconfig
# TODO: This may not be needed if the app is already in the Kconfig

sed --follow-symlinks --in-place "/\"Applications\"/a\    source \"apps\/$ODROID_APP_NAME\/Kconfig\"" Kconfig

# Modify the can defconfig to fit the current app
# TODO: This may not be needed if we already have a defconfig

make can_defconfig
sed --in-place "s/CONFIG_APP_CAN=y/# CONFIG_APP_CAN is not set/" .config
echo "CONFIG_APP_${ODROID_APP_NAME^^}=y" >>.config
make

cd $BASE_DIR
chown -R `logname` $BUILD_DIR_NAME

