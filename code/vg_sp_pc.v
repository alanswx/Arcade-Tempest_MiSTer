`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:28 06/10/2011 
// Design Name: 
// Module Name:    vg_sp_pc 
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
module vg_sp_pc(
		input VGGO_not,
		input DISRST_not,
		input AVG0,
		input [2:0] op,
		input [3:0] strobe,
		input [11:0] DVY,
		output reg [11:0] AVG // AVG12 - AVG1
		);
		
	reg pcLoad;
	reg pcClear;
	
	reg [11:0] IB; 		// Internal Bus connecting input buffers, stack, and pc

	reg [11:0] s0; 		// Stack addresses
	reg [11:0] s1;
	reg [11:0] s2;
	reg [11:0] s3;
	reg [11:0] sOut; 	// Output read of Stack
	reg [1:0] sPointer; // Stack Pointer
	reg sRead_not;		// Read Enable
	reg sWrite_not;		// Write Enable


	initial begin
		s0 = 12'h000;
		s1 = 12'h000;
		s2 = 12'h000;
		s3 = 12'h000;
		end

	// Program Counter
	always @(op or strobe or VGGO_not) begin
		pcLoad <= op[2]&(~strobe[2]);
		pcClear <= ~VGGO_not;		
		end
										
	always @(posedge AVG0 or posedge pcClear or posedge pcLoad) begin
		if (pcClear) begin 	// Clear
			AVG <= 12'h000;
			end
		else if (pcLoad) begin 	// Load
			AVG <= IB;
			end
		else begin				// Count Up
			AVG <= AVG + 1;
			end
		end // End Program Counter
		
	// Internal Bus Select
	always @(op[0] or DVY or sOut) begin
		if (op[0]) begin	// Read from data input
			IB <= DVY;
			end
		else if (~op[0]) begin // Read from stack
			IB <= sOut;
			end
		else begin
			IB <= IB;
			end
		end // End IB Select
		
	// Stack Pointer
	always @(posedge strobe[1] or negedge DISRST_not) begin
		if (~DISRST_not) begin 	// Load
			sPointer = 0;
			end
		else  begin 	// Not Enabled
			if (~op[2]) begin
				sPointer = sPointer;
				end
			else begin				// Enabled
				case (op[1])
					0: sPointer = sPointer + 1;	// JSR, After Push
					1: sPointer = sPointer - 1;	// RTS, After Pull
				endcase
				end
			end
		end // End SP


	// Stack
	always @(op or strobe) begin
		sRead_not <= op[0];
		sWrite_not <= ~(op[0]&(~strobe[0])); 
		end

	always @(sPointer or sRead_not or sWrite_not or AVG or s0 or s1 or s2 or s3 or sOut) begin
		if (~sRead_not) begin	// Read sPointer location
			case (sPointer) 
				0: sOut <= s0;
				1: sOut <= s1;
				2: sOut <= s2;
				3: sOut <= s3;
			endcase
			end
		else if (~sWrite_not) begin	// Write sPointer location
			case (sPointer) 
				0: begin
					s0 <= AVG;
					s1 <= s1;
					s2 <= s2;
					s3 <= s3;
					end
				1: begin
					s0 <= s0;
					s1 <= AVG;
					s2 <= s2;
					s3 <= s3;
					end
				2: begin
					s0 <= s0;
					s1 <= s1;
					s2 <= AVG;
					s3 <= s3;
					end
				3: begin
					s0 <= s0;
					s1 <= s1;
					s2 <= s2;
					s3 <= AVG;
					end
			endcase
			end
		else begin
			sOut <= sOut;
			s0 <= s0;
			s1 <= s1;
			s2 <= s2;
			s3 <= s3;
			end
		end // End Stack
		
endmodule
