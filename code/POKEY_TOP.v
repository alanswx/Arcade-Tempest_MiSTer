`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:59:51 07/11/2011 
// Design Name: 
// Module Name:    POKEY_TOP 
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
module POKEY_TOP(POKEY1, POKEY2, EAB, EDB_IN, EDB_OUT, TBC, ER_WB, START1, 
E_PHI_2, POKAU1, POKAU2, Zap, Fire, POKEY_control);//, POKEY2_out, POKEY1_out);
    input POKEY1;
    input POKEY2;
    input [7:0] EAB;
    input [7:0] EDB_IN;
	 output [7:0] EDB_OUT;
    input [3:0] TBC;
    input ER_WB;
    input START1;
    input E_PHI_2;
    output [7:0] POKAU1;
    output [7:0] POKAU2;
	 input Zap;
	 input Fire;
	 output POKEY_control;
//	 output [7:0] POKEY2_out;
//	 output [7:0] POKEY1_out;
	 
	reg [7:0] EDB_OUT_foo;
	reg POKEY_control_foo;

//	wire one = {1'b1};
//	wire zeros=1'b0;
	
//	wire P1IN[7:0];
//	wire P2IN[7:0];

	wire [7:0] data_out_PK2;
	wire [7:0] data_out_PK1;
	assign POKEY2_out=data_out_PK2;
	assign POKEY1_out=data_out_PK1;


//POKEY C/D2
ASTEROIDS_POKEY PK1(
  .ADDR(EAB[3:0]),
  .DIN(EDB_IN),
  .DOUT(data_out_PK2),
  .DOUT_OE_L(),
  .RW_L(ER_WB),
  .CS(1'b1),
  .AUDIO_OUT(POKAU2),
  .CS_L(POKEY2),
  .PIN({1'b0, 1'b0, START1, Zap, Fire, 1'b0, 1'b0, 1'b0}),
  .ENA(1'b1),
  .CLK(E_PHI_2));


//POKEY B/C2
ASTEROIDS_POKEY PK2(
  .ADDR(EAB[3:0]),
  .DIN(EDB_IN),
  .DOUT(data_out_PK1),
  .DOUT_OE_L(),
  .RW_L(ER_WB),
  .CS(1'b1),
  .CS_L(POKEY1),
  .AUDIO_OUT(POKAU1),
  .PIN({1'b0, 1'b0, 1'b0, 1'b0, TBC[3:0]}),
  .ENA(1'b1),
  .CLK(E_PHI_2));



//If both POKEY chips are active, EDB_out is the bitwise OR of their output.
//If one POKEY chips is active, just their data is written to the EDB_out
//else, the EDB_out is uneffected.

always @(data_out_PK2 or data_out_PK1 or POKEY2 or POKEY1) begin
if(POKEY2==0)begin
		EDB_OUT_foo<=data_out_PK2;
				end
else if(POKEY1==0)begin
	EDB_OUT_foo<=data_out_PK1;
						end
else begin
	EDB_OUT_foo<=EDB_IN;
		end
	end
	
	assign EDB_OUT=EDB_OUT_foo;
	
//POKEY_control sets bit to high if one of the POKEYs was activated
//else, set low;	
always @(POKEY1 or POKEY2)begin
	if(~POKEY1 | ~POKEY2)begin
		POKEY_control_foo=1;
	end
	else begin
		POKEY_control_foo=0;
		end
	end
	
	assign POKEY_control=POKEY_control_foo;
endmodule
