`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:32:52 05/18/2011 
// Design Name: 
// Module Name:    vg_state 
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
module vg_state(
   input state_clk_not,			// FSM Cntrl of next_state latch
	input avg0_clk_not,			// Decoder and AVG0 Cntrl signal
	input VGGO_not,
	input HALT,	
	input DISRST_not,
	input GO,
   input [2:0] op,				// From switches
	output reg curr_state2,
	output reg curr_state3,
	output reg [3:0] state,
	output reg [3:0] strobe,
	output reg [3:0] latch,
	output reg avg0
   );

	reg go_halt; 
	reg [3:0] curr_state;
	reg [3:0] prev_state;
	reg [7:0] decoder;
	reg avg0_not;
	
	reg flag = 0;


	initial begin
		strobe = 4'b1111;
		latch = 4'b1111;
		end

	always @(posedge state_clk_not) begin
		go_halt = ~(GO|HALT);
		end

	// Clock previous state back to FSM
	always @(posedge state_clk_not or negedge DISRST_not) begin
		if (~DISRST_not) begin
			prev_state = 0;
			end
		else begin
			prev_state = curr_state;
			end
		end 
		
	// FSM	
	always @(prev_state or op or go_halt) begin
		if (go_halt) begin
			case (prev_state)
				4'h0: curr_state = 4'h9; // Idle -> Latch 1
				4'h1: curr_state = 4'h0; // 1 -> Idle
				4'h2: begin
							if (op == 3'b011) begin	// If STAT/SCAL 2 -> 1
								curr_state = 4'h1;
								end
							else begin				// Otherwise 2 -> Idle
								curr_state = 4'h0;
								end
						 end 
				4'h3: begin
							if (op == 3'b011) begin // If STAT/SCAL 3 -> 2
								curr_state = 4'h2;
								end
							else begin				//Otherwise 3 -> Idle
								curr_state = 4'h0;
								end
						 end 
				4'h8: begin
							if (op == 3'b000) begin // VCTR
								curr_state = 4'hB; // Latch 3
								end
							else if (op == 3'b001) begin // HALT
								curr_state = 4'hF; // Strobe 3
								end
							else if ((op == 3'b011)||(op == 3'b111)) begin // STAT/SCAL or JMP 
								curr_state = 4'hE; // Strobe 2
								end
							else if ((op == 3'b100)||(op == 3'b101)) begin // CENTER or JSR
								curr_state = 4'hC; // Strobe 0
								end
							else if (op == 3'b110) begin // RTS
								curr_state = 4'hD; // Strobe 1
								end
							else begin
								curr_state = 4'h0;
								end
						 end
				4'h9: begin
							if (op == 3'b010) begin // SVEC
								curr_state = 4'hB; //Latch 3
								end
							else begin // Not SVEC
								curr_state = 4'h8; // Latch 2
								end
						 end
				4'hA: curr_state = 4'hC; // Strobe 0
				4'hB: begin
							if (op == 3'b000) begin	// VCTR
								curr_state = 4'hA; // Latch 2
								end
							else if (op == 3'b010) begin // SVEC
								curr_state = 4'hC; // Strobe 0
								end
							else begin
								curr_state = 4'h0;
								end
						 end
				4'hC: begin
							if ((op == 3'b000)||(op == 3'b010)||(op == 3'b101)) begin // VCTR/SVEC/JSR
								curr_state = 4'hD; // Strobe 1
								end
							else if (op == 3'b100) begin // CENTER
								curr_state = 4'hF; // Strobe 3
								end
							else begin
								curr_state = 4'h0;
								end
						 end
				4'hD: begin
							if ((op == 3'b000)||(op == 3'b010)) begin // VCTR/SVEC
								curr_state = 4'hF; // Strobe 3
								end
							else if ((op == 3'b101)||(op == 3'b110)) begin // JSR/RTS
								curr_state = 4'hE; // Strobe 2
								end
							else begin
								curr_state = 4'h0;
								end
						 end
				4'hE: begin
							if ((op == 3'b101)||(op == 3'b110)||(op == 3'b111)) begin // JSR/RTS/JMP
								curr_state = 4'h9; // Latch 1
								end
							else if (op == 3'b011) begin // STAT/SCAL
								curr_state = 4'h3; // 3
								end
							else begin
								curr_state = 4'h0;
								end
						 end
				4'hF: curr_state = 4'h0; // Idle
				default: curr_state = 4'h0;
			endcase
			end
		else begin
			curr_state = 4'h0;
			end
		end // End FSM
		
	always @(curr_state) begin
		curr_state2 = curr_state[2];
		curr_state3 = curr_state[3];
		state = curr_state;
		end

	// Latch Strobe Decoder	
	always @(avg0_clk_not) begin
		if (avg0_clk_not) begin
			decoder = 8'b11111111;
			end
		else begin
			case (curr_state[2:0])
				3'b000: decoder = 8'b11111110; // Latch 0
				3'b001: decoder = 8'b11111101; // Latch 1
				3'b010: decoder = 8'b11111011; // Latch 2
				3'b011: decoder = 8'b11110111; // Latch 3
				3'b100: decoder = 8'b11101111; // Strobe 0
				3'b101: decoder = 8'b11011111; // Strobe 1
				3'b110: decoder = 8'b10111111; // Strobe 2
				3'b111: decoder = 8'b01111111; // Strobe 3
			default: decoder = 8'b11111111;
			endcase
			end
		end 
		
	always @(decoder) begin
		strobe = decoder[7:4];
		latch = decoder[3:0];
		end // End Decoder
		
	// AVG0 FF w/ preset
//	always @(posedge avg0_clk_not or negedge VGGO_not) begin
//		if (~VGGO_not) begin
//			avg0 <= 1;
//			avg0_not <= 0;
//			end
//		else if ((prev_state == 4'hE)|(prev_state == 4'hF)|(prev_state == 4'h3)|(prev_state == 4'h2)|(prev_state == 4'h1)|(prev_state == 4'h0)|(state == 4'h0)) begin
//			avg0 <= 1;
//			avg0_not <= 0;
//			end
//		else begin
//			avg0 <= ~((~state[2])&(~avg0_not));
//			avg0_not <= (~state[2])&(~avg0_not);
//			end
//		end 

//		always @(negedge VGGO_not) begin
//			flag <= 1;
//			end
		
		always @(posedge avg0_clk_not /*or negedge VGGO_not*/) begin
		if ((~VGGO_not)&(~flag)) begin
			avg0 <= 1;
			flag <= 1;
			end
		else if (((~VGGO_not)&flag)|VGGO_not)begin
			if (VGGO_not) begin
				flag <= 0;
				end
			case (curr_state)
				4'h9: avg0 <= 0;
				4'h8: avg0 <= 1;
				4'hB: begin
						if (op == 0) begin
							avg0 <= 0;
							end
						else begin
							avg0 <= 1;
							end
						end
				4'hA: avg0 <= 1;
				default: avg0 <= 1;
			endcase
			end
		end 


//	always @(avg0) begin
//			avg0_not = ~avg0;
//			end
		
		// End AVG0 FF
		

	endmodule 