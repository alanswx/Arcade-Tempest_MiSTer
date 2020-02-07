`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    13:06:40 05/19/2011 
// Design Name: 	 A1 ROM
// Module Name:    MB_A1 
// Project Name: 	 Vic Vector
// Target Devices: 
// Tool versions: 
// Description: 	 Emulates the A1 ROM in the Math Box of Atari Tempest.
//
// Dependencies: 	 EAB0-4
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Instead of using ROM space, we used programming space by using logic.
//
//////////////////////////////////////////////////////////////////////////////////
module MB_A1(EAB_In, Begin_NOT, A1_Out);
    input [7:0] EAB_In;
    input Begin_NOT;
    output reg [7:0] A1_Out;
	 wire [4:0] EAB_working;
	 
	 //reg [4:0] EAB_working;
	 assign EAB_working = EAB_In[4:0];
	 
	 always@(Begin_NOT or EAB_working)
	 begin
	 if(Begin_NOT==1)begin
			
				case(EAB_working)
				
					5'b00000: A1_Out = 	8'h20;
					5'b00001: A1_Out = 	8'h21;
					5'b00010: A1_Out = 	8'h22;
					5'b00011: A1_Out = 	8'h23;
					5'b00100: A1_Out = 	8'h24;
					5'b00101: A1_Out = 	8'h25;
					5'b00110: A1_Out = 	8'h26;
					5'b00111: A1_Out = 	8'h27;
					5'b01000: A1_Out = 	8'h28;
					5'b01001: A1_Out = 	8'h29;
					5'b01010: A1_Out = 	8'h2a;
					5'b01011: A1_Out = 	8'h41;
					5'b01100: A1_Out = 	8'h2c;
					5'b01101: A1_Out = 	8'h34;
					5'b01110: A1_Out = 	8'h35;
					5'b01111: A1_Out = 	8'h36;
					5'b10000: A1_Out = 	8'h37;
					5'b10001: A1_Out = 	8'h42;
					5'b10010: A1_Out = 	8'h7e;
					5'b10011: A1_Out = 	8'hb8;
					5'b10100: A1_Out = 	8'hbd;
					5'b10101: A1_Out = 	8'h2e;
					5'b10110: A1_Out = 	8'h2f;
					5'b10111: A1_Out = 	8'h17;
					5'b11000: A1_Out = 	8'h19;
					5'b11001: A1_Out = 	8'h18;
					5'b11010: A1_Out = 	8'h30;
					5'b11011: A1_Out = 	8'h31;
					5'b11100: A1_Out = 	8'hd9;
					5'b11101: A1_Out = 	8'heb;
					5'b11110: A1_Out = 	8'hf4;
					5'b11111: A1_Out = 	8'h00;
					
			endcase
			end
			else if(~Begin_NOT)begin
			A1_Out=8'h00;
			end
	
	 end

endmodule
