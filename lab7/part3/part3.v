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
	
	wire resetn, screen_blk;
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
	wire [6:0] y_coordinate;
	wire [7:0] x_coordinate;
	wire ldx, ldy;
	
	FSM_control C(.reset(), .clock(), .ld_x(), .ld_y(), .ld_blk(), .plot(writeEn), 
	              .X_crd(), .Y_crd());	
	FSM_datapath D(.reset(resetn), .clock(CLOCK_50), .ld_x(ldx), .ld_y(ldy), .Y_crd(y_coordinate), .X_crd(x_coordinate), 
	               .Clr(Sw[9:7]), .X_r(x), .Y_r(y), .C_r(colour));
		
endmodule

module FSM_control( input reset, clock, output reg ld_x, ld_y, ld_blk, plot, 
	               output reg [7:0] X_crd, output reg [6:0] Y_crd());
						
//THERE IS A CLOCK-UP (haha geddit) IN THE DUDE'S CODE  					
//clock divider - 60 Hz
wire clk; 
//add the adder module counter here.
//moves in the direction specified by these
reg horizontal, vertical;

//moves x and y depending on if the move state has been reached
reg move_x, move_y;
 
 
 
//clock triggered movement - triggers 4 times every 15 frames.
//updates the values of x and y in the direction specified
always @ (posedge clk) begin //should I change this to *?? 
	if (move_x) begin
		if (horizontal) //if move right
			X_crd <= X_crd + 1'b0;
		else 
			X_crd <= X_crd - 1'b0;
	end 
	
	if (move_y) begin
	if (vertical) //if move down 
		Y_crd <= Y_crd + 1'b0;
	else 
		Y_crd <= Y_crd - 1'b0;
	end 
end 

//state table 
reg [3:0] current_state, next_state;

//define states 
localparam		S_initial = 4'd0; //plots at 0,0 
					S_plot = 4'd1; 
					S_update_position = 4'd2;
					S_erase = 4'd3; 
					S_move = 4'd4; 
						
always @(*)
	begin:state_table
	case (current_state) 
		S_initial: next_state = S_plot;
		S_plot: next_state = S_update_position;
		
		//boxDrawn is a second counter seeing 60 frames are done
		S_update_position: next_state = boxDrawn? S_erase : S_update_position;
		S_erase: next_state = S_move;
		S_move: next_state = S_plot; 
		default: next_state = S_inital; //in case resetn is encountered
	endcase
end 

always @(*)
begin

ld_x = 1'b0;
ld_y = 1'b0;
ld_blk = 1'b0;
plot = 1'b0; 
move_x = 1'b0;
move_y = 1'b0;

S_intial: begin
				X_crd = 8'b0;
				Y_crd = 7'b0;
				horizontal = 1'b1; 
				vertical = 1'b0; //down
			end 
S_plot: plot = 1'b1; 
S_update_position: begin //triggers every 15 frames 
							move_x = 1'b1;
							move_y = 1'b1; 
						end 
S_erase: ld_blk = 1'b1; 
S_move: begin
			//load the x and y registers with the updated values
			ld_x = 1'b1; 
			ld_y = 1'b1; 
			
			//checking for when to bounce 
			if ((X_Crd == 8'b1) && (horizontal == 1'b1))
			horizontal = 1'b0;
			
			if ((X_Crd == 8'b0) && (horizontal == 1'b0))
			horizontal = 1'b1;
	
			if ((Y_Crd == 7'b1) && (vertical == 1'b1))
			vertical = 1'b0;
			
			if ((X_Crd == 7'b0) && (vertical == 1'b0))
			vertical = 1'b1;
			
			end 
end 
			
always @(posedge clock)
begin
if (!reset)
	current_state <= S_initial; 
else
	current_state <= next_state; 
	
end 

endmodule

module FSM_datapath(input reset, clock, ld_x, ld_y, input [6:0] Y_crd, 
                    input [7:0] X_crd , input [2:0] Clr, output reg [7:0] X_r,
						  output reg [7:0] Y_r, output reg [2:0] C_r);

    always@(posedge clock)
	 begin
	    if(!reset)
		    begin
				  X_r <= 8'b0;
				  Y_r <= 7'b0;
				  C_r <= 3'b0;
			 end
		 else 
		   begin
  			  if(ld_x == 1'b1)
				 begin 
				 X_r <= X_crd; 
				 end 
			  if(ld_y == 1'b1)
				 begin
				 Y_r <= Y_crd;
				end
		 C_r <= Clr;
			 end
			 
endmodule
