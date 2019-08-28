# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part1.v
vlog ram32x4.v
vlog ram32x4_bb.v


#load simulation using mux as the top level simulation module
vsim part1

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {KEY[0]} 0
run 10ns

#Case1 - Enable is On. RESET
#Data
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
#Address
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[8]} 0
#Write enable
force {SW[9]} 1
#clock
force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

#Case2 - Store 5 in address 10
#Data
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
#Address
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {SW[8]} 0
#Write enable
force {SW[9]} 1
#clock
force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

#Case3 - Enable is off
#Data
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
#Address
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {SW[8]} 0
#Write enable
force {SW[9]} 0
#clock
force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

#Case4 - Enable is off, data inputs are different, shouldn't change output
#Data
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
#Address
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {SW[8]} 0
#Write enable
force {SW[9]} 0
#clock
force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

#Case5 - Enable is on, output should change to be an F
#Data
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
#Address
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {SW[8]} 0
#Write enable
force {SW[9]} 1
#clock
force {KEY[0]} 1
run 10ns



