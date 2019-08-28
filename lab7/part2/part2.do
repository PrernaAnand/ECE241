# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Lab7Part2.v

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets

force clk 0 0ns, 1 {5ns} -r 10ns

#resetn
force resetn 0
force go 0
force black_screen 0
force draw 0
run 10 ns

force resetn 1
force go 0
force black_screen 0
force draw 0
run 5ns

#load x
force data_in 7'd0
force go 1
force black_screen 0
force draw 0
run 20ns

#load y & color
force data_in 7'd0
force colour 3'b111
force go 0 
run 20ns

#move to load y wait
force go 1
force black_screen 0
force draw 0
run 20ns

#move to draw
force go 0
force black_screen 0
force draw 0
run 20ns

#move to draw wait
force go 0
force black_screen 0
force draw 1
run 170ns

#lol
force draw 0
run 50ns

# press KEY2 to unleash destruction
force black_screen 1
run 100ns

#LMAO
force black_screen 0
run 50ns

#run again
force colour 3'b010
force go 1
force data_in 7'd10
run 20ns

#loaded X, now Y
force data_in 7'd0
force go 0
run 20ns

#move to load y wait
force go 1
force draw 0
run 20ns

#move to draw wait
force go 0
force black_screen 0
force draw 1
run 170ns

#lol
force draw 0
run 50ns