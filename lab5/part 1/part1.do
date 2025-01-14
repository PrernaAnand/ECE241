# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part1.v

#load simulation using mux as the top level simulation module
vsim part1

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#Case1 - Everything is uninitialized
force {SW[0]} 0
force {SW[1]} 0
force {KEY[0]} 0
run 10ns

#Case2 - Clock = 1 - (posedge) , no output as reset is 1
force {SW[0]} 0
force {SW[1]} 0
force {KEY[0]} 1
run 10ns

#Case3 - Reset is off, enable = 1, clock = 0, no change
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case4 - Reset is off, enable = 1, posedge - starts counting
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns

#Case5 - Enable is off, everything should be same
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 10ns

#Case6 - Enable is on, starts counting again
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns

#Case7 - Reset
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 10ns