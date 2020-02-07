`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:16 07/12/2011 
// Design Name: 
// Module Name:    T65_Address_Decoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// AdDout_ROMtional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module T65_Address_Decoder(
	input HALT,
	input R_Wn,
	input Phi2,
	input clk_96MHz,
	input clk_6MHz,
	input clk_3MHz,
	input clk_3kHz,
	input [15:0] A6502,
	input [7:0] Dout,
	input [7:0] Dout_MB,
	output wire [7:0] Dout_RAM,
	input [7:0] Dout_VG,
	output reg [7:0] Din,
	output reg [7:0] Din_MB,
	output reg [7:0] Din_RAM,
	output reg [7:0] Din_VG,
	output reg IO_n,
	output reg VMEM_n,
	output reg VGRST_n,
	output reg VGGO_n,
	input RESET_n,
	output reg IRQ_n,
	//  For testing

	output reg [7:0] Dout_ROM,
	output reg SD_en,
	output reg SD_en_n,
	output reg WRITE_n,
	output reg WDCLR_n,
	output reg PWR_n
	 
    );
	 
//	reg IO_n;
	reg ROM_latch;
	reg ROMX_en;
	reg ROM1_en;
	reg ROM3_en;
	reg ROM5_en;
	reg ROM7_en;
	reg RAM_en;
//	reg SD_en;
//	reg SD_en_n;
//	reg WRITE_n;
//	reg WDCLR_n;
	
//	reg HALT = 1;	// Temporarily set HALT always to 1, need to add as an input from VG
	
	reg AA;
	reg OPT_en;
	reg OPT_en2;
	reg OPT1_n;
	reg OPT0_n;
	reg SINP_n;
	
	reg WE;
	
	wire [7:0] Dout_ROMX;
	wire [7:0] Dout_ROM1;
	wire [7:0] Dout_ROM3;
	wire [7:0] Dout_ROM5;
	wire [7:0] Dout_ROM7;
	
	reg [3:0] IRQ_counter = 0;
	reg LD_n;
	reg WD_counter_CLR;
//	reg PWR_n;
	reg PWR_flag;
	
	reg IRQ_n_latch;
	
	reg [7:0] WD_counter = 0;
	
	
	initial begin
		ROM_latch = 0;		// active high
		ROMX_en = 0;		// active high	
		ROM1_en = 0;		// active high	
		ROM3_en = 0;		// active high	
		ROM5_en = 0;		// active high	
		ROM7_en = 0;		// active high	
		RAM_en = 0;			// active high	
		AA = 1;				// active low
		IO_n = 1;			// active low
		VMEM_n = 1;			// active low
		SD_en = 1;			// active low
		
		OPT_en = 1;
		
		SINP_n = 1;
		OPT0_n = 1;
		OPT1_n = 1;
		
		WDCLR_n = 1;		// active low
		VGGO_n = 1;			// active low
		VGRST_n = 1;		// active low
		
		IRQ_n = 1;
		IRQ_n_latch = 1;
		PWR_flag = 0;
		PWR_n = 0;
		//RESET_n = 1;
	end
	
	// Data Latch Select and Control Signals
	always @(A6502) begin
		if (RESET_n) begin
			case (A6502[15:13])
				3'b000: begin			// RAM
						ROM_latch = 0;	
						
						//Dout_ROM = 8'hxx;
		
						IO_n = 1;
						SD_en = 1;
						VMEM_n = 1;
						AA = 0;		// active 	
						end
				3'b001: begin			// VMEM
						ROM_latch = 0;	
						
						//Dout_ROM = 8'hxx;
						
						IO_n = 1;
						SD_en = 1;
						VMEM_n = 0;		// active
						AA = 1;
						end
				3'b010: begin			// Secondary decoder
						ROM_latch = 0;
						
						//Dout_ROM = 8'hxx;
						
						IO_n = 1;		
						SD_en = 0;		// active
						VMEM_n = 1;
						AA = 1;
						end		
				3'b011: begin			// IO
						ROM_latch = 0;	
					
						//Dout_ROM = 8'hxx;
					
						IO_n = 0;		// active
						SD_en = 1;
						VMEM_n = 1;
						AA = 1;
						end
				3'b100: begin			// ROM
						ROM_latch = 1;	// active
						
						IO_n = 1;
						SD_en = 1;
						VMEM_n = 1;
						AA = 1;
						end
				3'b101: begin			// ROM
						ROM_latch = 1;	// active
						
						IO_n = 1;
						SD_en = 1;
						VMEM_n = 1;
						AA = 1;
						end
				3'b110: begin			// ROM
						ROM_latch = 1;	// active
						
						IO_n = 1;
						SD_en = 1;
						VMEM_n = 1;
						AA = 1;
						end
				3'b111: begin			// ROM
						ROM_latch = 1;	// active
						
						IO_n = 1;
						SD_en = 1;
						VMEM_n = 1;
						AA = 1;
						end
				default: begin			// NONE ACTIVE
						ROM_latch = 0;
						
						//Dout_ROM = 8'hxx;
						
						IO_n = 1;
						SD_en = 1;
						VMEM_n = 1;
						AA = 1;
						end
			endcase
			end
		end
		
	always @(A6502 or AA) begin
		if (~AA) begin
			case (A6502[11:10]) 
				2'b00:	begin
						RAM_en = 1;	// active
						OPT_en = 1;
						end
				2'b01:	begin
						RAM_en = 1;	// active
						OPT_en = 1;
						end
				/*2'b10:	begin
						RAM_en = 0;
						OPT_en = 0;	// active
						end*/
				2'b11:	begin
						RAM_en = 0;
						OPT_en = 0;	// active
						end
				default: begin
						RAM_en = 0;
						OPT_en = 1;
						end
			endcase
			end
		else begin
			RAM_en = 0;
			OPT_en = 1;
			end
			
		end
		
		always @(OPT_en or R_Wn) begin
			OPT_en2 = (OPT_en)|(~R_Wn);		// input signal Rn_W
			end
			
		// Option and Coin Input Enables
		always @(OPT_en2 or A6502) begin
			if (~OPT_en2) begin
			case (A6502[9:8]) 
				2'b00:	begin
						OPT1_n = 1;
						OPT0_n = 1;
						SINP_n = 0;	// active
						end
				2'b01:	begin
						OPT1_n = 1;
						OPT0_n = 0;	// active
						SINP_n = 1;
						end
				2'b10:	begin
						OPT1_n = 0;	// active
						OPT0_n = 1;
						SINP_n = 1;
						end
				2'b11:	begin
						OPT1_n = 1;
						OPT0_n = 1;
						SINP_n = 1;
						end
				default: begin
						OPT1_n = 1;
						OPT0_n = 1;
						SINP_n = 1;
						end
			endcase
			end
		else begin
			OPT1_n = 1;
			OPT0_n = 1;
			SINP_n = 1;
			end
		end
		
	// Control Signal Select
	always @(R_Wn or Phi2 /*or clk_3MHz*/) begin
		WRITE_n = ~((~R_Wn)&(Phi2)/*&(clk_3MHz)*/);
		end
	
	always @(SD_en or WRITE_n) begin
		SD_en_n = ~((~SD_en)&(~WRITE_n));
		end
	
	always @(SD_en_n or A6502) begin
		if (~SD_en_n) begin
			case (A6502[12:11])
				2'b00:	begin
						VGRST_n = 1;	// none active
						WDCLR_n = 1;
						VGGO_n = 1;
						end
				2'b01:	begin
						VGRST_n = 1;
						WDCLR_n = 1;
						VGGO_n = 0;		//active
						end
				2'b10:	begin
						VGRST_n = 1;
						WDCLR_n = 0;	// active
						VGGO_n = 1;
						end
				2'b11:	begin
						VGRST_n = 0;	// active
						WDCLR_n = 1;
						VGGO_n = 1;
						end
			endcase
			end
		else begin
			VGRST_n = 1;	// none active
			WDCLR_n = 1;
			VGGO_n = 1;
			end
		end
	
	// ROM Select
	always @(A6502) begin	
		case (A6502[15:12])
			4'b1001: 	begin			// 9
						ROMX_en = 1;	// active	
						ROM1_en = 0;			
						ROM3_en = 0;		
						ROM5_en = 0;			
						ROM7_en = 0;		
						end
			4'b1010: 	begin			// A
						ROMX_en = 0;		
						ROM1_en = 1;	// active		
						ROM3_en = 0;		
						ROM5_en = 0;			
						ROM7_en = 0;		
						end
			4'b1011: 	begin			// B
						ROMX_en = 0;	
						ROM1_en = 0;			
						ROM3_en = 1;	// active	
						ROM5_en = 0;			
						ROM7_en = 0;		
						end
			4'b1100: 	begin			// C
						ROMX_en = 0;		
						ROM1_en = 0;			
						ROM3_en = 0;		
						ROM5_en = 1;	// active		
						ROM7_en = 0;		
						end
			4'b1101: 	begin			// D
						ROMX_en = 0;			
						ROM1_en = 0;			
						ROM3_en = 0;		
						ROM5_en = 0;			
						ROM7_en = 1;	// active	
						end
			4'b1110: 	begin			// E
						ROMX_en = 0;		
						ROM1_en = 0;			
						ROM3_en = 0;		
						ROM5_en = 1;	// active		
						ROM7_en = 0;		
						end
			4'b1111: 	begin			// F
						ROMX_en = 0;			
						ROM1_en = 0;			
						ROM3_en = 0;		
						ROM5_en = 0;			
						ROM7_en = 1;	// active	
						end
			default: 	begin			// none active
						ROMX_en = 0;			
						ROM1_en = 0;			
						ROM3_en = 0;		
						ROM5_en = 0;			
						ROM7_en = 0;	
						end
		endcase
		end
		
	// Interrupts
	always @(posedge clk_3kHz or negedge RESET_n) begin
		if (~RESET_n) begin
			IRQ_counter = 0;
			end
		else begin
			if (~LD_n) begin
				IRQ_counter = 4'b0100;
				end
			else begin
				IRQ_counter = IRQ_counter + 1;
				end
			end
		end 
		
	always @(IRQ_counter) begin
		if (IRQ_counter == 4'b1111) begin
			LD_n = 0;
			end
		else begin
			LD_n = 1;
			end
		end 
	
	always @(posedge LD_n or negedge WDCLR_n) begin
//		if (RESET_n) begin
			if (~WDCLR_n) begin
				IRQ_n_latch = 1;
				end
			else begin
				IRQ_n_latch = 0;
				end
//			end
		end
		
		always @(IRQ_n_latch or RESET_n) begin
			if (RESET_n) begin
				IRQ_n = IRQ_n_latch;
				end
			else begin
				IRQ_n = 1;
				end
			end
		
	// Watchdog Counter
	always @(PWR_n or WDCLR_n) begin 
          WD_counter_CLR = (~PWR_n)|(~WDCLR_n); 
          end 
           
      
     always @(posedge clk_3kHz or posedge WD_counter_CLR) begin 
          if(WD_counter_CLR) begin 
               WD_counter = 0; 
               end 
          else begin 
               WD_counter = WD_counter + 1; 
               end 
          end 
           
//     always @(posedge WD_counter[7] or negedge PWR_n) begin 
//          if (~PWR_n) begin 
//               RESET_n = 0; 
//               PWR_flag = 1; 
//               end 
//          else begin      
//               RESET_n = ~(RESET_n&0); 
//               end 
//          end 
      
     always @(posedge PWR_flag) begin 
          PWR_n = 1; 
          end
	
	// RAM Write
	always @(R_Wn or Phi2) begin
		WE = (~R_Wn)&(Phi2);
		end
	
	
	// Data Bus Select
	always @(VMEM_n or ROM_latch or RAM_en or IO_n or Dout or Dout_MB or Dout_RAM or Dout_ROM or Dout_VG
			or OPT1_n or OPT0_n or SINP_n or clk_3kHz or HALT) begin
		if (~IO_n) begin		// MB data latched
			Din = Dout_MB;
			Din_MB = Dout;
			end
		else if (RAM_en) begin		// RAM data latched
			Din = Dout_RAM;
			Din_RAM = Dout;
			end
		else if (~OPT1_n) begin
			Din = 8'hff;
			end
		else if (~OPT0_n) begin
			Din = 8'hfd;
			end
		else if (~SINP_n) begin
			Din = {	clk_3kHz, 
					HALT, 
					1'b1, 	// Diag Step	
					1'b0, 	// Self-Test
					1'b1, 	// Slam
					1'b1, 	// Coin L
					1'b1, 	// Coin C
					1'b1};	// Coin R
			end
		else if (ROM_latch) begin		// ROM data latched
			Din = Dout_ROM;
			end
		else if (~VMEM_n) begin		// VG data latched
			Din = Dout_VG;
			Din_VG = Dout;
			end
		end 
		
	
	always @(Dout_ROMX or Dout_ROM1 or Dout_ROM3 or Dout_ROM5 or Dout_ROM7 or 
				ROMX_en or   ROM1_en or   ROM3_en or   ROM5_en or   ROM7_en) begin
				
		if (ROMX_en) begin
			Dout_ROM = Dout_ROMX;
			end
		else if (ROM1_en) begin
			Dout_ROM = Dout_ROM1;
			end
		else if (ROM3_en) begin
			Dout_ROM = Dout_ROM3;
			end
		else if (ROM5_en) begin
			Dout_ROM = Dout_ROM5;
			end
		else if (ROM7_en) begin
			Dout_ROM = Dout_ROM7;
			end
		end
		
	
	// Memory
	RAM 	RAM (	clk_96MHz, // input clka
					RAM_en, // input ena
					WE, // input [0 : 0] wea
					A6502[11:0], // input [11 : 0] addra
					Din_RAM, // input [7 : 0] dina
					Dout_RAM // output [7 : 0] douta
					);
	
	ROMX 	ROMX(	clk_96MHz, // input clka
					ROMX_en, // input ena
					A6502[11:0], // input [11 : 0] addra
					Dout_ROMX // output [7 : 0] douta
					);
					
	ROM1 	ROM1(	clk_96MHz, // input clka
					ROM1_en, // input ena
					A6502[11:0], // input [11 : 0] addra
					Dout_ROM1 // output [7 : 0] douta
					);
					
	ROM3 ROM3(	clk_96MHz, // input clka
					ROM3_en, // input ena
					A6502[11:0], // input [11 : 0] addra
					Dout_ROM3 // output [7 : 0] douta
					);
					
	ROM5 ROM5(	clk_96MHz, // input clka
					ROM5_en, // input ena
					A6502[11:0], // input [11 : 0] addra
					Dout_ROM5 // output [7 : 0] douta
					);
					
	ROM7 ROM7(	clk_96MHz, // input clka
					ROM7_en, // input ena
					A6502[11:0], // input [11 : 0] addra
					Dout_ROM7 // output [7 : 0] douta
					);
	



			
	

endmodule
