`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    08:23:59 05/24/2011 
// Design Name: 	 Math Box Control Block #3
// Module Name:    MBControl3 
// Project Name: 	 Vic Vector
// Target Devices: 
// Tool versions: 
// Description: 	 Uses various basic logic gates to take input signals from the
//						 Math Box ROMs and ALUs.  These signals are then used to create a
//						 control signals that is fed back to the ALU, while also creating
//						 two control signals that are passed back to other modules of 
//						 the Math Box.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MBControl3(A18, S, S1, S0, J, Begin_NOT, Q0, R15, PCEN_NOT);
    input A18;
    input S;
    input S1;
    input S0;
    input J;
    input Begin_NOT;
    output reg Q0;
    output reg R15;
    output reg PCEN_NOT;

	 reg temp_c404;
	 reg temp_c646;
	 reg temp_0600;
	 reg temp_d4e4;
	 
	 always @(*)
	 begin
	 Q0 = !A18; // INV
	 temp_c404 = !A18; // INV
	 temp_c646 = (S0 ^ S1); //XOR
	 temp_0600 = ~(temp_c646 & S); //NAND
	 R15 = ~(temp_c404 & temp_0600); //NAND
	 temp_d4e4 = ~(temp_0600 & J); // NAND
	 PCEN_NOT = (temp_d4e4 & Begin_NOT); // AND from Nor with Inverted inputs
	 end	 

endmodule
