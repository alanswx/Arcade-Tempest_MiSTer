`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Drew Hanson
// 
// Create Date:    11:34:44 06/16/2011 
// Design Name: 
// Module Name:    ALU_Top 
// Project Name: 	Tempest
// Target Devices: 
// Tool versions: 
// Description: Takes data from EDB, ROMS and various other bits and sends to 4 individual ALUs
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////															q0_foo
module ALU_Top(CLK, L1_ROM_OUT, K1_ROM_OUT,J_ROM_OUT,A10_Star,H1_ROM_OUT, F1_ROM_OUT, R15, Q0, EDB_IN,EDB_OUT,YLO,YHI,S1,S0,C, alu_upper_tmp, alu_lower_tmp);
    input CLK;
    input [3:0] L1_ROM_OUT;
	 input [3:0] K1_ROM_OUT;
	 input [3:0] J_ROM_OUT;
    input A10_Star;
    input [3:0] H1_ROM_OUT;
	 input [3:0] F1_ROM_OUT;
    input R15;
	 input Q0;
    input [7:0] EDB_IN;
	 output [7:0] EDB_OUT;
	 input YLO;
	 input YHI;
	 output S1;
	 output S0;
	 input C;
	 //output Q0_foo;
	 output [3:0] alu_upper_tmp;
	 output [3:0] alu_lower_tmp;
	 
	 reg [7:0] EDB_OUT_foo;
	 
	 wire [3:0] ALU_LOWER_IN;
	 wire [3:0] ALU_LOWER_OUT;
	 wire [3:0] ALU_UPPER_IN;
	 wire [3:0] ALU_UPPER_OUT;	
	 
//	 wire YLO_not = ~YLO;
//	 wire YHI_not = ~YHI;
	 
	 // Control out bits for K_L2
	 wire K_F_C3;
	 wire K_F_Q3;
	 wire K_F_R3;
	 wire qs0_foo;
//	 wire q0_in;
//	 
//	 assign q0_in=Q0;
	 
	 // Control out bits for F_H2
	 wire F_J_C3;
	 wire F_J_Q3;
	 wire F_J_R3;
	 
	 // Control out bits for F_H2
	 wire J_E_C3;
	 wire J_E_Q3;
	 wire J_E_R3;
	 
	 //Control out bits for E2
	 wire E_K_Q3;
	 
	 //wire [3:0] ALU_LOWER;
	 //wire [3:0] ALU_UPPER;
	 wire [8:0] I_K_L2;
	 wire [8:0] I_J2_E2;
	 
	 //Breaks EDB into two registers for the ALU's.  The K/L2 and J2 use same data.  F/H2 and E2 use same data
	 assign ALU_LOWER_IN = {EDB_IN[3],EDB_IN[2],EDB_IN[1],EDB_IN[0]};
	 assign ALU_UPPER_IN = {EDB_IN[7],EDB_IN[6],EDB_IN[5],EDB_IN[4]};
	 assign I_K_L2 = {F1_ROM_OUT[1],F1_ROM_OUT[2],F1_ROM_OUT[3],H1_ROM_OUT[1],H1_ROM_OUT[2],H1_ROM_OUT[3],J_ROM_OUT[1],A10_Star,J_ROM_OUT[3]};
	 assign I_J2_E2 = {F1_ROM_OUT[1],F1_ROM_OUT[2],F1_ROM_OUT[3],H1_ROM_OUT[1],H1_ROM_OUT[2],H1_ROM_OUT[3],J_ROM_OUT[1],A10_Star,J_ROM_OUT[2]};
	 
//		//K_L2 ALU
//		am2901_KL2 K_L2(.clk(CLK),.rst(1'b1),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_LOWER_IN),.i(I_K_L2),.c_n(C),.oe(YLO_not),.ram0(E_K_Q3),.ram3(K_F_R3),.qs0(Q0),.qs0_foo(qs0_foo),.qs3(K_F_Q3),.y(ALU_LOWER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(K_F_C3),.f_0(),.f_3());
//		//am2901_DataOut K_L2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_LOWER_IN),.i(I_K_L2),.c_n(C),.oe(~YLO),.ram0(E_K_Q3),.ram3(K_F_R3),.qs0(Q0),.qs3(K_F_Q3),.y(ALU_LOWER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(K_F_C3),.f_0(),.f_3());
//		
//		//F_H2 ALU
//		am2901_DataOut F_H2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_LOWER_IN),.i(I_K_L2),.c_n(K_F_C3),.oe(~YLO),.ram0(K_F_R3),.ram3(F_J_R3),.qs0(K_F_Q3),.qs3(F_J_Q3),.y(ALU_UPPER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(F_J_C3),.f_0(),.f_3());
//		//J2 ALU
//		am2901_DataOut J2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_UPPER_IN),.i(I_J2_E2),.c_n(F_J_C3),.oe(~YHI),.ram0(F_J_R3),.ram3(J_E_R3),.qs0(F_J_Q3),.qs3(J_E_Q3),.y(ALU_LOWER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(J_E_C3),.f_0(),.f_3());
//		//E2 ALU
		am2901_E2 E2(.clk(CLK),.rst(1'b1),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_UPPER_IN),.i(I_J2_E2),.c_n(J_E_C3),.oe(YHI_not),.ram0(J_E_R3),.ram3(R15),.qs0(J_E_Q3),.qs3(E_K_Q3),.y(ALU_UPPER_OUT),.g_bar(),.p_bar(),.ovr(S0),.c_n4(),.f_0(),.f_3(S1));
		//am2901_NoBuff E2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_UPPER_IN),.i(I_J2_E2),.c_n(J_E_C3),.oe(~YHI),.ram0(J_E_R3),.ram3(R15),.qs0(J_E_Q3),.qs3(E_K_Q3),.y(ALU_UPPER_OUT),.g_bar(),.p_bar(),.ovr(S0),.c_n4(),.f_0(),.f_3(S1));

		//K_L2 ALU
		am2901 K_L2(.clk(CLK),.rst(1'b1),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_LOWER_IN),.i(I_K_L2),.c_n(C),.oe(YLO_not),.ram0(E_K_Q3),.ram3(K_F_R3),.qs0(Q0_foo),.qs3(K_F_Q3),.y(ALU_LOWER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(K_F_C3),.f_0(),.f_3());
		//am2901_DataOut K_L2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_LOWER_IN),.i(I_K_L2),.c_n(C),.oe(~YLO),.ram0(E_K_Q3),.ram3(K_F_R3),.qs0(Q0),.qs3(K_F_Q3),.y(ALU_LOWER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(K_F_C3),.f_0(),.f_3());
		
		//F_H2 ALU
		am2901 F_H2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_LOWER_IN),.i(I_K_L2),.c_n(K_F_C3),.oe(~YLO),.ram0(K_F_R3),.ram3(F_J_R3),.qs0(K_F_Q3),.qs3(F_J_Q3),.y(ALU_UPPER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(F_J_C3),.f_0(),.f_3());
		//J2 ALU
		am2901 J2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_UPPER_IN),.i(I_J2_E2),.c_n(F_J_C3),.oe(~YHI),.ram0(F_J_R3),.ram3(J_E_R3),.qs0(F_J_Q3),.qs3(J_E_Q3),.y(ALU_LOWER_OUT),.g_bar(),.p_bar(),.ovr(),.c_n4(J_E_C3),.f_0(),.f_3());
		//E2 ALU
		//am2901_E2 E2(.clk(CLK),.rst(1'b1),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_UPPER_IN),.i(I_J2_E2),.c_n(J_E_C3),.oe(YHI_not),.ram0(J_E_R3),.ram3(R15),.qs0(J_E_Q3),.qs3(E_K_Q3),.y(ALU_UPPER_OUT),.g_bar(),.p_bar(),.ovr(S0),.c_n4(),.f_0(),.f_3(S1));
		//am2901 E2(.clk(CLK),.rst(1'b0),.a(L1_ROM_OUT),.b(K1_ROM_OUT),.d(ALU_UPPER_IN),.i(I_J2_E2),.c_n(J_E_C3),.oe(~YHI),.ram0(J_E_R3),.ram3(R15),.qs0(J_E_Q3),.qs3(E_K_Q3),.y(ALU_UPPER_OUT),.g_bar(),.p_bar(),.ovr(S0),.c_n4(),.f_0(),.f_3(S1));


	assign alu_upper_tmp=ALU_UPPER_OUT;
	assign alu_lower_tmp=ALU_LOWER_OUT;
	//assign Q0_foo=Q0;
	always @(CLK)begin
	if(YLO==0)begin
		EDB_OUT_foo={EDB_IN[7:4], ALU_LOWER_OUT};
		end
	if(YHI==0)begin
		EDB_OUT_foo={ALU_UPPER_OUT, EDB_IN[3:0]};
		end
		if(YHI==1)begin
			if(YLO==1)begin
				EDB_OUT_foo=EDB_IN;
				end
			end
	end
	
	assign EDB_OUT=EDB_OUT_foo;
	
	
	
endmodule
