# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part3.v

#load simulation using mux as the top level simulation module
vsim ALU

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#Test1 - 1 -ADDER
force {SW[0]} 1 
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 1
force {KEY[2]} 0
force {KEY[1]} 0
force {KEY[0]} 0
#run simulation for a few ns
run 10ns

#Test1 - 2 - ADDER
force {SW[0]} 0 
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0
force {KEY[2]} 0
force {KEY[1]} 0
force {KEY[0]} 0
#run simulation for a few ns
run 10ns

#Test2 - same as Test1(2) A+B
force {SW[0]} 0 
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0
force {KEY[2]} 0
force {KEY[1]} 0
force {KEY[0]} 1
#run simulation for a few ns
run 10ns

#Test3 - NAND,NOR
force {SW[0]} 1 
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0                                                                                       
force {SW[6]} 1
force {SW[7]} 0
force {KEY[2]} 0
force {KEY[1]} 1
force {KEY[0]} 0
#run simulation for a few ns
run 10ns

#Test4 - 8'b11000000
force {SW[0]} 1 
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0
force {KEY[2]} 0
force {KEY[1]} 1
force {KEY[0]} 1
#run simulation for a few ns
run 10ns

#Test5 - 8'b00111111
force {SW[0]} 0 
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 1
force {KEY[2]} 1
force {KEY[1]} 0
force {KEY[0]} 0
#run simulation for a few ns
run 10ns

#Test6 - HEX
force {SW[0]} 1 
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0
force {KEY[2]} 1
force {KEY[1]} 0
force {KEY[0]} 1
#run simulation for a few ns
run 10ns

#Test7 - XNOR,XOR
force {SW[0]} 1 
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0
force {KEY[2]} 1
force {KEY[1]} 1
force {KEY[0]} 0
#run simulation for a few ns
run 10ns