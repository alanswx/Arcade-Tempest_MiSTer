`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:09:41 06/14/2011 
// Design Name:
// Module Name:    Schematic_3B 
// Project Name: 	Tempest
// Target Devices: 
// Tool versions: 
// Description: Interfaces schematic 2A with 3B.  Takes in address bus and other control logic
// 				 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Schematic_3B(EDB_IN, EDB_OUT, EAB, I_O, ER_WB, E_PHI_2, E3KHZ, E3MHZ, E6MHZ);
    input [7:0] EDB_IN;
	 output [7:0] EDB_OUT;
	 input [7:0] EAB;
	 input I_O;
	 input ER_WB;
	 input E_PHI_2;
	 input E3KHZ;
	 input E3MHZ;
	 input E6MHZ;
	 
	 
	 // wires for Address Decoder to other mods
	 wire MStart;
    wire OL_NOT;
    wire POKEY2;
    wire POKEY1;
    wire YHI;
    wire YLO;
    wire EARD;
    wire STREN;
    wire EARCON;
    wire EARWR;
	 wire STOP;
	 wire [7:0] EDB_OUT_Pokey;
	 wire [7:0] EDB_OUT_MB;
	 wire POKEY_control;
	 
	 //Address Decode
	 MB_Address_Decode add_dec(.EAB(EAB), .Phi2(E_PHI_2), .ER_WB(ER_WB), .I_O(I_O), .E3MHZ(E3MHZ), 
	 .MStart(MStart), .OL_NOT(OL_NOT), .POKEY2(POKEY2), .POKEY1(POKEY1), .YHI(YHI), .YLO(YLO), .EARD(EARD), 
	 .STREN(STREN), .EARCON(EARCON), .EARWR(EARWR));
	 
	 //High Score
	// High_Score_Mem HS(.EAB(EAB), .EDB_IN(EDB_IN), .EDB_OUT(EDB_OUT), .EARWR_NOT(EARWR), .EARD_NOT(EARD), 
	 //.RESET_NOT(RESET_NOT), .EARCON_NOT(EARCON), .E3MHZ(E3MHZ));
	 
	//POKEY
	POKEY_TOP pk(.POKEY1(POKEY1), .POKEY2(POKEY2), .EAB(EAB[7:0]), .EDB_IN(EDB_IN), .EDB_OUT(EDB_OUT_Pokey), .TBC(), .ER_WB(ER_WB), 
	.START1(), .E_PHI_2(E_PHI_2), .POKAU1(), .POKAU2(), .Zap(), .Fire(), .POKEY_control(POKEY_control));
	 
	 //MB
	MB_Top MB(.EDB_IN(EDB_IN), .EDB_OUT(EDB_OUT_MB), .EAB(EAB), .MStart(MStart), .E3MHZ(E3MHZ), .E6MHZ(E6MHZ), .YLO(YLO), .YHI(YHI), .ROM_CLK(), .STOP(STOP), .ER_WB(ER_WB));

//	always @(STREN or STOP) begin
//		assign EDB_OUT[7]=~(~STREN & STOP);
//	end
	
//	always @(EAB) begin
//		if(YHI==0 | YLO==0)begin
//			EDB_OUT<=EDB_OUT_MB;
//		end
//		else if(POKEY1==0 | POKEY2==0) begin
//			EDB_OUT<=EDB_OUT_Pokey;
//		end
//		else begin
//			EDB_OUT<=EDB_IN;
//		end
//	end
		
assign EDB_OUT = (POKEY_control) ? EDB_OUT_Pokey : EDB_OUT_MB;

endmodule
