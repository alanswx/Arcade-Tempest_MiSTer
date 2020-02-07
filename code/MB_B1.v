`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:03:28 06/16/2011 
// Design Name: 
// Module Name:    MB_B1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: FF between new ROM address and Counter
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MB_B1(Lower_In, Upper_In, CLK_NOT, LDAB, New_PC, Begin, B1_clk);
    input [3:0] Lower_In;
    input [3:0] Upper_In;
    input CLK_NOT;
    input LDAB;
    output reg [7:0] New_PC;
    input Begin;
	 output B1_clk;


	reg CK_Enable;
	
	always @(CLK_NOT or LDAB) begin
	CK_Enable = (CLK_NOT & LDAB);
	end
	
	assign B1_clk=CK_Enable;  //temp monitor
	
	always @(negedge CK_Enable or posedge Begin) begin
		if(Begin) begin
			New_PC=8'h00;
		end
		else begin
			New_PC[3:0] = Lower_In;
			New_PC[7:4] = Upper_In;
		end
	end

endmodule
