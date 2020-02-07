`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// 
// Create Date:    10:12:32 05/25/2011 
// Design Name: 	 Math Box Timer Control Logic
// Module Name:    MB_Timer_Control 
// Project Name: 	 Vic Vector
// Target Devices: 
// Tool versions: 
// Description: 	 Uses a JK Flip-Flop with the 6MHz and 3MHz clock signals to 
//						 create the "BEGIN" and "BEGIN_NOT" signals
//
// Dependencies: 	 6MHz and 3MHz clock signals from Clock Timing Module, Clear 
//						 bit from the Auxiliary Board Address Decoder Module
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MB_Timer_Control(clk_3MHz, clk_6MHz, Clear, Begin_NOT);
    input clk_3MHz;
    input clk_6MHz;
	 input Clear;	//MStart
    output reg Begin_NOT;

	always @(posedge clk_6MHz or negedge Clear) begin
		if (~Clear) begin
			Begin_NOT = 1;
			end
		else begin
			//  J input
			case (clk_3MHz) 
				1'b0: 	begin
						// K_NOT input
						case (Begin_NOT)
							1'b0: 	begin
								Begin_NOT = 1;
								end
							1'b1: 	begin 
								Begin_NOT = Begin_NOT;
								end
						endcase
					end
				1'b1:	begin
						case (Begin_NOT)
							1'b0: 	begin
								Begin_NOT = ~Begin_NOT;
								end
							1'b1: 	begin
								Begin_NOT = 0;
								end
						endcase
					end
			endcase
			end
		end
endmodule
