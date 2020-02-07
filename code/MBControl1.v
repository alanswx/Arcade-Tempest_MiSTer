`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:58 05/26/2011 
// Design Name: 	 Math Box control Module #1
// Module Name:    MBControl1 
// Project Name:   Vic Vector
// Target Devices: 
// Tool versions: 
// Description:  This module controls when new code begins computing.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MBControl1(CLK_NOT, A12, BEGIN_NOT, E3MGZ, CLK, STOP);
    output reg CLK_NOT;
    input A12;
    input BEGIN_NOT;
    input E3MGZ;
    output reg CLK;
	 output reg STOP;
	 //output q_temp;
	 
	 reg Q;
	 
	 //assign q_temp = Q;
//	initial begin
//		assign CLK=1;
//		assign CLK_NOT=0;
//	end
//	
	always @(Q) begin
		STOP = Q;
		end

    always @(posedge CLK_NOT or negedge BEGIN_NOT) begin
	 if(BEGIN_NOT==0)
		Q = 1'b0;
	 else
		Q = A12;
	 end
		
	always @(Q or E3MGZ) begin
		CLK = (~E3MGZ) & (~Q);
	end
	
	always @(CLK) begin
		CLK_NOT=~CLK;
	end
		
endmodule
