# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part1.v

#load simulation using mux as the top level simulation module
vsim MUX

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#I's
force {SW[0]} 0 
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1

#testCase1
force {SW[7]} 0
force {SW[8]} 0 
force {SW[9]} 0
#run simulation for a few ns
run 10ns

#testCase2
force {SW[7]} 0
force {SW[8]} 0 
force {SW[9]} 1
#run simulation for a few ns
run 10ns

#testCase3
force {SW[7]} 0
force {SW[8]} 1 
force {SW[9]} 0
#run simulation for a few ns
run 10ns

#testCase4
force {SW[7]} 0
force {SW[8]} 1 
force {SW[9]} 1
#run simulation for a few ns
run 10ns

#testCase5
force {SW[7]} 1
force {SW[8]} 0 
force {SW[9]} 0
#run simulation for a few ns
run 10ns

#testCase6
force {SW[7]} 1
force {SW[8]} 0 
force {SW[9]} 1
#run simulation for a few ns
run 10ns

#testCase7
force {SW[7]} 1
force {SW[8]} 1 
force {SW[9]} 0
#run simulation for a few ns
run 10ns
