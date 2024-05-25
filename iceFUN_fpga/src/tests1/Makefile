# Author: Manuel Jiménez Martínez - University of Málaga

# Project setup
PROJ      = topmodule
DEVICE    = 8k

# Files
FILES = topmodule.v 

.PHONY: ram clean burn

ram:
	# Synthesize using Yosys
	yosys -p "synth_ice40 -top topmodule -json $(PROJ).json" $(FILES)
	# Place and route using nextpnr
	nextpnr-ice40 --hx8k --json $(PROJ).json --package cb132 --pcf test.pcf --asc $(PROJ).asc
	#nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf test.pcf

	# Convert to bitstream using IcePack
	icepack $(PROJ).asc $(PROJ).bin

burn:
	iceFUNprog $(PROJ).bin

clean:
	rm -f $(PROJ).asc $(PROJ).bin $(PROJ).json
