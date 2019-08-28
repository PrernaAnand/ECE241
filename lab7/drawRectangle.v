`timescale 1ns / 1ns // `timescale time_unit/time_precision


/* module that handles the action of drawing rectangles */
module drawRectangle (input clk, resetn, go_X_Y, go_Drw, go_Blk, input [6:0] X_Y_pos, input 
							[2:0] C_in, output [7:0] X, output [6:0] Y, output [2:0] C, output plot);

				wire ld_X, ld_Y_C, blk;
				wire [7:0] Y_out, max_X, max_Y;
				
				assign Y = Y_out[6:0];
				
				control C1 (.clk(clk), .resetn(resetn), .go_X_Y(go_X_Y), .go_Drw(go_Drw), .go_Blk(go_Blk), 
								.ld_X(ld_X), .ld_Y_C(ld_Y_C), .plot(plot), .blk(blk), .ii(max_X), .jj(max_Y));
				
				datapath D1 (.clk(clk), .resetn(resetn), .ld_X(ld_X), .ld_Y_C(ld_Y_C), .blk(blk), .ii(max_X),
								.jj(max_Y), .X_Y_in(X_Y_pos), .C_in(C_in), .X_r(X), .Y_r(Y_out), .C_r(C), 
								.plot(plot));

endmodule // drawRectangle


