module fpga_top(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1;

    wire resetn;
    wire go;

    wire [7:0] data_result; //make this wider? 
    assign go = ~KEY[1];
    assign reset = KEY[0];

    part2 u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[7:0]),
        .data_result(data_result)
    );
      
    assign LEDR[3:0] = data_result[3:0];

    hex_decoder H0(
        .hex_digit(SW[3:0]), 
        .segments(HEX0)
        );
        
    hex_decoder H1(
        .hex_digit(4'b0), 
        .segments(HEX1)
        );
	
	hex_decoder H2(
        .hex_digit(SW[7:4]), 
        .segments(HEX2)
        );
		  
	      
    hex_decoder H3(
        .hex_digit(4'b0), 
        .segments(HEX3)
        );
        
    hex_decoder H4(
        .hex_digit(data_result[3:0]), 
        .segments(HEX4)
        );
		  
	 hex_decoder H5(
        .hex_digit(data_result[7:4]), 
        .segments(HEX5)
        );
		  

endmodule

//you want to repeat part 2 four times 
module part2(
    input clk,
    input resetn,
    input go,
    input [7:0] data_in,
    output [8:0] data_result
    );

    // lots of wires to connect our datapath and control
	 wire ld_dividend, ld_regA, ld_divisor;
    wire  [8:0] alu_out; //RegisterA + Dividend
    wire [1:0]alu_op; //selects which ALU operation is required
	 wire isMinus; 
	 wire out;
     
    control C0(
        .clk(clk),
        .resetn(resetn),
        .go(go),
        .alu_out(alu_out), 
        .alu_op(alu_op),
		  .isMinus(isMinus),
		  .out(out),
		  .ld_dividend (ld_dividend),
		  .ld_regA(ld_regA),
		  .ld_divisor (ld_divisor)
    );

    datapath D0(
        .clk(clk),
        .resetn(resetn),
        .alu_out(alu_out), 
        .alu_op(alu_op),
        .data_in(data_in),
        .data_result(data_result),
		  .isMinus(isMinus),
		  .out(out),
		  .ld_dividend (ld_dividend),
		  .ld_regA(ld_regA),
		  .ld_divisor (ld_divisor)
    );
                
 endmodule        
 
 
module control(
    input clk,
    input resetn,
    input go,
    output reg  [8:0] alu_out,
    output reg [1:0 ]alu_op,
	 input isMinus,
	 output reg out,
	 output reg ld_dividend, ld_divisor, ld_regA
    );

    reg [5:0] current_state, next_state; 
	 reg [1:0] count = 2'b00; 
    
    localparam  S_load        = 5'd0,
                S_shift       = 5'd1,
                S_subtract 	= 5'd2,
                S_add         = 5'd3,
                S_setQ        = 5'd4,
					 S_isDone		= 5'd5;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_load: next_state = go ? S_shift : S_load;
                S_shift: next_state = S_subtract; //does all the shifting shenanigans for dividend and A 
                S_subtract: next_state = isMinus? S_add : S_setQ; 
                S_add: next_state = S_setQ;
					 S_setQ: next_state = S_load;          
            default:     next_state = s_load;
        endcase
    end // state_table
   
    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        // This is a different style from using a default statement.
        // It makes the code easier to read.  If you add other out
        // signals be sure to assign a default value for them here.
        alu_op       = 2'b0;
			out 			= 1'b0;
        case (current_state)
            S_load: begin
                ld_dividend = 1'b1;
                ld_divisor = 1'b1;
                ld_regA = 1'b1; 
                end
            S_shift: begin
                 alu_op = 2'b10; 
                end
            S_subtract: begin
                alu_op = 2'b00;
                end
            S_add: begin
                alu_op = 2'b01;
                end
            S_setQ: begin 
					alu_op = 2'b11;
				end 
				S_isDone: begin
				 count = count + 1; 
				 out = (count == 2'b11)? 1'b1 : 1'b0; 
				end 
				endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_A;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
    
    
    module datapath(
    input clk,
    input resetn,
    input [7:0] data_in, 
    input ld_divisor, ld_dividend, ld_regA,
    input alu_op, 
    output reg [8:0] data_result,
	 output reg isMinus,
	 input ld_dividend, ld_regA, ld_divisor
    );
    
    // input registers
    reg [4:0] A, divisor;
	 reg [3:0] dividend;
    // output of the alu
    reg [7:0] alu_out;
   
    
    // Loading the registers when g=1 WRITE 
    always@(posedge clk) begin
        if(!resetn) begin
            divisor = 5'b0;
				dividend = 3'b0;
				A = 5'b0;
        end
        else begin
            if(ld_divisor)
                divisor <=  {0, data_in[3:0]}; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_dividend)
                dividend <= data_in [7:4]; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_regA)
                A <= 5'b0;
        end
    end
 
    // Output result register - this is where the counter will strike! 
    always@(posedge clk) begin
        if(!resetn) begin
            data_result <= 9'b0; 
        end
        else 
            if(out == 1'b1) 
             data_result <= alu_out;
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu
        case (alu_op)
            01: begin
                   alu_out[8:4] = A + divisor; //performs addition
						 
               end
            00: begin
                   alu_out [8:4] = A - divisor; //performs subtraction of divisor and reg A output
						isMinus = A[5]; 
					end
				10: begin //shift left, and move the MSB to LSB 
						A[0] = dividend [3];
						divident <= dividend << 1;
						alu_out [8:0] = {A[5:0], dividend[3:0]};
						count = count + 1; 
				end
				11: dividend[0] = ~isMinus; //WILL THIS WORK? 
            default: alu_out = 8'b0;
        endcase
    end
	 
endmodule 
	 