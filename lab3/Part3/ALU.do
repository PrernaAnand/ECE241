
# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part3.v

#load simulation using mux as the top level simulation module
vsim ALU

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# CASE 0: Full Adder: 1011 + 1101 = 1000 Cout=1 

force {SW[8]} 0
force {SW[7]} 1
force {SW[6]} 1
force {SW[5]} 0
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 1



force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns


# CASE 2: A NAND B / A NOR B
# test1
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns

#test2
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns


# CASE 4
#requirements met 
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns

#requirements not met 
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns

#CASE 6
#test1
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

#test2
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

# Case 1 - Example 1
# This makes it case 1
force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 0
# Input A = 1010 = hA
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
# Input B = 0101 = h5
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
run 10ns
# Output = 00001111 

# Case 1 - Example 2
# this makes it case 1
force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 0
# Input A = 1011
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
# Input B = 1001
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
run 10ns
# Output = 00000100 

# Case 3 - Example 1
# This makes it case 3
force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 0
#This is input A
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
# This is input B
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
run 10ns
# Output = 00000000 

# Case 3 - Example 2
# This makes it case 3
force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 0
#This is input A
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0
# This is input B
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
run 10ns
# Output = 11000000 

# Case 5 - Example 1
# This makes it case 5
force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
#This is input A
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0
# This is input B
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
run 10ns
# Output = 11101001

# Case 5 - Example 2
# This makes it case 5
force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
# Input A = 1111
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 1
# Input B = 0011
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
run 10ns
# Output = 00110000





