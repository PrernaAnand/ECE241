module part3(SW, LEDR, KEY);
 
 input [9:0] SW;
 input [3:0] KEY;
 output [7:0] LEDR;
 wire [7:0] W;
 assign LSR = KEY[3];
 
 subcircuit s1(.left(LSR*W[0]), .right(W[6]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[7]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[7]));
 subcircuit s2(.left(W[7]), .right(W[5]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[6]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[6]));
 subcircuit s3(.left(W[6]), .right(W[4]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[5]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[5]));
 subcircuit s4(.left(W[5]), .right(W[3]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[4]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[4]));
 subcircuit s5(.left(W[4]), .right(W[2]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[3]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[3]));
 subcircuit s6(.left(W[3]), .right(W[1]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[2]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[2]));
 subcircuit s7(.left(W[2]), .right(W[0]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[1]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[1]));
 subcircuit s8(.left(W[1]), .right(W[7]), .parallelLoadn(!KEY[1]), .rotateRight(!KEY[2]), .D(SW[0]), .clock(!KEY[0]), .reset(SW[9]), .Out(W[0]));

 assign LEDR = W;
endmodule

module subcircuit(left, right, parallelLoadn, rotateRight, D, clock, reset, Out);

 input parallelLoadn, rotateRight, D, clock, reset, right, left;
 output Out;
 wire w3, w5;
 mux2to1 m1(.x(right), .y(left) , .s(rotateRight), .m(w3));
 mux2to1 m2(.x(D), .y(w3) , .s(parallelLoadn), .m(w5));
 Register r1(.Clock(clock), .Reset_b(reset), .I(w5), .O(Out));
 
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

module Register(Clock, Reset_b, I, O);

	  input Clock;
	  input Reset_b;
	  input I;
	  output reg O; //output
	  always@(posedge Clock)
	  begin
		 if(Reset_b == 1'b1) 
		  begin
			O <= 0;
		  end
		 else
		  begin	
			O <= I;
	     end 
	  end
endmodule
