`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:32 06/28/2011 
// Design Name: 
// Module Name:    data_out 
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
module data_out(
	input [12:0] DVX_in,
	input [12:0] DVY_in,
	input strobe,
	input SCALELD_not,
	output reg [12:0] DVX_out,
	output reg [12:0] DVY_out,
	output reg [7:0] linscale,
	output reg x0,
	output reg y0
   );
	

	reg [12:0] DVY_in_inv;
	reg [12:0] DVX_in_inv;
	reg [12:0] DVXa;
	reg [12:0] DVYa;
	
	always @(DVX_out) begin
		if (DVX_out[11:3] == 9'h000) begin
			x0 = 1;
			end
		else begin
			x0 = 0;
			end
		end
		
	always @(DVY_out) begin
		if (DVY_out[11:3] == 9'h000) begin
			y0 = 1;
			end
		else begin
			y0 = 0;
			end
		end

	
	always @(negedge SCALELD_not) begin
		linscale = ~DVY_in[7:0];
		end
	

	always @(DVX_in or DVY_in) begin
		DVXa = DVX_in; 
		DVYa = DVY_in; 
		end
	
	always @(DVXa) begin
		DVX_in_inv[11:0] = DVXa[11:0];
		DVY_in_inv[11:0] = DVYa[11:0];
		DVX_in_inv[12] = ~DVXa[12];
		DVY_in_inv[12] = ~DVYa[12];
		end

	
	always @(negedge strobe) begin
		DVX_out = DVX_in_inv;
		DVY_out = DVY_in_inv;
		end


endmodule
