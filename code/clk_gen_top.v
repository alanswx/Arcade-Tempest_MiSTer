`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:39:44 06/07/2011 
// Design Name: 
// Module Name:    clk_gen 
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
module clk_gen_top(
    input clk_96MHz,
	// output reg clk_96MHz,
	 output reg clk_12MHz,
	 output reg clk_6MHz,
	 output reg clk_3MHz,
	 output reg clk_1500kHz,
	 output reg phi_1,
	 output reg phi_2,
	 output reg clk_3kHz,
	 output reg Enable
    );
	 
	initial begin
		//clk_96MHz = 0;
		clk_12MHz = 0;
		clk_6MHz = 0;
		clk_3MHz = 0;
		clk_1500kHz = 0;
		clk_3kHz = 0;
		phi_1 = 0;
		phi_2 = 0;
		Enable = 0;
		end
	
//	wire clk_96MHz_wire;
	wire clock;
	reg [2:0] clk_div = 0;	// Counter used to divide input clock signal
	reg [11:0] counter = 0;
	reg [7:0] phi_counter = 0;
	reg [1:0] enable_counter = 0;
/* AJS
	 dcm clk32_to_clk96(
		 clk_32MHz, 
		 clk_96MHz_wire, 
		 , 
		 clock
     );
*/	 
//	  always @(clk_96MHz_wire) begin
//		 clk_96MHz = clk_96MHz_wire;
//		 end

	
	/* 	Clock Divider 96 MHz --> 12 MHz  */
	always @(posedge clk_96MHz) begin			
		if (clk_div == 4) begin			//Divisor = 2*(Sensitivity List #)	
			clk_12MHz <= ~clk_12MHz;			
			clk_div <= 1;				
			end
		else begin								
			clk_div <= clk_div + 1;	
			end
		end

	always @(posedge clk_12MHz) begin
		counter <= counter + 1;			// Each counter bit represents a clock
												// division of 2 if the counter increases
												// every period of the input signal 
		end
	
	always @(counter) begin
		clk_6MHz <= counter[0];			
		clk_3MHz <= counter[1];			
		clk_1500kHz <= counter[2];
		clk_3kHz <= counter[11];
		end


//
	/* 	Phi 1 and Phi 2 Generation 	 	
		t_phi_1_h = 333.312 ns, 
		t_phi_2_h = 312.480 ns 
	 	t_1- = 20.832 ns, 
		t_2+ = 31.248 ns, 
		t_1+ = 20.832 ns, 
		t_2- = 10.416 ns */
		
	always @(posedge clk_96MHz) begin
		if (clk_12MHz) begin
			phi_counter <= phi_counter + 1;
			end
		if ((phi_counter == 17)&&(clk_1500kHz)) begin
			phi_1 <= 0;
			end
		if ((phi_counter == 18)&&(clk_1500kHz)) begin
			phi_2 <= 1;
			end
		if ((phi_counter == 32)&&(~clk_1500kHz)) begin
			phi_2 <= 0;
			end
		if ((phi_counter == 33)&&(~clk_1500kHz)) begin
			phi_1 <= 1;
			phi_counter <= 2;
			end
		end
		
	always @(posedge clk_6MHz) begin
		enable_counter = enable_counter +1;
		end
	
	always @(enable_counter) begin
		if (enable_counter == 3) begin
			Enable = 1;
			end
		else begin
			Enable = 0;
			end
		end
		
endmodule
