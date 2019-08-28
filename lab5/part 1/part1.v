module part1(SW, KEY, HEX0, HEX1);
  input [1:0] SW;
  input [1:0]KEY;
  input [6:0] HEX0;
  input [6:0] HEX1;
  wire [7:0] W;
  
  TFF_AND Q0 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(SW[1]), .Q(W[0]));
  TFF_AND Q1 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(W[0]), .Q(W[1]));
  TFF_AND Q2 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(W[1]), .Q(W[2]));
  TFF_AND Q3 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(W[2]), .Q(W[3]));
  TFF_AND Q4 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(W[3]), .Q(W[4]));
  TFF_AND Q5 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(W[4]), .Q(W[5]));
  TFF_AND Q6 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(W[5]), .Q(W[6]));
  TFF_AND Q7 (.Clock(!KEY[0]), .Clear_b(SW[0]), .Enable(W[6]), .Q(W[7]));
  
  //HEX0 - for the first four TFF+AND
  Display D1(.I(W[3:0]), .O(HEX0[6:0]));
  
  //HEX1 - for the second four TFF+AND
  Display D2(.I(W[7:4]), .O(HEX1[6:0]));
  
endmodule


module TFF_AND(Clock, Clear_b, Enable, Q);
  input Clock, Clear_b, Enable;
  output Q;
  wire w1;
  
  T_FF T1(.clock(Clock), .clear_b(Clear_b), .enable(Enable), .q(w1));
  and(Q, w1, Enable);

endmodule


module T_FF(clock, clear_b, enable, q); //TFF
  input clock, clear_b, enable;
  output reg q;
  
  always@(posedge clock, negedge clear_b) // Clock (0->1), Clear_b(1->0)
  
   if(!clear_b) // if reset is 1 set - everything is set to 0 - concurrently
	  q <= 0;
	else if(clear_b) // if reset is 0 set - Do nothing 
	 begin
	  if(enable) //else if enable is 1 - You add 1 
      q <= q + 1; 
	  else if(!enable) // if enable is 0 - Do nothing
	   q <= q;
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