Build of Builds
===============

This is the repository for the phase 2 demo software and build support. The scripts directory contains everything needed to compile the demo.

To do a full install run the `bootstrap.sh` script in a freshly installed Ubuntu 12.04 64-bit server with at least 20gb of hard-drive space. The script will download this repository and kick off the main build.

If you already have this repository checked out then you can cd to `phase2/scripts` and execute `main.sh` to install all the software dependencies for this project, check out all the code, and build the final images.

What is located where?
===============

After running `main.sh` you will have four folders in the `phase2` directory:

1. camkes
2. ramses-demo
3. scripts
4. smaccmpilot-build

The camkes directory contains all of the source code for seL4 and symlinks to a few demo applications (under `camkes/apps`). The `ramses-demo` directory contains code to run the AADL Trusted Build. The `scripts` directory contains scripts for setting up the system environment and building code. The `smaccmpilot-build` directory contains Galois' code for the different applications in this deliverable. 

How do I run the examples?
===============

If you run the `main.sh` script a symlink called "smaccmpilot" will appear in the `camkes/apps` directory. This app is built by the `main.sh` script, and the final image will appear at `camkes/images/odroid-image`.

To load this image make sure that the USB-to-UART adapter is connected to the build machine and the ODROID. The build scripts should have created the file `.minirc.odroid` in your home directory with the following contents

```
pu port             /dev/ttyUSB0
pu baudrate         115200
pu bits             8
pu parity           N
pu stopbits         1
pu rtscts           No
```

Adjust the port if needed. Then you can run the command `minicom odroid` to connect to the console interface of the ODROID. Then power on the ODROID. Your screen should look like this:

```
U-Boot 2012.07-g612e625 (Mar 21 2014 - 09:39:54) for Exynos5410

CPU: Exynos5410 Rev2.3 [Samsung SOC on SMP Platform Base on ARM CortexA15]
APLL = 900MHz, KPLL = 600MHz
MPLL = 532MHz, BPLL = 800MHz
DRAM:  2 GiB
WARNING: Caches not enabled

TrustZone Enabled BSP
BL1 version: 
PMIC VER : 0, CHIP REV : 6
VDD MIF : 1.00000V
VDD ARM : 1.00000V
VDD INT : 1.00000V
VDD G3D : 1.00000V
VDD KFC : 1.00000V

Checking Boot Mode ... EMMC4.41
MMC:   S5P_MSHC0: 0, S5P_MSHC2: 1
MMC Device 0: 7.3 GiB
MMC Device 1: [ERROR] response error : 00000006 cmd 8
[ERROR] response error : 00000006 cmd 55
[ERROR] response error : 00000006 cmd 2
In:    serial
Out:   serial
Err:   serial
Net:   No ethernet found.
Press 'Enter' or 'Space' to stop autoboot:  0 
there are pending interrupts 0x00000001
[Partition table on MoviNAND]
ptn 0 name='fwbl1' start=0x20000 len=N/A (use hard-coded info. (cmd: movi))
ptn 1 name='bl2' start=N/A len=N/A (use hard-coded info. (cmd: movi))
ptn 2 name='bootloader' start=N/A len=N/A (use hard-coded info. (cmd: movi))
ptn 3 name='tzsw' start=N/A len=N/A (use hard-coded info. (cmd: movi))
ptn 4 name='kernel' start=N/A len=N/A (use hard-coded info. (cmd: movi))
ptn 5 name='ramdisk' start=N/A len=0x4000(~16777216KB) (use hard-coded info. (cmd: movi))
ptn 6 name='system' start=0x0 len=0x100EC1(~1077609984KB) 
ptn 7 name='userdata' start=0x0 len=0x20005B(~-2147389952KB)
ptn 8 name='cache' start=0x0 len=0x4198E(~275134464KB) 
ptn 9 name='fat' start=0x0 len=0x3E2E3F(~-122094592KB) 
USB cable Connected![0x4]
```

Then in another terminal go to the `phase2/camkes/images` directory and run the command:

```
sudo fastboot boot odroid-image
```

You should see seL4 booting in the minicom console.

What are the demos in this deliverable?
===============

There are two applications that run on the ODROID: The serial test and the CAN test. You can change which application is built by changing line 2 of `phase2/scripts/variables.sh` to be:

```
TOWER_APP_NAME=${TOWER_APP_NAME:-serial-test}
```
or
```
TOWER_APP_NAME=${TOWER_APP_NAME:-can-test}
```

**Note that you can just run the `code-build.sh` script to rebuild the code rather then re-running everything with `main.sh`**

**Also note that there are other applications in this deliverable that run on the pixhawk. Documentation for these can be found here: https://github.com/GaloisInc/smaccmpilot-build/blob/feature/tower9/red-team-may-2015.md**

The serial test
===============

The seial test prints ASCII characters to the "telem" port on the ODROID daughterboard. If you send characters to the port it will print them to the debug terminal on the ODROID (it will display them in the minicom window).

The telem port has a header on the underside of the daughter board (the side that faces the ODROID if they are on top of each other) that has easy access. Looking directly at the tips of the pins with the top side of the header facing the ground call the left most pin 1 and the right most pin 6. The pinout is as follows:

- Pin 1: unused
- Pin 2: tx
- Pin 3: rx
- Pin 4: positive 5 volts
- Pin 5: unused
- Pin 6: ground

We used another USB-to-UART adapter to hook up to this header to view the output.

The CAN test
===============

The CAN test sends and receives messages on the CAN port and prints them to the debug console.  To run this test you can load the image on two ODROIDs and have them talk to each other through the CAN port on the ODROID daughterboard. If you have the Pixhawk configured to send/receive CAN messages you could also attach it to the ODROID to see how they will talk to each other.


More detailed documentation
===============

View the READMEs for the other projects for more detailed documentation:

https://github.com/GaloisInc/smaccmpilot-build/blob/feature/tower9/red-team-may-2015.md
https://github.com/smaccm/may-drop-odroid-manifest
