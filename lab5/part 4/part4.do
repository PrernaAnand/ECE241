# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part4.v

#load simulation using mux as the top level simulation module
vsim part4

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {CLOCK_50} 0 0ms, 1 {10ms} -r 20ms 
#50 Hz Clock

#Case2 KEY[0] is reset. 
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0

force {KEY[0]} 0
force {KEY[1]} 1

run 3000 ms 


#Case2 KEY[0] is reset. 
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0

force {KEY[0]} 1
force {KEY[1]} 1

run 3000 ms 


