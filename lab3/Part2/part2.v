module Adder(LEDR, SW);
  
  input [9:0] SW;
  output [9:0] LEDR;
  wire [2:0] W;
  
  FullAdd x1(.Cin(SW[8]), .A(SW[4]), .B(SW[0]), .Cout(W[0]), .S(LEDR[0]));
  FullAdd x2(.Cin(W[0]), .A(SW[5]), .B(SW[1]), .Cout(W[1]), .S(LEDR[1]));
  FullAdd x3(.Cin(W[1]), .A(SW[6]), .B(SW[2]), .Cout(W[2]), .S(LEDR[2]));
  FullAdd x4(.Cin(W[2]), .A(SW[7]), .B(SW[3]), .Cout(LEDR[9]), .S(LEDR[3]));

endmodule
  
module FullAdd(Cin, A, B, S, Cout);

  input Cin, A, B;
  output S, Cout;
  
  assign S = A^B^Cin;
  assign Cout = (A&B)|(A&Cin)|(B&Cin);
  
endmodule