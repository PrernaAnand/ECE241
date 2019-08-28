# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Lab7part3.v

#load simulation using mux as the top level simulation module
vsim Lab7part3

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {CLOCK_50} 0 0ms, 1 {10ms} -r 20 ms

#reset 
force {KEY[0]} 0 
force {KEY[1]} 1
force {SW[9]} 1 
force {SW[8]} 1 
force {SW[7]} 1
run 100 ms 

force {KEY[0]} 1
force {KEY[1]} 1
force {SW[9]} 1 
force {SW[8]} 1 
force {SW[7]} 1
run 100 ms 

#White coloured boxes moving
force {KEY[0]} 1
force {KEY[1]} 1
force {SW[9]} 1 
force {SW[8]} 1 
force {SW[7]} 1

run 50000 ms 


#force {KEY[0]} 1
#force {KEY[1]} 1
#force {SW[9]} 0 
#force {SW[8]} 0 
#force {SW[7]} 0
#run 50000 ms