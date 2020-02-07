`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:25 05/25/2011 
// Design Name: 
// Module Name:    state_top 
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
module vg_top(		// Clocks
						input wire clk_96MHz,
						input wire clk_12MHz,
						input wire clk_6MHz,
						input wire clk_3MHz,
						input wire VGCK,
						input wire Phi2,		
						
						// Input Control
						input wire VGGO_not,
						input wire RESET_not,
						input wire VGRST_not,
						
						// 6502 I/O
						input wire r_w,
						input wire VMEM_not,
						input wire [12:0] A6502,
						input wire [7:0] D6502_in,
						output wire [7:0] D6502_out,
						
						// Outputs		
						output wire [7:0] linscale,
						output wire CENTER_not,
						output wire VCTR_not,
						output wire [12:0] DVX_out,
						output wire DVX12inv,
						output wire [12:0] DVY_out,
						output wire DVY12inv,
						output wire x0,
						output wire y0,
						output wire HALT
						);
					
					
// Vector Timer Control Signals									
	wire STOP_not;
	wire NORM;
	wire NORM_not;
	wire SCALE;
	wire GO;
	wire VCTR;
	wire STATCLK_not;
	wire SCALELD_not;

	assign VCTR_not = ~VCTR;


// State Machine Inputs
	wire state_clk_not;
	wire avg0_clk_not;
	wire [2:0] op;

// Data Shifter Inputs
	wire [7:0] DVG;

// State Machine Outputs
	wire curr_state2;
	wire curr_state3;
	wire [3:0] strobe;
	wire [3:0] latch;
	wire avg0;
	wire [3:0] curr_state;
	
// Data Shifter Outputs
	wire [12:0] DVX;
	wire [12:0] DVY;
	wire [2:0] Z;
	
	assign DVX12inv = ~DVX_out[12];
	assign DVY12inv = ~DVY_out[12];
	
// Stack Pointer Outputs
	wire DISRST_not;
	wire [11:0] AVG; // AVG12 - AVG1

// Address Decoder
	wire Phi2_not;
	assign Phi2_not = Phi2;
	
data_out					DOUT(		DVX,
										DVY,
										strobe[0],
										SCALELD_not,
										DVX_out,
										DVY_out,
										linscale,
										x0,
										y0
										);

vg_state					FSM(		state_clk_not, 
										avg0_clk_not,
										VGGO_not,
										HALT,
										DISRST_not,
										GO,
										op,
										curr_state2,
										curr_state3,
										curr_state,
										strobe,
										latch,
										avg0			
										);//
															
vg_fsm_cntrl		FSM_CNTRL(	VGCK,     
										clk_3MHz,
										clk_6MHz,
										clk_12MHz,
										curr_state2,
										curr_state3,
										VMEM_not,
										avg0_clk_not,
										state_clk_not
										);//

vg_data_shifter 	DATA_OUT( 	DVG,
										latch,
										NORM_not,
										clk_12MHz,
										DVX,
										DVY,
										op,
										Z
										);//
											
vg_sp_pc					SP_PC(	VGGO_not, 
										DISRST_not,
										avg0,
										op,
										strobe,
										DVY[11:0],
										AVG
										);//


	
vg_vec_timer_cntrl	VTC(		op,
										DVY[12],
										DVY[11],
										DVY[10],
										DVY[9],
										DVY[8],
										DVX[12],
										DVX[11],
										strobe,
										STOP_not,	
										VGCK,
										clk_12MHz,	
										RESET_not,	
										VGRST_not, 	
										VGGO_not,
										NORM,
										NORM_not,
										SCALE,
										GO,
										CENTER_not,
										HALT,
										DISRST_not,
										VCTR,
										STATCLK_not,
										SCALELD_not
										);//

vg_vec_timer 			VT(		GO,
										NORM,
										SCALE,
										op[1],
										clk_12MHz,
										STOP_not
										);//
		
vg_addr_dec				ADEC(		clk_96MHz,
										r_w,
										Phi2_not,
										VMEM_not,
										A6502,
										AVG,
										avg0,
										D6502_in,
										D6502_out,
										DVG
										);
	
endmodule
		

