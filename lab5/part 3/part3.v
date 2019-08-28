//Modules used: 8_to_1 mux, counterm 13_bit shift register and LEDR, SW, KEY
//MODULE 1: mux for letter selection

`timescale 10ms / 10ms

module letterMux (s1, s2, s3, out);

input s1, s2, s3;
output reg [12:0]out;
always @(*)

begin
case ({s1, s2, s3})
			3'b000:out = 13'b0000000010101;

													 3'b001:out = 13'b0000000000111;

													 3'b010:out = 13'b0000001110101;

													 3'b011:out = 13'b0000111010101;

													 3'b100:out = 13'b0000111011101;

													 3'b101:out = 13'b0011101010111;

													 3'b110:out = 13'b1110111010111;

													 3'b111:out = 13'b0010101110111;

													 default out = 0;

								  endcase

				end



endmodule



//MODULE GROUP 2: 13 bit Shift Register

module shiftRegister(data, en, load, reset, shiftOut);

input en;

input load;

input reset;

input [12:0]data;

output shiftOut;

wire [12:0] W;


subcircuit unit1(.loadValue(data[0]), .Qprev(1'b0), .loadn(load), .resetn(reset),  .Enable(en), .out(W[0]));

subcircuit unit2(.loadValue(data[1]), .Qprev(W[0]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[1]));

subcircuit unit3(.loadValue(data[2]), .Qprev(W[1]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[2]));

subcircuit unit4(.loadValue(data[3]), .Qprev(W[2]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[3]));

subcircuit unit5(.loadValue(data[4]), .Qprev(W[3]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[4]));

subcircuit unit6(.loadValue(data[5]), .Qprev(W[4]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[5]));

subcircuit unit7(.loadValue(data[6]), .Qprev(W[5]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[6]));

subcircuit unit8(.loadValue(data[7]), .Qprev(W[6]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[7]));

subcircuit unit9(.loadValue(data[8]), .Qprev(W[7]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[8]));

subcircuit unit10(.loadValue(data[9]), .Qprev(W[8]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[9]));

subcircuit unit11(.loadValue(data[10]), .Qprev(W[9]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[10]));

subcircuit unit12(.loadValue(data[11]), .Qprev(W[10]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[11]));

subcircuit unit13(.loadValue(data[12]), .Qprev(W[11]), .loadn(load), .resetn(reset),  .Enable(en), .out(W[12]));


assign shiftOut = W[12];


endmodule



//SUBCIRCUIT FOR SHIFT REGISTER

module subcircuit(loadValue, Qprev, loadn, resetn, Enable, out);



input loadValue, Qprev, loadn, resetn, Enable;

output out;

wire w1;


mux2to1 m2(.x(Qprev), .y(loadValue) , .s(loadn), .m(w1));

Register r1( .Reset_b(resetn), .I(w1), .O(out), .enable(Enable));


endmodule



//MUX MODULE FOR SHIFT REGISTER

module mux2to1(x, y, s, m);

input x; //select 0

input y; //select 1

input s; //select signal

output m; //output



//assign m = s & y | ~s & x;

// OR

assign m = s ? y : x;



endmodule



//MODULE REGISTER LOGIC

module Register( Reset_b, I, O, enable);



 input enable;

 input Reset_b;

 input I;

 output reg O; //output



always@(posedge enable)

begin

if(!Reset_b)

begin

O <= 0;

end

else

begin   

O <= I;

end

end



endmodule



//MODULE GROUP 3: Counter to control enable



module rateDivideCount (pulseWidth, pulse, clk);

input [25:0] pulseWidth; //the number that counter needs to count till

reg [25:0] counter;

input clk;

output reg pulse;



always @ (posedge clk)

begin


if (counter == pulseWidth)

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









//TOP LEVEL MODULE: logic managment and final output

module part3 (SW, KEY, LEDR, CLOCK_50);



input [2:0]SW;

input [1:0]KEY;

input CLOCK_50;

output [1:0]LEDR;



wire [12:0]muxToRegister;

wire counterSignal;

//mux for input of letters, connect to register with wire muxToRegister

letterMux unit1(.s1(SW[0]), .s2(SW[1]), .s3(SW[2]), .out(muxToRegister));

//Counter, used as enable, connect output to register though counterSignal

rateDivideCount r1(.pulseWidth(26'b01011111010111100000111111), .clk(CLOCK_50), .pulse(counterSignal));

//Register

shiftRegister unit2( .data(muxToRegister), .en(counterSignal), .load(KEY[1]), .reset(KEY[0]), .shiftOut(LEDR[0]));



endmodule

