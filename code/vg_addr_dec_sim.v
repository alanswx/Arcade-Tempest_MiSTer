module vg_addr_dec(
	input clk_96MHz,
	input r_w,
	input Phi2_not,
	input VMEM_not,
	input [12:0] A6502,
	input [11:0] AVGPC,
	input AVG0,
	input [7:0] D6502_in,
	output wire [7:0] D6502_out,
	output reg [7:0] DVG
	);

	reg VW_not;
	reg BUFFEN_not;	

	reg [12:0] AVG;
	reg [12:0] Amain;
	reg ROM_en;
	reg RAM_en;

	wire [7:0] Din_RAM;		
	wire [7:0] Dout_RAM;	// Temp change to reg
	wire [7:0] Dout_ROM;	// Temp change to reg

//Memory Instances
		  vgRAM vgRAM (
					  clk_96MHz, // input clka
					  RAM_en, // input ena
					  VW_not, // input [0 : 0] wea
					  Amain[11:0], // input [11 : 0] addra
					  Din_RAM, // input [7 : 0] dina
					  Dout_RAM // output [7 : 0] douta
					  );

		  vgROM vgROM (	clk_96MHz, // input clka
						 ROM_en, // input ena
						 Amain[11:0], // input [11 : 0] addra
						 Dout_ROM // output [7 : 0] douta
						 );
	//End memory

	// Effective input address from VG
	always @(AVGPC or AVG0) begin
		AVG = {AVGPC,AVG0};
		end 
		
	// Address latching
	always @(r_w or Phi2_not or A6502 or AVG or VMEM_not) begin
		case (VMEM_not)
			0: 	begin // Select 6502 address bus
				Amain = A6502;
				BUFFEN_not = Phi2_not;
				VW_not = ~(Phi2_not|r_w);		// Inverter added due to HIGH write enable
				end
			1:	begin // Select VG address bus
				Amain = AVG;
				BUFFEN_not = 1;
				VW_not = 0;			// 0 instead of 1 due to HIGH write enable
				end
		endcase
		end

	// Address decoder
	always @(Amain) begin
		case (Amain[12])
			0: 	begin		// Enable RAM
				RAM_en = 1;
				ROM_en = 0;
				end
			1: 	begin		// Enable ROM
				RAM_en = 0;
				ROM_en = 1;
				end
			default: begin
				RAM_en = 0;
				ROM_en = 0;
				end
		endcase
		end

	// Data Buffers
	always @(RAM_en or ROM_en or Dout_RAM or Dout_ROM) begin
		if (RAM_en) begin		// RAM data latched
			DVG = Dout_RAM;
			end
		else if (ROM_en) begin	// ROM data latched
			DVG = Dout_ROM;
			end
		end

	assign Din_RAM = (~BUFFEN_not)&(~r_w) ? D6502_in : 8'bzzzzzzzz;

	assign D6502_out = (~BUFFEN_not)&(r_w) ? DVG: 8'bzzzzzzzz;
	
endmodule 