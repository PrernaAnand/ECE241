# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part2.v

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {CLOCK_50} 0 0ms, 1 {10ms} -r 20ms


#Case 1 - 50MHz
#force {SW[0]} 0
#force {SW[1]} 0
#run 1300 ms

#Case 2 - 4 Hz 
#force {SW[0]} 1
#force {SW[1]} 0
#run 4000 ms

#Case 3 - 2 Hz 
force {SW[0]} 1
force {SW[1]} 0
run 8000 ms

#Case 4 
#force {SW[0]} 1
#force {SW[1]} 1
#run 16000 ms