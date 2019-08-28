`timescale 10ms/10ms 
 
module Lab7part3(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		SW,
		KEY,
		// The ports below are for the VGA output.  Do not change.
//		VGA_CLK,   						//	VGA Clock
//		VGA_HS,							//	VGA H_SYNC
//		VGA_VS,							//	VGA V_SYNC
//		VGA_BLANK_N,						//	VGA BLANK
//		VGA_SYNC_N,						//	VGA SYNC
//		VGA_R,   						//	VGA Red[9:0]
//		VGA_G,	 						//	VGA Green[9:0]
//		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	// Declare your inputs and outputs here
	input			[9:7] SW;
	input			[1:0] KEY;
//	// Do not change the following outputs
//	output			VGA_CLK;   				//	VGA Clock
//	output			VGA_HS;					//	VGA H_SYNC
//	output			VGA_VS;					//	VGA V_SYNC
//	output			VGA_BLANK_N;				//	VGA BLANK
//	output			VGA_SYNC_N;				//	VGA SYNC
//	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
//	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
//	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
//	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire ld_x;
	wire ld_y;
	wire ld_r;
	wire erase;
	wire [3:0] count;
	wire [7:0] x_count;
	wire [6:0] y_count;
	wire frame;
	wire move;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
//	vga_adapter VGA(
//			.resetn(resetn),
//			.clock(CLOCK_50),
//			.colour(colour),
//			.x(x),
//			.y(y),
//			.plot(writeEn),
//			/* Signals for the DAC to drive the monitor. */
//			.VGA_R(VGA_R),
//			.VGA_G(VGA_G),
//			.VGA_B(VGA_B),
//			.VGA_HS(VGA_HS),
//			.VGA_VS(VGA_VS),
//			.VGA_BLANK(VGA_BLANK_N),
//			.VGA_SYNC(VGA_SYNC_N),
//			.VGA_CLK(VGA_CLK));
//		defparam VGA.RESOLUTION = "160x120";
//		defparam VGA.MONOCHROME = "FALSE";
//		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
//		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
		
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	control c(
		.clk(CLOCK_50),
		.go(KEY[1]),
		.resetn(KEY[0]),
		.ld_x(ld_x),
		.ld_y(ld_y),
		.ld_r(ld_r),
		.erase(erase),
		.plot(writeEn),
		.count(count)
	);

	datapath d(
		.x(x_count),
		.y(y_count),
		.ld_x(ld_x),
		.ld_y(ld_y),
		.ld_r(ld_r),
		.erase(erase),
		.color(SW[9:7]),
		.resetn(KEY[0]),
		.clk(CLOCK_50),
		.count(count),
		.x_to_plot(x),
		.y_to_plot(y),
		.color_to_plot(colour)
	);
	
	x_counter xc(
		.enable(move),
		.resetn(KEY[0]),
		.x(x_count)
	);
	
	y_counter yc(
		.enable(move),
		.resetn(KEY[0]),
		.y(y_count)
	);
	
	FrameCounter fc(
		.frame(frame),
		.resetn(KEY[0]),
		.enable(move)
	);
	
	DelayCounter dc(
		.clock(CLOCK_50), 
		.reset_n(KEY[0]), 
		.maxcount(28'd12500000),//28'd833334), //60Hz
		.enable(frame)
		);
endmodule 

module control(
	input clk,
	input go,
	input resetn,
	output reg ld_x,
	output reg ld_y,
	output reg ld_r, //to plot
	output reg erase,
	output reg plot,
	output reg [3:0] count
	);
	
	reg [2:0] current_state, next_state;
	
	//states 
	localparam S_LOAD  = 3'd0,
	           S_PLOT  = 3'd1,
			     S_HOLD  = 3'd2,
			     S_ERASE = 3'd3;
	
	//next state logic 
	always@(*)begin
		case(current_state)
			S_LOAD : next_state = S_PLOT; 	
			S_PLOT : next_state = (count == 4'b1111) ? S_HOLD : S_PLOT;
			S_HOLD : next_state = go ? S_ERASE : S_HOLD; //always goes to the next state 
			S_ERASE: next_state = (count == 4'b1111) ? S_LOAD : S_ERASE;
			default: next_state = S_LOAD;
		endcase
	end
	
	//enable signals
	always@(posedge clk)begin
		ld_x = 1'b0;
		ld_y = 1'b0;
		ld_r = 1'b0;
		erase = 1'b0;
		plot = 1'b0;		
		case(current_state)
			S_LOAD : begin
				count <= 4'b0;
				ld_x = 1'b1;
				ld_y = 1'b1;
				ld_r = 1'b1;	
				plot = 1'b1;
			end 
			S_PLOT : begin
				ld_r = 1'b1;
				plot = 1'b1;
				count <= count + 1'b1; //this draws 16 pixels of the box
			end 
			S_HOLD : count <= 4'b0;
			S_ERASE: begin
				ld_r = 1'b1;
				erase = 1'b1;				//loads the colour black
				plot = 1'b1;
				count <= count + 1'b1; //this erases 16 pixels of the box
			end 	
		endcase
	end 
	
	//current state register
	always@(posedge clk) begin
		if(!resetn)
			current_state <= S_LOAD;
		else
			current_state <= next_state;
	end

endmodule

module datapath(
	input [7:0] x,
	input [6:0] y,
	input ld_x,
	input ld_y,
	input ld_r,
	input erase,
	input [2:0] color,
	input resetn,
	input clk,
	input [3:0] count,
	output reg [7:0] x_to_plot,
	output reg [6:0] y_to_plot,
	output reg [2:0] color_to_plot
	);
	
	reg [7:0] x_;
	reg [6:0] y_;
	reg [2:0] color_;
	
	//loads registers x_, y_ with values in the specified direction
	always @(posedge clk) begin
		if (!resetn) begin
			x_ <= 8'b0;
			y_ <= 7'b0;
			color_ <= 3'b0;
		end
		else begin
			color_ <= erase ? 3'b0 : color;
			if(ld_x)
				x_ <= x;
			if(ld_y)
				y_ <= y;			
		end 
	end

	//output register
	always @(posedge clk) begin
		if (!resetn) begin
			x_to_plot <= 8'b0;
			y_to_plot <= 7'b0;
			color_to_plot <= 3'b000;
		end
		else
			if (ld_r) begin   //this draws an individual box 
				x_to_plot <= x_ + count[1:0];
				y_to_plot <= y_ + count[3:2];
				color_to_plot <= color_;
			end 
	end 
	
endmodule

//X counter
module x_counter(
	input enable,
	input resetn,
	output reg [7:0] x
	);
	
	reg right;
	
	always @ (posedge enable, negedge resetn)
	begin
		if (!resetn) begin 
			right <= 1'b1;
			x <= 8'b0;
		end 
		else begin 
			if (x === 8'bx)
				x<= 0;
			if (right & (x + 8'b1 == 8'd160)) //right edge
				right <= 1'b0;
			if (!right & (x - 8'b1 == 8'd0)) //left edge
				right <= 1'b1;	
			if (right) //move right
				x <= x + 1'b1; 
			if (!right) //move left
				x <= x - 1'b1;
		end
	end 
endmodule 

//Y Counter
module y_counter(
	input enable,
	input resetn,
	output reg [6:0] y
	);
	
	reg down;
	
	always @ (posedge enable, negedge resetn)
	begin
		if (!resetn) begin 
			down <= 1'b1;
			y <= 7'b0;
		end 
		else begin
			if ( y === 7'bx)
				y<= 0;
			if (down & (y + 1'b1 == 7'd120)) //bottom edge
				down <= 1'b0;
			if (!down & (y - 1'b1 == 1'd0)) //top edge 
				down <= 1'b1;		
			if (down) //moves to the bottom
				y <= y + 1'b1;
			if (!down) //moves to the top
				y <= y - 1'b1;
		end
	end 
endmodule 

//Frame counter 
module FrameCounter(
	input frame, //clock - 1/60th sec
	input resetn,
	output enable
	);
	reg [3:0] count;
	
	assign enable = (count == 0) ? (1'b1) : (1'b0);
	
	always @ (posedge frame, negedge resetn)
	begin
		if (!resetn)
			count <= 0;
		if (count === 3'bx)
			count <= 0;
		else if (count == (4'b1110)) //triggers every 15 frames.
			count <= 0;
		else
			count <= count + 1'b1;
	end

endmodule 

//Delay counter: triggers every 1/60th of a second = 1 frame 
module DelayCounter(clock, reset_n, maxcount, enable);
	input clock, reset_n;
	input [27:0] maxcount; 
	output enable;
	reg [27:0] count;
	
	assign enable = (count == 0) ? (1'b1) : (1'b0);
		
	always @ (posedge clock, negedge reset_n)
	begin
		if (!reset_n)
			count <= 0;
		if (count === 28'bx)
			count <= 0; 
		else if (count == (maxcount-28'b1))
			count <= 0;
		else
			count <= count + 1'b1;
	end

endmodule