`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    09:50:42 05/24/2011 
// Design Name: 	 Math Box Control Block #2
// Module Name:    MBControl2 
// Project Name: 	 Vic Vector
// Target Devices: 
// Tool versions: 
// Description: 	Uses a D Flip-Flop and basic logic gates to take signals from 
//						the Math Box ROMs and use them to create control signals for 
//						the Math Box ALUs.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MBControl2(Q0, CLK, M, A10, A10_STAR);
    input Q0;
    input CLK;
    input M;
    input A10;
    output reg A10_STAR;
	 
	 reg temp_CPU8;
	 reg Q_not;

	 // D Flip-Flop
	 always @(posedge CLK) begin
		Q_not <= ~Q0;
		end
	
	// Control logic attached to D Flip-Flop
	always@(*)
	begin
		temp_CPU8 = (Q_not & M);
		A10_STAR = (temp_CPU8 ^ A10);
		end
	

endmodule
