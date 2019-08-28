module MUX(SW, LEDR);
	input [9:0] SW;
   output [9:0] LEDR;
  	wire w1, w2, w3;
	
	modNOT m1(.pin1(SW[0]), .pin2(w1));
   modAND m2(.pin1(SW[0]), .pin2(SW[2]), .pin3(w3));
	modAND m3(.pin4(SW[1]), .pin5(w1), .pin6(w2));
	modOR m4(.pin1(w2), .pin2(w3), .pin3(LEDR[0]));
endmodule

module modNOT(pin1, pin2);
   input pin1;
	output pin2;
	not(pin2,pin1);
endmodule

module modAND(pin1, pin2, pin3, pin4, pin5, pin6);
   input pin1, pin2, pin4, pin5;
	output pin3, pin6;
	
	assign pin3 = pin2&pin1;
	assign pin6 = pin4&pin5;
endmodule

module modOR(pin1, pin2, pin3);
   input pin1, pin2;
	output pin3;
	or(pin3, pin2, pin1);
endmodule


	
