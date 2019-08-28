module ALU(SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
  input [7:0] SW;
  input [2:0] KEY;
  output [7:0] LEDR;
  output [6:0] HEX0;
  output [6:0] HEX1;
  output [6:0] HEX2;
  output [6:0] HEX3;
  output [6:0] HEX4;
  output [6:0] HEX5;
  
  wire[3:0] A, B;
  assign A = SW [7:4];
  assign B = SW [3:0];
	
  reg [7:0] ALUout;
  wire[3:0] w1; //Selector  
  wire w2;
  
  Adder X1(.A(SW[7:4]), .B(SW[3:0]), .Cout(w2), .S(w1[3:0]), .Cin(0));
  
  always@(*)
   begin
     case(KEY[2:0])
			
			3'b000: ALUout = {3'b000,w2, w1};
			
			3'b001: ALUout = {4'b0000,A + B};
			
			3'b010: ALUout = {~(A|B),~(A&B)};
			
			3'b011: begin
			          if((|A)||(|B) == 1) //bitwise OR
						   ALUout = 8'b11000000;
					    else ALUout = 8'b00000000; 
					  end
			
			3'b100: begin
			          if((A == 4'b0011||4'b0110||4'b1100||4'b1010||4'b0101||4'b1001) && (B == 4'b0111||4'b1110||4'b1011||4'b1101))
                     ALUout = 8'b00111111;
						 else ALUout = 8'b00000000;
					  end
			3'b101: 
					  ALUout = {B, ~A};
			        
			3'b110: ALUout = {A^B,A~^B};
			default: ALUout = 8'b00000000;
	  endcase
	end
	
	Display D1(.I(B[3:0]), .hex(HEX0[6:0]));
   Display D2(.I(A[3:0]), .hex(HEX2[6:0]));
	assign HEX1[6:0] = 7'b0000000;
	assign HEX3[6:0] = 7'b0000000;
	Display D3(.I(ALUout[3:0]), .hex(HEX4[6:0]));
	Display D4(.I(ALUout[7:4]), .hex(HEX5[6:0]));
	assign LEDR [7:0] = ALUout [7:0];
	
endmodule
  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;
  wire [2:0] W;

module Adder(Cin, A, B, S, Cout);
  
  
  FullAdd x1(.cin(Cin), .a(A[3]), .b(B[3]), .cout(W[0]), .s(S[3]));    //bit0
  FullAdd x2(.cin(W[0]), .a(A[2]), .b(B[2]), .cout(W[1]), .s(S[2]));   //bit1
  FullAdd x3(.cin(W[1]), .a(A[1]), .b(B[1]), .cout(W[2]), .s(S[1]));   //bit2
  FullAdd x4(.cin(W[2]), .a(A[0]), .b(B[0]), .cout(Cout), .s(S[0]));   //bit3

endmodule
  
module FullAdd(cin, a, b, s, cout);

  input cin, a, b;
  output s, cout;
  assign s = a^b^cin;
  assign cout = (a&b)|(a&cin)|(b&cin);
  
endmodule

module Display(input[3:0] I, output[6:0] hex);
 
 HEX H1( .c0(I[0]), .c1(I[1]), .c2(I[2]), .c3(I[3]), 
       .h0(hex[0]), .h1(hex[1]), .h2(hex[2]), .h3(hex[3]), 
		 .h4(hex[4]), .h5(hex[5]), .h6(hex[6]));
 
endmodule

module HEX(c0, c1, c2, c3, h0, h1, h2, h3, h4, h5, h6);
  
 input c0, c1, c2, c3;
 output h0, h1, h2, h3, h4, h5, h6;
 
 assign h0 = !((c0|c1|c2|!c3)&(c0|!c1|c2|c3)&
              (!c0|c1|!c2|!c3)&(!c0|!c1|c2|!c3));
 
 assign h1 = !((c0|!c1|c2|!c3)&(c0|!c1|!c2|c3)&(!c0|c1|!c2|!c3)&
            (!c0|!c1|c2|c3)&(!c0|!c1|!c2|c3)&(!c0|!c1|!c2|!c3));

 assign h2 = !((c0|c1|!c2|c3)&(!c0|!c1|c2|c3)&
            (!c0|!c1|!c2|c3)&(!c0|!c1|!c2|!c3));

 assign h3 = !((c0|c1|c2|!c3)&(c0|!c1|c2|c3)&(c0|!c1|!c2|!c3)&
             (!c0|c1|!c2|c3)&(!c0|!c1|!c2|!c3));
 
 assign h4 = !((c0|c1|c2|!c3)&(c0|c1|!c2|!c3)&(c0|!c1|c2|c3)&
             (c0|!c1|c2|!c3)&(c0|!c1|!c2|!c3)&(!c0|c1|c2|!c3));
 
 assign h5 = !((c0|c1|c2|!c3)&(c0|c1|!c2|c3)&(c0|c1|!c2|!c3)&
             (c0|!c1|!c2|!c3)&(!c0|!c1|c2|!c3));
 
 assign h6 = !((c0|c1|c2|c3)&(c0|c1|c2|!c3)&
             (c0|!c1|!c2|!c3)&(!c0|!c1|c2|c3));
 
endmodule
