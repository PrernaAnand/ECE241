# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog sequence_detector.v

#load simulation using mux as the top level simulation module
vsim sequence_detector

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#Case1 - Reset
force {SW[0]} 0
force {SW[1]} 0
force {KEY[0]} 0
run 10ns

#Case2.a - At A, w = 1, LEDR0 = 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns

#Case2.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case3.a - At B, w = 1, LEDR1 = 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns

#Case3.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case4.a - At C, w = 1, LEDR1 = 1, LEDR0 = 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns


#Case4.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case5.a - At D, w = 1, LEDR2 = 1, LEDR0 = 1, LEDR9 = 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns


#Case5.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case6.a - At F, w = 1, LEDR2 = 1, LEDR0 = 1, LEDR9 = 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns

#Case6.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns


#Case7.a - At F, w = 0, LEDR2 = 1
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 10ns


#Case7.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case8.a - At E, w = 1, LEDR2 = 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns

#Case8.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case9.a - At G, w = 1, LEDR2 = 1, LEDR1 = 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 10ns

#Case9.b - posedge
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 10ns

#Case10.a - At G, w = 0, BACK to A
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 10ns

#Case10.b - posedge
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 0
run 10ns

#Case11 - Reset
force {SW[0]} 0
force {SW[1]} 0
force {KEY[0]} 1
run 10ns