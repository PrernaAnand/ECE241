# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part3.v

#load simulation using mux as the top level simulation module
vsim part3

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#Case1 - Red Signal
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[9]} 1
force {KEY[0]} 1
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
run 10ns

#Case1 - Positive edge
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[9]} 1
force {KEY[0]} 0
force {KEY[3]} 1
force {KEY[2]} 1
force {KEY[1]} 1
run 10ns

