`timescale 10ms/10ms 
module part4(SW, KEY, CLOCK_50, LEDR);
	input [9:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	
	wire reset = KEY[0];
	
	output [9:0]LEDR;
	
	reg [25:0] q;
	
	
	reg [12:0] letter;
	
	always@(*)
	begin
		case(SW[2:0])
			3'b000: letter = 13'b0000000010101;//S
			3'b001: letter = 13'b0000000000111;//T
			3'b010: letter = 13'b0000001110101;//U
			3'b011: letter = 13'b0000111010101;//V
			3'b100: letter = 13'b0000111011101;//W
			3'b101: letter = 13'b0011101010111;//X
			3'b110: letter = 13'b1110111010111;//Y
			3'b111: letter = 13'b0010101110111;//Z
			default: letter = 13'b0;
		endcase
	end
	
	//time between pulses is 0.5 seconds -> rateDivider is 2Hz
	wire [25:0] rateDivider = 26'b00000000000000000000011001; //for simulation
	//26'b01011111010111100000111111; //2Hz for a 50 MHz
	
	//wire clk;
	//assign clk = (q == 26'b0) ? 1:0;
	
	reg clk;
	wire clk1;
	assign clk1 = clk;
	
	always@(posedge CLOCK_50)
	begin
		if (q === 26'bx) 
		begin 
		q <= 0; 
		end
		else if(q == rateDivider) 
		begin
			q <= 26'b0;
			clk <= 1;
		end
		else 
		begin
			q <= q + 1;
			clk <= 0;
		end
	end 
	
	//shift register
	
	//instantiate mux2to1
	//instantiate flipflop
	
	wire ParallelLoadn = KEY[1];
	wire [12:0] D = 13'b0; //changed these
	wire [12:0] Q = 13'b0;
	
	
	mux2to1 M12(.x(letter[12]), .y(1'b0), .s(ParallelLoadn), .m(D[12]));
	FF F12(.d(D[12]), .clock(clk1), .reset(reset), .q(Q[12]));
	
	mux2to1 M11(.x(letter[11]), .y(Q[12]), .s(ParallelLoadn), .m(D[11]));
	FF F11(.d(D[11]), .clock(clk1), .reset(reset), .q(Q[11]));
	
	mux2to1 M10(.x(letter[10]), .y(Q[11]), .s(ParallelLoadn), .m(D[10]));
	FF F10(.d(D[10]), .clock(clk1), .reset(reset), .q(Q[10]));
	
	mux2to1 M09(.x(letter[9]), .y(Q[10]), .s(ParallelLoadn), .m(D[9]));
	FF F09(.d(D[9]), .clock(clk1), .reset(reset), .q(Q[9]));
	
	mux2to1 M08(.x(letter[8]), .y(Q[9]), .s(ParallelLoadn), .m(D[8]));
	FF F08(.d(D[8]), .clock(clk1), .reset(reset), .q(Q[8]));
	
	mux2to1 M07(.x(letter[7]), .y(Q[8]), .s(ParallelLoadn), .m(D[7]));
	FF F07(.d(D[7]), .clock(clk1), .reset(reset), .q(Q[7]));
	
	mux2to1 M06(.x(letter[6]), .y(Q[7]), .s(ParallelLoadn), .m(D[6]));
	FF F06(.d(D[6]), .clock(clk1), .reset(reset), .q(Q[6]));
	
	mux2to1 M05(.x(letter[5]), .y(Q[6]), .s(ParallelLoadn), .m(D[5]));
	FF F05(.d(D[5]), .clock(clk1), .reset(reset), .q(Q[5]));
	
	mux2to1 M04(.x(letter[4]), .y(Q[5]), .s(ParallelLoadn), .m(D[4]));
	FF F04(.d(D[4]), .clock(clk1), .reset(reset), .q(Q[4]));
	
	mux2to1 M03(.x(letter[3]), .y(Q[4]), .s(ParallelLoadn), .m(D[3]));
	FF F03(.d(D[3]), .clock(clk1), .reset(reset), .q(Q[3]));
	
	mux2to1 M02(.x(letter[2]), .y(Q[3]), .s(ParallelLoadn), .m(D[2]));
	FF F02(.d(D[2]), .clock(clk1), .reset(reset), .q(Q[2]));
	
	mux2to1 M01(.x(letter[1]), .y(Q[2]), .s(ParallelLoadn), .m(D[1]));
	FF F01(.d(D[1]), .clock(clk1), .reset(reset), .q(Q[1]));
	
	mux2to1 M00(.x(letter[0]), .y(Q[1]), .s(ParallelLoadn), .m(D[0]));
	FF F00(.d(D[0]), .clock(clk1), .reset(reset), .q(Q[0]));
	
	assign LEDR[0] = Q[0];
	
	
endmodule

module FF(d, clock, reset, q);
	input d;
	input clock, reset;
	output reg q;
	
	always@(posedge clock, negedge reset)
	begin
		if (q === 1'bx)
			q <= 1'b0;
		
		else if(!reset)  //!reset
			q <= 1'b0;
		
		else 
			q <= d;
	end
endmodule	

	

module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    //assign m = s & y | ~s & x;
    // OR
    assign m = s ? y : x;
	 

endmodule