`timescale 10ms / 10ms
module part2 (HEX0, SW, CLOCK_50);

	input [1:0] SW;//these are for the clock 
	input CLOCK_50; 
	output [6:0] HEX0;
	
	wire [3:0] out; 
	
	wire clock, enable;
	wire [25:0] d; //you need 26 bits to count till 50 million clock cycles

	assign clock = CLOCK_50;
	
	mux m1 (.c1(SW[1]), .c0(SW[0]), .muxOut(d));
	rateDivideCount c1(.pulseWidth(d), .pulse(enable), .clk(clock));
	upCounter T1(.Clock(CLOCK_50), .En(enable), .Q(out));
	Display D1(.I(out[3:0]), .O(HEX0[6:0]));

endmodule 

module upCounter (Clock, En, Q);
input Clock; 
input En;
output reg [3:0] Q;

always @ (posedge Clock) 
	begin
	if (Q === 4'bx) begin 
		Q <= 0;
	end
	else if (En)
		Q <= Q + 1;
	else 
		Q <= Q; 
	end
endmodule 

module mux (c1, c0, muxOut);
	input c1, c0;
	output reg [25:0] muxOut;

	always @ (*)
	begin
		if (c1 == 1'b0 & c0 == 1'b0)
		muxOut = 26'b00000000000000000000000000; //assign with no of bits - 1
		else if (c1 == 1'b0 & c0 == 1'b1)
		//muxOut = 26'b00101111101011110000011111;		//counts 12.5M clock cycles for 4Hz signals
		muxOut = 26'b00000000000000000000001100;
		else if (c1 == 1'b1 & c0 == 1'b0)
		//muxOut = 26'b01011111010111100000111110;  
      muxOut = 26'b00000000000000000000011000;		
		else if (c1 == 1'b1 & c0 == 1'b1)
		//muxOut = 26'b10111110101111000001111111; //counts 50M clock cycles for 1Hz signals 
		muxOut = 26'b00000000000000000000110001;
	end

endmodule 
		
module rateDivideCount (pulseWidth, pulse, clk);
	input [25:0] pulseWidth; //the number that counter needs to count till 
	reg [25:0] counter; 
	input clk; 
	output reg pulse; 
	
	always @ (posedge clk) 
	begin
	if (counter === 26'bx) begin 
		counter <= 0;
	end
	else if (counter == pulseWidth) 
	begin
		counter<= 0;
		pulse <= 1;
	end 
	else
		begin
		counter <= counter + 1; //keeps incrementing till pulseWidth is reached
		pulse <= 0; 
		end
	end 
	
endmodule 



module Display(input[3:0] I, output [6:0] O);
 
 HEX H1( .c0(I[0]), .c1(I[1]), .c2(I[2]), .c3(I[3]), 
       .l0(O[0]), .l1(O[1]), .l2(O[2]), .l3(O[3]), 
		 .l4(O[4]), .l5(O[5]), .l6(O[6]));
 
endmodule

module HEX(input c0, c1, c2, c3, output l0, l1, l2, l3, l4, l5, l6);

 assign l0 = (~c3&~c2&~c1&c0) | (~c3&c2&~c1&~c0) | (c3&~c2&c1&c0) | (c3&c2&~c1&c0);
 
 assign l1 = (~c3&c2&~c1&c0) | (~c3&c2&c1&~c0) | (c3&~c2&c1&c0) | (c3&c2&~c1&~c0) | (c3&c2&c1&~c0) | (c3&c2&c1&c0);

 assign l2 = (~c3&~c2&c1&~c0) | (c3&c2&~c1&~c0) | (c3&c2&c1&~c0) | (c3&c2&c1&c0);

 assign l3 = (~c3&~c2&~c1&c0) | (~c3&c2&~c1&~c0) | (~c3&c2&c1&c0) | (c3&~c2&~c1&c0) | (c3&~c2&c1&~c0) | (c3&c2&c1&c0);

 assign l4 = (~c3&~c2&~c1&c0) | (~c3&~c2&c1&c0) | (~c3&c2&~c1&~c0) | (~c3&c2&~c1&c0) | (~c3&c2&c1&c0) | (c3&~c2&~c1&c0);

 assign l5 = (~c3&~c2&~c1&c0) | (~c3&~c2&c1&~c0) | (~c3&~c2&c1&c0) | (~c3&c2&c1&c0) | (c3&c2&~c1&c0);

 assign l6 = (~c3&~c2&~c1&~c0) | (~c3&~c2&~c1&c0) | (~c3&c2&c1&c0) | (c3&c2&~c1&~c0);

endmodule


