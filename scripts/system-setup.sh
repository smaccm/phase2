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
echo "Configure apt"
echo "************************************************************"

# Work around Ubuntu APT bug
rm -rf /var/lib/apt/lists/*

apt-get update
apt-get -y install python-software-properties

add-apt-repository -y ppa:ubuntu-toolchain-r/test
add-apt-repository -y ppa:linaro-maintainers/toolchain
add-apt-repository -y ppa:terry.guo/gcc-arm-embedded
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:nilarimogard/webupd8


echo "************************************************************"
echo "Install apt software"
echo "************************************************************"

apt-get update

# we have to do this to say yes to the java 8 license agreement
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

apt-get -y --force-yes install gcc-4.8 \
                               git \
                               libgmp3-dev \
                               zlib1g-dev \
                               software-properties-common \
                               make \
                               libtinfo-dev \
                               libncurses5-dev \
                               realpath \
                               gcc-arm-linux-gnueabi \
                               python-tempita \
                               python-pip \
                               libxml2-utils \
                               gcc-arm-none-eabi \
                               oracle-java8-installer \
                               u-boot-tools \
                               minicom \
                               android-tools-fastboot

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50


echo "************************************************************"
echo "Install pip software"
echo "************************************************************"

pip install --upgrade pip
hash -r
pip install jinja2 ply pyelftools


echo "************************************************************"
echo "Install haskell platform"
echo "************************************************************"

HASKELL_TARBALL=haskell-platform-2014.2.0.0-unknown-linux-x86_64.tar.gz
wget --progress=dot:mega https://www.haskell.org/platform/download/2014.2.0.0/$HASKELL_TARBALL
tar -xzf $HASKELL_TARBALL --directory /
/usr/local/haskell/ghc-7.8.3-x86_64/bin/activate-hs


echo "************************************************************"
echo "Update cabal"
echo "************************************************************"

sudo -u `logname` cabal update
cabal install --global cabal-install
cabal install --global alex happy
cabal install --global MissingH data-ordlist split
# Fix permissions caused by running cabal as root
chown `logname` -R ~/.cabal


echo "************************************************************"
echo "Get and install repo"
echo "************************************************************"

curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
chmod 755 /usr/local/bin/repo


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
