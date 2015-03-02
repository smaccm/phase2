#!/bin/sh

cd test0

export RAMSES_DIR=../ramses_resource

export AADL2RTOS_CONFIG_DIR=../aadl2rtos_resource


java -jar ../ramses.jar -g rtos -i .,../aadl2rtos_resource -o out -l trace -s test0.impl -m SMACCM_SYS.aadl,test0.aadl
