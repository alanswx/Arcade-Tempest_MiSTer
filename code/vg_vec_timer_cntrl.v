`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:23:59 06/10/2011 
// Design Name: 
// Module Name:    vg_vec_timer_cntrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vg_vec_timer_cntrl(
	input [2:0] op,
	input DVY12,
	input DVY11,
	input DVY10,
	input DVY9,
	input DVY8,
	input DVX12,
	input DVX11,
	input [3:0] strobe,
	input STOP_not,
	input VGCK,
	input clk_12MHz,
	input RESET_not,
	input VGRST_not,
	input VGGO_not,
	output reg NORM,
	output reg NORM_not,
	output reg SCALE,
	output reg GO,
	output reg CENTER_not,
	output reg HALT,
	output reg DISRST_not,
	output reg VCTR,
	output reg STATCLK_not, 
	output reg SCALELD_not
	);

	reg clr_NORM; // Clear NORM FF	

	reg [3:0] binary_scale; // Binary scale after latch
	reg [3:0] count = 0; // Input to binary scale decrementer
	reg count_enable_not = 1;
	reg count_load;

	reg CNTR;
	reg CNTR_not;

	reg J_CNTR;
	reg K_CNTR;
	reg J_VCTR;
	reg K_VCTR;

	reg HALT_not;
		
	// NORM D FF 
	always @(DVY12 or DVY11 or DVX12 or DVX11 or SCALE or CNTR or VCTR) begin
		clr_NORM = (DVY12^DVY11)|(DVX12^DVX11)|SCALE|CNTR|VCTR;
		end
		
	always @(posedge strobe[0] or negedge clr_NORM) begin
		if (~clr_NORM) begin
			NORM <= 0;
			NORM_not <= 1;
			end
		else begin
			NORM <= ~op[0];
			NORM_not <= op[0];
			end
		end 
	// End NORM Logic

	// Binary Scale Load and Counter
	always @(DVY12 or strobe or op or count_enable_not) begin
		count_load = (~op[2])&(~strobe[1]);
		STATCLK_not = DVY12|strobe[2]|op[2];
		SCALELD_not = (~DVY12)|strobe[2]|op[2];
		SCALE = (~((~op[2])&(~strobe[1])))&(~count_enable_not);
		end

	always @(posedge SCALELD_not or negedge DISRST_not) begin
		if (~DISRST_not) begin
			binary_scale <= 4'b0000;
			end
		else begin
			binary_scale[3] <= 0;
			binary_scale[2] <= DVY10;
			binary_scale[1] <= DVY9;
			binary_scale[0] <= DVY8;
			end
		end

	always @(posedge clk_12MHz or posedge count_load) begin
		if (count_load) begin
			if (binary_scale == 4'b0000) begin
				count <= binary_scale;
				count_enable_not = 1;
				end
			else begin
				count <= binary_scale;
				count_enable_not = 0;
				end
			end
		else if (~count_enable_not) begin
			if (count == 4'b0001) begin
				count <= 0;
				count_enable_not = 1;
				end
			else begin
				count <= count - 1;
				count_enable_not = 0;
				end
			end 
		end
	// End Binary Scale Logic

	// CNTR and VCTR JK FF
	always @(STOP_not or op or VGCK or strobe) begin
		K_CNTR = STOP_not;
		K_VCTR = STOP_not;
		J_CNTR = (op[2])&((~VGCK)&(~strobe[3]));
		J_VCTR = (~op[2])&(~op[0])&((~VGCK)&(~strobe[3]));
		end

	always @(posedge clk_12MHz or negedge HALT_not) begin
		if (~HALT_not) begin
			CNTR <= 0;
			CNTR_not <= 1;
			end
		else begin
			case (J_CNTR) 
				0: 	begin
						case (K_CNTR)
							0: 	begin
								CNTR <= 0;		// Reset
								CNTR_not <= 1;
								end
							1: 	begin 
								CNTR <= CNTR;	// Hold
								CNTR_not <= CNTR_not;
								end
						endcase
					end
				1:	begin
						case (K_CNTR)
							0: 	begin
								CNTR <= ~CNTR;	// Toggle
								CNTR_not <= ~CNTR_not;
								end
							1: 	begin
								CNTR <= 1;		// Set
								CNTR_not <= 0;
								end
						endcase
					end
			endcase
			end
		end
		
	always @(posedge clk_12MHz or negedge HALT_not) begin
		if (~HALT_not) begin
			VCTR <= 0;
			end
		else begin
			case (J_VCTR) 
				0: 	begin
						case (K_VCTR)
							0: 	VCTR <= 0;		// Reset
							1:  VCTR <= VCTR;	// Hold
						endcase
					end
				1:	begin
						case (K_VCTR)
							0:  VCTR <= ~VCTR;	// Toggle
							1: 	VCTR <= 1;		// Set
						endcase
					end
			endcase
			end
		end
		
	always @(VCTR or CNTR) begin
		GO = VCTR|CNTR;
		end
	// End CNTR/VCTR Logic	


	// Vector Halt Latch
	always @(RESET_not or VGRST_not) begin
		DISRST_not = ~((~RESET_not)|(~VGRST_not));
		end

	always @(posedge strobe[3] or negedge VGGO_not or negedge DISRST_not) begin
		if (~VGGO_not) begin
			HALT <= 0;
			HALT_not <= 1;		
			end
		else if (~DISRST_not) begin
			HALT <= 1;
			HALT_not <= 0;	
			end
		else begin
			HALT <= op[0];
			HALT_not <= ~op[0];
			end
		end
		
	always @(CNTR_not or HALT_not) begin
		CENTER_not = ~((~CNTR_not)|(~HALT_not));
		end

endmodule 
