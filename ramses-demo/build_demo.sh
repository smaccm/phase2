#!/bin/sh

cd models

export RAMSES_DIR=../ramses_resource

export AADL2RTOS_CONFIG_DIR=../aadl2rtos_resource


java -jar ../ramses.jar -g rtos -i src -o out -l trace -s test1.impl -m SMACCM_SYS.aadl,test1.aadl
