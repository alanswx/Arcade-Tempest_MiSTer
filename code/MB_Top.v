`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:42:19 06/14/2011 
// Design Name: 
// Module Name:    MB_Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Interfaces Auxiliary Board Address Decoder with Math Box modules
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 module MB_Top(EDB_IN, EDB_OUT, EAB, MStart, E3MHZ, E6MHZ, YLO, YHI, ROM_CLK, STOP, ER_WB);
    input [7:0] EDB_IN;
	 output [7:0] EDB_OUT;
    input [7:0] EAB;
    input MStart;
    input E3MHZ;
    input E6MHZ;
    input YLO;
    input YHI;
	 input ROM_CLK;
	 output STOP;
	 input ER_WB;

	 wire [7:0] Address_IN;

	 
	 // control block 1 wires
	 wire CLK_NOT;
	 wire BEGIN_NOT;
	 wire CLK;

	 
	 

	// wire Q0_in;
	 wire ROM127_2;
	 wire ROM130_2;
	 wire A10_STAR;
	// wire Q0_out;
	 wire Q0;
	 
	 
	 //control block 3 wires
	 wire S1; //from ALU
	 wire S0; //from ALU
	 wire R15; //to ALU
	 wire PCEN_NOT; //to counter
	 
	 assign pcen_temp = PCEN_NOT;
	 //A1 wires
	 wire [7:0] Initial_Address;
	 
	 assign A1_out_temp = Initial_Address;
	 
	 //Counter wires
	 wire [7:0] ROM_Addresses;
	 wire [7:0] B1_Address;
	 
	 

	 //ROM wires
	 reg [3:0] Control_Bits;
	 reg [3:0] K1_ROM_OUT;
	 reg [3:0] L1_ROM_OUT;
	 reg [3:0] J_ROM_OUT;
	 reg [3:0] H_ROM_OUT;
	 reg [3:0] F_ROM_OUT;
	 wire [23:0] CombinedROMS;
	 
	 assign a12_temp = H_ROM_OUT[0]; //temp assign
	 
	 //mb_timer_control
	 MB_Timer_Control timer(.clk_3MHz(E3MHZ), .clk_6MHz(E6MHZ), .Clear(MStart), .Begin_NOT(BEGIN_NOT));

	 //control block 1
	 MBControl1 control1(.CLK_NOT(CLK_NOT), .A12(H_ROM_OUT[0]), .BEGIN_NOT(BEGIN_NOT), .E3MGZ(E3MHZ), .CLK(CLK), .STOP(STOP));

	 //control block 2
	 MBControl2 control2(.Q0(Q0), .CLK(CLK), .M(Control_Bits[2]), .A10(J_ROM_OUT[2]), .A10_STAR(A10_STAR));

	 //contol block 3
	 MBControl3 control3(.A18(F_ROM_OUT[2]), .S(Control_Bits[0]), .S1(S1), .S0(S0), .J(Control_Bits[1]), .Begin_NOT(BEGIN_NOT), .Q0(Q0), .R15(R15), .PCEN_NOT(PCEN_NOT));
	 
	 //MB A1
	 MB_A1 A1(.EAB_In(EAB), .Begin_NOT(BEGIN_NOT), .A1_Out(Initial_Address));
	 
	 //MB B1
	 MB_B1 B1(.Lower_In(L1_ROM_OUT[3:0]), .Upper_In(K1_ROM_OUT[3:0]), .CLK_NOT(CLK_NOT), .LDAB(F_ROM_OUT[0]), .New_PC(B1_Address), .Begin(BEGIN_NOT), .B1_clk(B1_clk_temp));
	 
	 //Addresses
	 assign Address_IN = (BEGIN_NOT) ? Initial_Address : B1_Address;
	 
	 
	 MB_Program_Counter counterA(.Address_In(Address_IN), .PCEN(PCEN_NOT), .CLK(CLK), .ROM_Address(ROM_Addresses));
	 
	 //ALUs
	 // Changed for demo
	ALU_Top ALUs(.CLK(CLK), .L1_ROM_OUT(L1_ROM_OUT), .K1_ROM_OUT(K1_ROM_OUT),.J_ROM_OUT(J_ROM_OUT),
	.A10_Star(A10_STAR), .H1_ROM_OUT(H_ROM_OUT), .F1_ROM_OUT(F_ROM_OUT), .R15(R15), .Q0(Q0), .EDB_IN(EDB_IN), 
	.EDB_OUT(EDB_OUT),.YLO(YLO), .YHI(YHI), .S1(S1), .S0(S0), .C(Control_Bits[3]));
	 
//		always @(ER_WB or STOP or EAB)begin
//			EDB_OUT[7]<=~(STOP&~STREN);
//			end

	//ROMS
	 // Changed for demo
//	ROM132 ROM132(.clka(ROM_CLK), .addra(ROM_Addresses), .douta(L1_ROM_OUT));
//	ROM131 ROM131(.clka(ROM_CLK), .addra(ROM_Addresses), .douta(K1_ROM_OUT));
//	ROM130 ROM130(.clka(ROM_CLK), .addra(ROM_Addresses), .douta(J_ROM_OUT));
//	ROM129 ROM129(.clka(ROM_CLK), .addra(ROM_Addresses), .douta(H_ROM_OUT));
//	ROM128 ROM128(.clka(ROM_CLK), .addra(ROM_Addresses), .douta(F_ROM_OUT));
//	ROM127 ROM127(.clka(ROM_CLK), .addra(ROM_Addresses), .douta(Control_Bits[3:0]));
	
	
CombinedROM ROM_MB(.clka(ROM_CLK), .addra(ROM_Addresses), .douta(CombinedROMS));

always @(ROM_CLK) begin
	L1_ROM_OUT=CombinedROMS[23:20];
	K1_ROM_OUT=CombinedROMS[19:16];
	J_ROM_OUT=CombinedROMS[15:12];
	H_ROM_OUT=CombinedROMS[11:8];
	F_ROM_OUT=CombinedROMS[7:4];
	Control_Bits[3:0]=CombinedROMS[3:0];
	end
	
endmodule
