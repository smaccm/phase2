#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

if [[ $(id -u) -ne 0 ]]
then
    echo "Must be run as root"
    exit 1
fi

cd ..


echo "************************************************************"
echo "Install Java 8"
echo "************************************************************"

# we have to do this to say yes to the java 8 license agreement
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

apt-get -y install python-software-properties software-properties-common
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer


echo "************************************************************"
echo "Upgrade to Ubuntu 14.04"
echo "************************************************************"

# We need to upgrade to Ubuntu 14.04 to get the right version of
# arm-linux-gnueabi-gcc (4.7.3) but we start with Ubuntu 12.04 since
# that's what Travis uses
apt-get update
apt-get install update-manager-core

# Workaround for conf files during upgrade
# http://ubuntuforums.org/showthread.php?t=2265877
cat >/etc/apt/apt.conf.d/local <<EOF
Dpkg::Options {
   "--force-confdef";
   "--force-confold";
}
EOF

export DEBIAN_FRONTEND=noninteractive
do-release-upgrade -f DistUpgradeViewNonInteractive

if [[ "$TRAVIS" == true ]]
then
    # do-release-upgrade tends to die on Travis.
    # This will hopefully handle that.
    rm /var/lib/dpkg/lock
    dpkg --configure -a
fi

rm /etc/apt/apt.conf.d/local

echo "************************************************************"
echo "Install apt software"
echo "************************************************************"

apt-get update

apt-get -y --force-yes install gcc-4.8 \
                               git \
                               libgmp3-dev \
                               zlib1g-dev \
                               make \
                               libtinfo-dev \
                               libncurses5-dev \
                               realpath \
                               gcc-arm-linux-gnueabi \
                               python-tempita \
                               python-pip \
                               libxml2-utils \
                               gcc-arm-none-eabi \
                               u-boot-tools \
                               minicom \
                               android-tools-fastboot


echo "************************************************************"
echo "Install pip software"
echo "************************************************************"

time pip install --upgrade pip
time hash -r
time pip install jinja2 ply pyelftools


# Installing cabal and cabal-install on Travis exceeds memory bound
if [[ "$TRAVIS" != true ]]
then
    echo "************************************************************"
    echo "Install haskell platform"
    echo "************************************************************"

    HASKELL_TARBALL=haskell-platform-2014.2.0.0-unknown-linux-x86_64.tar.gz
    wget --progress=dot:mega --no-check-certificate https://www.haskell.org/platform/download/2014.2.0.0/$HASKELL_TARBALL
    tar -xzf $HASKELL_TARBALL --directory /
    /usr/local/haskell/ghc-7.8.3-x86_64/bin/activate-hs

    echo "************************************************************"
    echo "Update cabal"
    echo "************************************************************"

    sudo -u `logname` cabal update

    cabal install --global cabal-install
    cabal install --global alex happy
    cabal install --global MissingH data-ordlist split
    cabal install --global mtl
    # Fix permissions caused by running cabal as root
    chown `logname` -R ~/.cabal
fi


echo "************************************************************"
echo "Get and install repo"
echo "************************************************************"

time curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
time chmod 755 /usr/local/bin/repo


echo "************************************************************"
echo "Set up minicom and fastboot"
echo "************************************************************"

echo SUBSYSTEM==\"usb\", ATTR{idVendor}==\"18d1\", MODE==\"0666\", GROUP==\"`logname`\" > /etc/udev/rules.d/40-odroidxu-fastboot.rules

cat >~/.minirc.odroid <<EOF
pu port             /dev/ttyUSB0
pu baudrate         115200
pu bits             8
pu parity           N
pu stopbits         1
pu rtscts           No
EOF
chown `logname` ~/.minirc.odroid
