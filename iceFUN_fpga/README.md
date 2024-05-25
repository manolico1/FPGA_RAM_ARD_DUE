## Getting Started
Here is some information on how to set up the project and get started in the fpga´s world.
### Prerequisites
Ubuntu 22.04.4 LTS

These projects are designed to run on the Devantech iceFUN iCE40-HX8K FPGA module.

Project "blinky" to verify the proper functioning of the board:
[iceFUN Project Repository](https://github.com/devantech/iceFUN)

To build these projects, install the icestorm toolchain from [Clifford Wolf's Website](http://www.clifford.at/icestorm/)
and the iceFUN programmer from [Devantech's iceFUNprog Repository](https://github.com/devantech/iceFUNprog)

#### Install basic development tools:
```
sudo apt-get install build-essential cmake
sudo apt-get install git
sudo apt-get install python3-dev
sudo apt-get install libboost-all-dev
sudo apt-get install libeigen3-dev
sudo apt-get install yosys
sudo apt-get install gtkwave
```
Clone and install iceFUNprog tool:
```
git clone https://github.com/devantech/iceFUNprog.git
cd iceFUNprog
sudo make install
```
Clone and install icestorm tool:
```
git clone https://github.com/YosysHQ/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
```
Clone and install nextpnr tool:
```
git clone https://github.com/YosysHQ/nextpnr nextpnr
cd nextpnr
cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local .
make -j$(nproc)
sudo make install
```
Clone and install yosys tool:
```
git clone https://github.com/YosysHQ/yosys.git yosys
//If it does not work, try this instead: sudo apt-get install yosys
cd yosys
make -j$(nproc)
sudo make install
```
#### Check the permissions:
Make sure you have read and write permissions on the serial port (/dev/ttyACM0). You can verify permissions with:
```
ls -l /dev/ttyACM0
```
In the terminal you should get something like this:
```
crw-rw 1 root dialout 166, 0 may 9 17:51 /dev/ttyACM0
```
Access to /dev/ttyACM0:
In order for your user to access /dev/ttyACM0, they must be in the dialout group. You can check if your user is in the dialout group by running the following command:
``` 
groups
```
If the dialout group does not appear in the list of groups to which your user belongs, you can add your user to the dialout group using the following command:
```
sudo usermod -a -G dialout $USER
```
After adding your user to the dialout group, you need to log out and log back in for the changes to take effect.


### Usage
#### To run the project:
```
cd blinky
make blinky
maku burn
```
If programming and it seems not to do anything, make sure there is not any software using your device as a modem (e.g. [ModemManager](https://www.freedesktop.org/wiki/Software/ModemManager/)). If so, unplug your device, write the following command in terminal:
```
systemctl stop ModemManager
// or this one:
systemctl disable ModemManager
```
Then plug your device again. 

#### To synthesize the testbench and run the simulation, type:
```
iverilog -o testbench.vvp testbench.v
vvp testbench.vvp
```
To view the waveform first open GTKWave (`Gtkwave`). Press file -> Open New Tab (CTRL+T) and look for `.vcd` file . Then click on the testbench, 
select signals that you want to view and append them.





