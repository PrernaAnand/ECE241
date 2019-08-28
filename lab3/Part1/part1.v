module MUX(LEDR, SW);
 input [9:0] SW;
 output [9:0]LEDR;
 
 Mux_7to1 x1(.MUXSelect(SW[9:7]), .I(SW[6:0]), .Out(LEDR[0]));
endmodule

module Mux_7to1(MUXSelect, I, Out);
 input [6:0]I;
 input [2:0]MUXSelect;
 output reg Out;
 
 always@(*)
 begin
   case(MUXSelect[2:0])
	 
	  3'b000: Out = I[0]; 
	  3'b001: Out = I[1];
	  3'b010: Out = I[2];
	  3'b011: Out = I[3];
	  3'b100: Out = I[4];
	  3'b101: Out = I[5];
	  3'b110: Out = I[6];
     default: Out = 3'b111;
   endcase
 end
endmodule

