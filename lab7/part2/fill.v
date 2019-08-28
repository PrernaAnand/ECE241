// Part 2 skeleton

module fill
	(
		CLOCK_50, //	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input	CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					
	// Declare your inputs and outputs here
	input [9:0] SW;
	
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	
	
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x, y, colour and writeEn
	// for the VGA controller, in addition to any other functionality	your design may require.
	
	//CHANGE THE THING 
	FSM F1(.Reset(resetn), .Clk(CLOCK_50), .Black(!KEY[2]), .Plot(!KEY[1]), 
	.GOxy(!KEY[3]), .Plot_vga(writeEn), .xy(SW[6:0]), .CLR(SW[9:7]), 
	.X_reg(x), .Y_reg(y), .C_reg(colour));

	
endmodule

module FSM(input Reset, Clk, Black, Plot, GOxy, output Plot_vga, input [6:0] xy,
   input [2:0] CLR, output [7:0] X_reg, output [6:0] Y_reg, output [2:0] C_reg);

 wire Ldx, Ldy, Ldblk;
 wire [7:0]Y, XX, YY;
 assign Y_reg = Y[6:0]; //the output from Datapath
 
 FSM_control F1(.reset(Reset), .black(Black), .clock(Clk), .plot(Plot), 
                .goXY(GOxy), .ld_x(Ldx), .ld_y(Ldy), .ld_blk(LDblk), 
					 .plot_vga(Plot_vga), .xx(XX), .yy(YY));
					 
 FSM_datapath F2(.reset(Reset), .clock(Clk), .ld_x(Ldx), .ld_y(Ldy), 
                 .ld_blk(Ldblk), .plot_vga(Plot_vga), .xx(XX), .yy(YY), 
					  .XY(xy), .Clr(CLR), .X_r(X_reg), .Y_r(Y), .C_r(C_reg));

endmodule

module FSM_control(reset, black, clock, plot, goXY, ld_x, ld_y, ld_blk, plot_vga, xx, yy); 

 input reset; //KEY0
 input clock; //CLOCK_50
 input plot; //KEY1
 input black; //KEY2
 input goXY; //KEY3
 output reg ld_x, ld_y, ld_blk, plot_vga; //load
 output reg [7:0] xx, yy; //position
 
 reg [4:0] current_state, next_state; 
 
			  localparam WAIT = 4'd0,
							 LOAD_X = 4'd1,
							 X_WAIT = 4'd2,
							 LOAD_Y = 4'd3,
							 Y_WAIT = 4'd4,
							 LOAD_BLACK = 4'd5,
							 BLACK_WAIT = 4'd6,
							 DRAW = 4'd7,
							 DRAW_WAIT = 4'd8;
				 
			  localparam shape_x = 8'd4,
							 shape_y = 8'd4,
							 window_x = 8'd160,
							 window_y = 8'd120;
				
				// state table
				always @(*)
				begin

					case (current_state)
					
					 WAIT: begin
					   if((black == 1'b1) && (goXY == 1'b0)) //load black
						   next_state = LOAD_BLACK;
						if((black == 1'b0) && (goXY == 1'b1)) //load X
						   next_state = LOAD_X;
						else
						   next_state = WAIT;
						end
						
					 LOAD_X: begin
					    
						 if((goXY == 1'b1) && (black == 1'b0)) //load X
						    next_state = X_WAIT;
						 else if((black == 1'b1)) //load black
						    next_state = LOAD_BLACK;
						 else if(goXY == 1'b0)
						    next_state = LOAD_X;
						 end
					 
					 X_WAIT: begin
						 next_state = goXY ? X_WAIT : LOAD_Y;
						 end
					 
					 
					 LOAD_Y: begin
					    if((goXY == 1'b1) && (black == 1'b0)) //load X
						    next_state = Y_WAIT;
						 else if((black == 1'b1)) //load black
						    next_state = LOAD_BLACK;
						 else if(goXY == 1'b0)
						    next_state = LOAD_Y;
						 end
					 
					 Y_WAIT:begin
						 next_state = goXY ? Y_WAIT : DRAW;
						 end
						 
					 DRAW: begin
					    if((plot == 1'b1) && (black == 1'b0))
						    next_state = DRAW_WAIT;
						 else if(black == 1'b1)
						    next_state = LOAD_BLACK;
						 else
					       next_state = DRAW;
						 end 
					 
					 DRAW_WAIT: begin
					    next_state= plot ? DRAW_WAIT : WAIT;
						 end
						 
					 LOAD_BLACK: begin
					    next_state= black ? LOAD_BLACK : BLACK_WAIT;
						 end
						 
					 BLACK_WAIT: begin
					    next_state= black ? BLACK_WAIT : WAIT;
						 end			 			 
					endcase

				end // state_table

 always @(*)
    begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
        ld_blk = 1'b0;
		  plot_vga = 1'b0;
		  xx = 8'd0;
		  yy = 8'd0;
		  
		  case (current_state)
            LOAD_X: begin
                ld_x = 1'b1; //loads the register
					 plot_vga = 1'b0; 
                end
            LOAD_Y: begin
                ld_y	 = 1'b1;
					 plot_vga = 1'b0;
                end
				DRAW: begin
					 plot_vga = 1'b1;
					 xx = shape_x;
					 yy = shape_y;
					 end
				LOAD_BLACK: begin
				    ld_blk = 1'b1;
					 plot_vga = 1'b1;
					 xx = window_x;
					 yy = window_y;
				    end 
         endcase
     end
	  
 always@(*)
   begin
	 if(!reset)
	   current_state = WAIT;
	 else
	   current_state = next_state;
	end
	 
endmodule


module FSM_datapath(input reset, clock, ld_x, ld_y, ld_blk, plot_vga, input [7:0] xx, yy, input [6:0] XY, input [2:0] Clr, output reg [7:0] X_r, Y_r, output reg [2:0] C_r);


   reg [7:0] X, Y, count_x, count_y;
	reg [2:0] C;
	
	always@(posedge clock)
	 begin
	    if(!reset)
		    begin
				  X <= 8'b0;
				  Y <= 8'b0;
				  C <= 3'b0;
				  count_x <= 8'b0;
				  count_y <= 8'b0;
				  // we are also setting these to 0, so =8'b0
				  Y_r<= Y;
				  X_r<= X;
				  C_r<= C;
			 end
		 else 
  			  if(ld_x == 1'b1)
				 begin 
				 X <= {1'b0, XY};
				 X_r <= X; 
				 end 
			if(ld_y == 1'b1)
				begin
				 Y <= {1'b0, XY}; 
				 C <= Clr;
				 C_r<= C; 
				 Y_r <= Y;
				end
			 if(ld_blk == 1'b1) begin
				  X <= 8'b0;
				  Y <= 8'b0;
				  C <= 3'b0;
				  // we are also setting these to 0, so =8'b0
				  Y_r<= Y;
				  X_r<= X;
				  C_r<= C;
			end
			
			//plotting the points on the screen
			
			//plotting the x values, without incrementing y 
			if ((xx > 8'd0) & (plot_vga == 1'b1) & (count_x < (xx-1'b1)))
			begin
				
				count_x <= count_x+1'b1; 
			end
			//after all the x values have been plotted
			else if ((count_x == (xx- 1'b1)) & (xx > 8'd0) & (plot_vga == 1'b1))  
				begin
				count_x <= 8'd0; //reset x for the next iteration
				count_y <= count_y + 1'b1; //incrementing y 
				end
				
			//after the end case has been reached  
			if ((count_y == yy - 1'b1) & (count_x == 8'd0) &(plot_vga == 1'b1) & (yy > 8'd0))
			begin
				count_y <= 8'd0;
			end 
			
			
			if (plot_vga == 1'b1) 
			begin 
			//offsets the plot to start plotting at the x-y graph 
				X_r <= X + count_x; 
				Y_r <= Y + count_y;
			end 
			else
				begin
					X_r <= 8'd0;
					Y_r <= 8'd0;
				end 
			end
endmodule
