`timescale 1ns / 1ps

module vg_fsm_cntrl(
	input VGCK,
	input clk_3MHz,
	input clk_6MHz,
	input clk_12MHz,
	input curr_state2,
	input curr_state3,
	input VMEM_not,
	output reg avg0_clk_not, 
	output reg state_clk_not
	);

	reg avg0_clk;
	reg state_clk;	

	reg R_in;
	reg SR_out;
	reg SR_out_not;
	wire A;
	wire B;
	wire d_in;

	// Input Clock D FF
	always @(posedge clk_6MHz) begin
		R_in <= (~VGCK)&(~clk_3MHz);
		end // End FF
		
	// SR Latch	
	assign S_in = (~R_in)&(~curr_state2)&(~VMEM_not);
		
	always @(R_in or S_in or SR_out or SR_out_not) begin
		SR_out_not = ~(S_in|SR_out);
		end 
				
	always @(R_in or S_in or SR_out or SR_out_not) begin
		SR_out = ~(R_in|SR_out_not);
		end // End SR Latch

	// Combinational Logic for Output FFs
	assign A = (~VGCK)&(~clk_3MHz)&(~clk_6MHz)&(~SR_out);
	assign B = (~VGCK)&(~state_clk);
	assign d_in = ~(A|B);

	// State Clock D FF
	always @(posedge clk_12MHz) begin
		state_clk <= d_in;
		end
		
	always @(state_clk) begin
		state_clk_not = ~state_clk;
		end

	// AVG0 Clock D FF
	always @(posedge clk_12MHz or negedge curr_state3) begin
		if (~curr_state3) begin
			avg0_clk <= 0;
			end
		else begin
			avg0_clk <= d_in;
			end
		end
		
	always @(avg0_clk) begin
		avg0_clk_not <= ~avg0_clk;
		end


endmodule 