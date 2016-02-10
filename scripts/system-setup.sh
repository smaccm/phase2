#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

cd ..

if [[ $TRAVIS != "true" ]] && [ -e "PATH" ];
then
    export PATH=`cat PATH`
fi

echo "************************************************************"
echo "Install pip software"
echo "************************************************************"

pip install --user jinja2 ply pyelftools tempita


echo "************************************************************"
echo "Get and install repo"
echo "************************************************************"

curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > repo
chmod 755 repo
