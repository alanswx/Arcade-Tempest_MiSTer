`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:16:02 06/10/2011 
// Design Name: 
// Module Name:    vg_data_shifter 
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
module vg_data_shifter(
	input [7:0] DVG,
	input [3:0] latch,
	input NORM_not,
	input clk_12MHz,
	output reg [12:0] DVX,
	output reg [12:0] DVY,
	output reg [2:0] op,
	output reg [2:0] Z
   );

	reg S1_1, S1_2, S1_3, S1_4, S1_5, S1_6; 
	reg S0_1, S0_2, S0_3, S0_4, S0_5, S0_6;

	// Shifter Control Logic
	always @(latch or NORM_not) begin
		S1_1 = (~latch[1])|(~NORM_not);
		S0_1 = ~latch[1];
		
		S1_2 = (~latch[0])|(~NORM_not);
		S0_2 = ~latch[0];
		
		S1_3 = (~latch[0])|(~NORM_not);
		S0_3 = ~latch[0];
	
		S1_4 = (~latch[3])|(~NORM_not);
		S0_4 = ~latch[3];
		
		S1_5 = (~latch[2])|(~NORM_not);
		S0_5 = ~latch[2];
		
		S1_6 = (~latch[2])|(~NORM_not);
		S0_6 = ~latch[2];
		end

	// Latch 1
	always @(posedge latch[1]) begin
		DVY[12] <= DVG[4];
		op[0] <= DVG[5];
		op[1] <= DVG[6];
		op[2] <= DVG[7];
		end // End Latch 1
		
	// Latch 2
	always @(posedge latch[3] or negedge latch[1]) begin
		if (~latch[1]) begin
			DVX[12] <= 0;
			Z[0] <= 0;
			Z[1] <= 0;
			Z[2] <= 0;
			end
		else begin
			DVX[12] <= DVG[4];
			Z[0] <= DVG[5];
			Z[1] <= DVG[6];
			Z[2] <= DVG[7];
			
			end
		end // End Latch 2
	 
	// Shift Register 1
	always @(posedge clk_12MHz) begin
		case (S1_1) 
			0: 	begin
				case (S0_1)
					0: 	begin		// Hold
						DVY[8] <= DVY[8];
						DVY[9] <= DVY[9];
						DVY[10] <= DVY[10];
						DVY[11] <= DVY[11];
						end
					1:	begin		// Shift Right
						DVY[8] <= DVY[9];
						DVY[9] <= DVY[10];
						DVY[10] <= DVY[11];
						DVY[11] <= 1;
						end
				endcase
				end
			1:	begin
				case (S0_1)
					0:	begin		// Shift Left
						DVY[8] <= DVY[7];
						DVY[9] <= DVY[8];
						DVY[10] <= DVY[9];
						DVY[11] <= DVY[10];
						end
					1: 	begin		// Latch
						DVY[8] <= DVG[0];
						DVY[9] <= DVG[1];
						DVY[10] <= DVG[2];
						DVY[11] <= DVG[3];
						end
				endcase
				end
			endcase
		end // End Shift Register 1
		
	// Shift Register 2
	always @(posedge clk_12MHz or negedge latch[1]) begin
		if (~latch[1]) begin
			DVY[4] <= 0;
			DVY[5] <= 0;
			DVY[6] <= 0;
			DVY[7] <= 0;
			end
		else begin
			case (S1_2) 
				0: 	begin
					case (S0_2)
						0: 	begin		// Hold
							DVY[4] <= DVY[4];
							DVY[5] <= DVY[5];
							DVY[6] <= DVY[6];
							DVY[7] <= DVY[7];
							end
						1:	begin		// Shift Right
							DVY[4] <= DVY[5];
							DVY[5] <= DVY[6];
							DVY[6] <= DVY[7];
							DVY[7] <= 1;
							end
					endcase
					end
				1:	begin
					case (S0_2)
						0:	begin		// Shift Left
							DVY[4] <= DVY[3];
							DVY[5] <= DVY[4];
							DVY[6] <= DVY[5];
							DVY[7] <= DVY[6];
							end
						1: 	begin		// Latch
							DVY[4] <= DVG[4];
							DVY[5] <= DVG[5];
							DVY[6] <= DVG[6];
							DVY[7] <= DVG[7];
							end
					endcase
					end
			endcase
			end
		end // End Shift Register 2

	// Shift Register 3
	always @(posedge clk_12MHz or negedge latch[1]) begin
		if (~latch[1]) begin
			DVY[0] <= 0;
			DVY[1] <= 0;
			DVY[2] <= 0;
			DVY[3] <= 0;
			end
		else begin
			case (S1_3) 
				0: 	begin
					case (S0_3)
						0: 	begin		// Hold
							DVY[0] <= DVY[0];
							DVY[1] <= DVY[1];
							DVY[2] <= DVY[2];
							DVY[3] <= DVY[3];
							end
						1:	begin		// Shift Right
							DVY[0] <= DVY[1];
							DVY[1] <= DVY[2];
							DVY[2] <= DVY[3];
							DVY[3] <= 1;
							end
					endcase
					end
				1:	begin
					case (S0_3)
						0:	begin		// Shift Left
							DVY[0] <= 0;
							DVY[1] <= DVY[0];
							DVY[2] <= DVY[1];
							DVY[3] <= DVY[2];
							end
						1: 	begin		// Latch
							DVY[0] <= DVG[0];
							DVY[1] <= DVG[1];
							DVY[2] <= DVG[2];
							DVY[3] <= DVG[3];
							end
					endcase
					end
			endcase
			end
		end // End Shift Register 3
		
	// Shift Register 4	
	always @(posedge clk_12MHz or negedge latch[1]) begin
		if (~latch[1]) begin
			DVX[8] <= 0;
			DVX[9] <= 0;
			DVX[10] <= 0;
			DVX[11] <= 0;
			end
		else begin
			case (S1_4) 
				0: 	begin
					case (S0_4)
						0: 	begin		// Hold
							DVX[8] <= DVX[8];
							DVX[9] <= DVX[9];
							DVX[10] <= DVX[10];
							DVX[11] <= DVX[11];
							end
						1:	begin		// Shift Right
							DVX[8] <= DVX[9];
							DVX[9] <= DVX[10];
							DVX[10] <= DVX[11];
							DVX[11] <= 1;
							end
					endcase
					end
				1:	begin
					case (S0_4)
						0:	begin		// Shift Left
							DVX[8] <= DVX[7];
							DVX[9] <= DVX[8];
							DVX[10] <= DVX[9];
							DVX[11] <= DVX[10];
							end
						1: 	begin		// Latch
							DVX[8] <= DVG[0];
							DVX[9] <= DVG[1];
							DVX[10] <= DVG[2];
							DVX[11] <= DVG[3];
							end
					endcase
					end
			endcase
			end
		end // End Shift Register 4

	// Shift Register 5
	always @(posedge clk_12MHz or negedge latch[1]) begin
		if (~latch[1]) begin
			DVX[4] <= 0;
			DVX[5] <= 0;
			DVX[6] <= 0;
			DVX[7] <= 0;
			end
		else begin
			case (S1_5) 
				0: 	begin
					case (S0_5)
						0: 	begin		// Hold
							DVX[4] <= DVX[4];
							DVX[5] <= DVX[5];
							DVX[6] <= DVX[6];
							DVX[7] <= DVX[7];
							end
						1:	begin		// Shift Right
							DVX[4] <= DVX[5];
							DVX[5] <= DVX[6];
							DVX[6] <= DVX[7];
							DVX[7] <= 1;
							end
					endcase
					end
				1:	begin
					case (S0_5)
						0:	begin		// Shift Left
							DVX[4] <= DVX[3];
							DVX[5] <= DVX[4];
							DVX[6] <= DVX[5];
							DVX[7] <= DVX[6];
							end
						1: 	begin		// Latch
							DVX[4] <= DVG[4];
							DVX[5] <= DVG[5];
							DVX[6] <= DVG[6];
							DVX[7] <= DVG[7];
							end
					endcase
					end
			endcase
			end
		end // End Shift Register 5

	// Shift Register 6
	always @(posedge clk_12MHz or negedge latch[1]) begin
		if (~latch[1]) begin
			DVX[0] <= 0;
			DVX[1] <= 0;
			DVX[2] <= 0;
			DVX[3] <= 0;
			end
		else begin
			case (S1_6) 
				0: 	begin
					case (S0_6)
						0: 	begin		// Hold
							DVX[0] <= DVX[0];
							DVX[1] <= DVX[1];
							DVX[2] <= DVX[2];
							DVX[3] <= DVX[3];
							end
						1:	begin		// Shift Right
							DVX[0] <= DVX[1];
							DVX[1] <= DVX[2];
							DVX[2] <= DVX[3];
							DVX[3] <= 1;
							end
					endcase
					end
				1:	begin
					case (S0_6)
						0:	begin		// Shift Left
							DVX[0] <= 0;
							DVX[1] <= DVX[0];
							DVX[2] <= DVX[1];
							DVX[3] <= DVX[2];
							end
						1: 	begin		// Latch
							DVX[0] <= DVG[0];
							DVX[1] <= DVG[1];
							DVX[2] <= DVG[2];
							DVX[3] <= DVG[3];
							end
					endcase
					end
			endcase
			end
		end // End Shift Register 6
		
endmodule
