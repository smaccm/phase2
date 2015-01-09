Java runtime 1.7 or later is required.

Download all the files and directories here into a folder. Let <JenKode>
below stand for the absolute path to this folder.

Assuming you have an AADL model "test1.aadl" that imports "SMACCM_SYS.aadl", 
both in a directory models/src, corresponding implementations in a directory 
models/user_code and you want the generated output to be in models/out,
set-up the environment and execute the code-generator as follows:  

> cd models

> set RAMSES_DIR=<JenKode>/ramses_resource

> set AADL2RTOS_CONFIG_DIR=<JenKode>/aadl2rtos_resource

> java -jar <JenKode>/ramses.jar -g rtos -i src -o out -l trace -s test1.impl -m SMACCM_SYS.aadl,test1.aadl

(PS: In Unix shells, setenv or export would have to be used instead of set to configure
the two environment variables above).