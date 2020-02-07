`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    12:32:18 05/19/2011 
// Design Name: 	 Math Box Program Counter
// Module Name:    MB_Program_Counter 
// Project Name: 	 Vic Vector
// Target Devices: 
// Tool versions: 
// Description: 	 This models the behavior of the program counter which is between the A1 and B1 latch and the Math Box ROMs
// 
// Dependencies: 	 A1 ROM and B1 latch
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MB_Program_Counter(Address_In, PCEN, CLK, ROM_Address);
    input [7:0] Address_In;
    input PCEN;
    input CLK;
    output reg [7:0] ROM_Address;

	//ROM_Address will address the Math Box ROMs
	//reg [7:0] ROM_Address;
	
	always@ (posedge CLK)
	begin
		if (~PCEN) begin
			ROM_Address = Address_In;
			end
		else if(PCEN) begin
			//ROM_Address = ROM_Address;
			ROM_Address = ROM_Address + 1;
			end
	end
		

endmodule