/* module for controlling registers and state transitons */
module control (input clk, resetn, go_X_Y, go_Drw, go_Blk, output reg ld_X, ld_Y_C,	plot, 
					blk, output reg [7:0] ii, jj);

				reg [3:0] current_state, next_state;
				// state_FF assignments
				localparam  KEY_WAIT			= 4'd0,
								LOAD_X			= 4'd1,
								LOAD_X_WAIT		= 4'd2,
								LOAD_Y_C			= 4'd3,
								LOAD_Y_C_WAIT  = 4'd4,
								PRINT_BLACK		= 4'd5,
								BLACK_WAIT		= 4'd6,
								DRW_SHP			= 4'd7,
								DRW_SHP_WAIT 	= 4'd8;
				// shape and window sizes
				localparam	SHAPE_SZ_X		= 8'd4,//8'd4,
								SHAPE_SZ_Y		= 8'd4,//8'd4,
								WINDOW_SZ_X		= 8'd4,//8'd160,
								WINDOW_SZ_Y		= 8'd2;//8'd120;
				
				// state table
				always @(*)
				begin

					case (current_state)
						// remain at KEY_WAIT state until a valid key is pressed
						KEY_WAIT: 	begin
											// if only go_Blk is pressed
											if ((go_Blk == 1'b1) & (go_X_Y == 1'b0))
												next_state = PRINT_BLACK;
											// if only go_X is pressed
											else if ((go_Blk == 1'b0) & (go_X_Y == 1'b1))
												next_state = LOAD_X;
											// if another invalid combination is pressed
											else
												next_state = KEY_WAIT;
										end
						// load x position
						LOAD_X: 		begin
											// if only go_X is pressed
											if ((go_X_Y == 1'b1) & (go_Blk == 1'b0))
												next_state = LOAD_X_WAIT;
											// if go_Blk is pressed
											else if (go_Blk == 1'b1)
												next_state = PRINT_BLACK;
											else
												next_state = LOAD_X;	
										end
						// wait until go_X goes low
						LOAD_X_WAIT: 	next_state = go_X_Y ? LOAD_X_WAIT : LOAD_Y_C; 
						// load y position
						LOAD_Y_C: 	begin
											// if only go_Y is pressed
											if ((go_X_Y == 1'b1) & (go_Blk == 1'b0))
												next_state = LOAD_Y_C_WAIT;
											// if go_Blk is pressed
											else if (go_Blk == 1'b1)
												next_state = PRINT_BLACK;
											else
												next_state = LOAD_Y_C;
										end	
						// wait until go_Y goes low
						LOAD_Y_C_WAIT: next_state = go_X_Y ? LOAD_Y_C_WAIT : DRW_SHP;
						// draw to frame buffer
						DRW_SHP:		begin
											// dont goto draw state w8 unless work is done
											// if only go_Drw is pressed
											if ((go_Drw == 1'b1) & (go_Blk == 1'b0))
												next_state = DRW_SHP_WAIT;
											// if go_Blk is pressed
											else if (go_Blk == 1'b1)
												next_state = PRINT_BLACK;
											else
												next_state = DRW_SHP;
										end
						// start over after drawing
						DRW_SHP_WAIT: next_state = go_Drw ? DRW_SHP_WAIT : KEY_WAIT;
						// load black for all pixels
						PRINT_BLACK: 	next_state = go_Blk ? BLACK_WAIT : PRINT_BLACK;
						// wait untile go_Blk goes low
						BLACK_WAIT:		next_state = go_Blk ? BLACK_WAIT : KEY_WAIT;
						// stay at KEY_WAIT by default
						default: 		next_state = KEY_WAIT;
					endcase

				end // state_table
   
				// output logic for datapath control signals
				always @(*)
				begin
				
					// all signals are 0 by default, to avoid latches
					ld_X	= 1'b0;
					ld_Y_C= 1'b0;
					blk 	= 1'b0;
					plot  = 1'b0;
					ii 	= 8'd0;
					jj 	= 8'd0;
					
					case (current_state)
						LOAD_X: 		begin
											ld_X = 1'b1; // enable load for register X
										end
						LOAD_Y_C: 	begin
											ld_Y_C = 1'b1; // enable load for register Y and C
										end
						DRW_SHP_WAIT:begin // draw square
											// enable plot to store values into frame buffer
											plot = 1'b1;
											// max cycles for traversing along row (x) axis
											ii = SHAPE_SZ_X;
											// max cycles for traversing along column (y) axis
											jj = SHAPE_SZ_Y;
										end
						BLACK_WAIT:	begin 
											// load black for all pixels in the window
											blk = 1'b1;
											// enable plot to store values into frame buffer
											plot = 1'b1;
											// max cycles for traversing along row (x) axis
											ii = WINDOW_SZ_X;
											// max cycles for traversing along column (y) axis
											jj = WINDOW_SZ_Y;
										end
					endcase // no default needed; all of our outputs were assigned a value 
				
				end // enable_signals

				// current_state registers
				always @(posedge clk)
				begin
					if(!resetn)
						current_state <= KEY_WAIT;
					else
						current_state <= next_state;
				end // state_FFs transition

endmodule // control


/* datapath module */
module datapath (input clk, resetn, ld_X, ld_Y_C, blk, plot, input [7:0] ii, jj, input [6:0] X_Y_in,
                 input [2:0] C_in, output reg [7:0] X_r, Y_r, output reg [2:0] C_r);

				// input registers
				reg [7:0] X, Y, cnt_ii, cnt_jj; 
				reg [2:0] C;

				// registers X, Y, C with respective input logic
				always @(posedge clk)
				begin  
				  if(!resetn) 
				  begin
						X 		<= 8'd0; 
						Y 		<= 8'd0;
						cnt_ii<= 8'd0;
						cnt_jj<= 8'd0;
						C		<= 3'd0;
						X_r 	<= X;
						Y_r 	<= Y;
						C_r 	<= C;
				  end
				  
				  else 
				  begin
						// load X and X_r
						if (ld_X == 1'b1)
						begin
							 X 	<= {1'b0, X_Y_in};
							 X_r 	<= X;
						end
						// load Y, C, Y_r, C_r
						if (ld_Y_C == 1'b1)
						begin
							 Y 	<= {1'b0, X_Y_in};
							 C 	<= C_in;
							 Y_r 	<= Y;
							 C_r 	<= C;
						end
						//set (X,Y) to (0,0) and load C with black
						if (blk == 1'b1)
						begin
							X 		<= 8'd0; 
							Y 		<= 8'd0; 
							C		<= 3'd0;
							X_r 	<= X;
							Y_r 	<= Y;
							C_r 	<= C;
						end
						// increment X and Y by ii and jj respectively
						if ((cnt_ii == (ii - 1'b1)) & (ii > 8'd0) & (plot == 1'b1))
						begin
							cnt_ii <= 8'd0;
							cnt_jj <= cnt_jj + 1'b1;
						end
						
						else if ((ii > 8'd0) & (plot == 1'b1))
						begin
							cnt_ii <= cnt_ii + 1'b1;
						end
						
						if ((cnt_jj == (jj - 1'b1)) & (cnt_ii == (ii - 1'b1)) 
							& (jj > 8'd0) & (plot == 1'b1))
						begin
							cnt_jj <= 8'd0;
						end
						
						if (plot == 1'b1)
						begin
							X_r <= X + cnt_ii;
							Y_r <= Y + cnt_jj;
						end
						else
						begin
							X_r <= 8'd0;
							Y_r <= 8'd0;
						end
					end
				end

endmodule // datapath