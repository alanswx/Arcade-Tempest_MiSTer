`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:24 06/10/2011 
// Design Name: 
// Module Name:    vg_vec_timer 
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
module vg_vec_timer(
		input GO,
		input NORM,
		input SCALE,
		input op1,
		input clk_12MHz,
		output reg STOP_not
		);
		
	reg LD_not;	// Load Enable
	reg ACO;		// Counter A carry
	reg BCO;		// Counter B carry
	reg CCO;		// Counter C carry
	reg Cen;		// Counter C enable
	reg Den;		// Counter D enable

	reg 	[3:0] A; 	// Counter A
	reg	[3:0] B; 	// Counter B
	reg	[3:0] C; 	// Counter C
	reg	[2:0] D; 	// Counter D

	initial begin
			A = 0;
			B = 0;
			C = 0;
			D = 0;
			end
		
	always @(NORM or SCALE) begin
		LD_not = ~(/*NORM|*/SCALE);
		end
		

	// Counter A
	always @(posedge clk_12MHz) begin
		if (~LD_not) begin
			A[0] = A[1];
			A[1] = A[2];
			A[2] = A[3];
			A[3] = B[0];
			end
		else begin
			if (GO) begin
				A = A + 1;
				end
			end
		end 	
		
	always @(A or GO) begin
		if ((A == 4'b1111)&GO) begin
			ACO = 1;
			end
		else begin
			ACO = 0;
			end
		end // End Counter A
		
	// Counter B
	always @(posedge clk_12MHz) begin
		if (~LD_not) begin
			B[0] = B[1];
			B[1] = B[2];
			B[2] = B[3];
			B[3] = C[0]|op1;
			end
		else begin
			if (ACO) begin
				B = B + 1;
				end
			end
		end 
		
	always @(B) begin
		if (B == 4'b1111) begin
			BCO = 1;
			end
		else begin
			BCO = 0;
			end
		end // End Counter B
		
	// Counter C
	always @(ACO or BCO) begin
		Cen = ACO&BCO;
		end
	
	always @(posedge clk_12MHz or posedge op1) begin
		if (op1) begin
			C[0] = 0;
			C[1] = 0;
			C[2] = 0;
			C[3] = 0;
			end
		else begin
			if (~LD_not) begin
				C[0] = C[1];
				C[1] = C[2];
				C[2] = C[3];
				C[3] = D[0];
				end
			else begin
				if (Cen) begin
					C = C + 1;
					end
				end
			end
		end 
		
	always @(C) begin
		if (C == 4'b1111) begin
			CCO = 1;
			end
		else begin
			CCO = 0;
			end
		end // End Counter C	
		
	// Counter D
	always @(ACO or BCO or CCO) begin
		Den = ACO&BCO&CCO;
		end
	
	always @(posedge clk_12MHz or posedge op1) begin
		if (op1) begin
			D[0] = 0;
			D[1] = 0;
			D[2] = 0;
			end
		else begin
			if (~LD_not) begin
				D[0] = D[1];
				D[1] = D[2];
				D[2] = 1;
				end
			else begin
				if (Den) begin
					D = D + 1;
					end
				end
			end
		end // End Counter D
		
	always @(ACO or BCO or CCO or D or op1) begin
		STOP_not = ~(((CCO&D[2]&D[1]&D[0])|op1)&ACO&BCO);
		end

endmodule 