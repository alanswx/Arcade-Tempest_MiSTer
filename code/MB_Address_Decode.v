`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:13:41 06/07/2011 
// Design Name: 
// Module Name:    MB_Address_Decode 
// Project Name: Tempest
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
module MB_Address_Decode(EAB, Phi2, ER_WB, I_O, E3MHZ, MStart, OL_NOT, POKEY2, POKEY1, YHI, YLO, EARD, STREN, EARCON, EARWR);
    input [7:0] EAB;
    input Phi2;
    input ER_WB;
    input I_O;
	 input E3MHZ;
    output reg MStart;
    output reg OL_NOT;
    output reg POKEY2;
    output reg POKEY1;
    output reg YHI;
    output reg YLO;
    output reg EARD;
    output reg STREN;
    output reg EARCON;
    output reg EARWR;

	reg WRITE_NOT;
	reg B4_B5;
	reg B46_C45;
	reg B45_C410;
	reg B5_C4;
	reg C46_MSTART;
	reg B4_Control;
	reg B5_Control;

always @(Phi2 or ER_WB or E3MHZ)
	begin
		WRITE_NOT = ~(Phi2 & (~ER_WB) & E3MHZ);
	end

// NAND on schematic, converted to OR via DeMorgan's
always @(ER_WB or B46_C45)
	begin
		C46_MSTART = (ER_WB | B46_C45);
	end

// Bit leading to M START
always @(C46_MSTART or Phi2)
	begin
		MStart = ~(C46_MSTART | Phi2);
	end

// NAND on schematic, converted to OR via DeMorgan's
always @(WRITE_NOT or B5_C4)
	begin
		OL_NOT = (B5_C4 | WRITE_NOT);
	end

//Output includes the inverters located on the output lines
always @(I_O or EAB[7] or EAB[6])
	begin
		if(~I_O) begin
			case(EAB[7:6])

			2'b00: begin
				B4_B5 <= 1;
				B46_C45 <= 1;	// From decoder on far upper left to NAND/OR in upper right
				B45_C410 <= 1; // From decoder on far upper left to NAND/OR in lower middle
				end
		
			2'b01: begin
				B4_B5 <= 1;
				B46_C45 <= 1;
				B45_C410 <= 0;
				end
				
			2'b10:	begin
				B4_B5 <= 1;
				B46_C45 <= 0;
				B45_C410 <= 1;
				end
				
			2'b11:	begin
				B4_B5 <= 0;
				B46_C45 <= 1;
				B45_C410 <= 1;
				end
				
			endcase	
		end
		else begin
			B4_B5 <= 1;
			B46_C45 <= 1;
			B45_C410 <= 1;
		end
	end

always @(B4_B5 or EAB[5] or EAB[4])
	begin
		if(~B4_B5) begin

		case(EAB[5:4])

			2'b00: begin 
				B5_C4 <= 1;
				POKEY2 <= 1;
				POKEY1 <= 0;
				end
			
			2'b01: begin
				B5_C4 <= 1;
				POKEY2 <= 0;
				POKEY1 <= 1;
				end
				
			2'b10: begin
				B5_C4 <= 0;
				POKEY2 <= 1;
				POKEY1 <= 1;
				end
				
			2'b11: begin
				B5_C4 <= 1;
				POKEY2 <= 1;
				POKEY1 <= 1;
				end
		
		endcase
	end
	else begin
		B5_C4 <= 1;
		POKEY2 <= 1;
		POKEY1 <= 1;
	end
end

// Bottom Decoder in ABAD

always @(I_O or WRITE_NOT)
	begin
		B4_Control = (I_O | WRITE_NOT);
	end


// Bottom Decoder using Switch
always @(B4_Control or EAB[7] or EAB[6])
	begin
		if(~B4_Control) begin
			case(EAB[7:6])

				2'b00: begin
					EARCON <= 1;
					EARWR <= 0;
					end
				
				2'b01: begin
					EARCON <= 0;
					EARWR <= 1;
					end
					
				2'b10: begin
					EARCON <= 1;
					EARWR <= 1;
					end
					
				2'b11: begin
					EARCON <= 1;
					EARWR <= 1;	
					end
			endcase
		end
		else begin
			EARCON <= 1;
			EARWR <= 1;	
		end
end

// Lower B5 decoder
always @(ER_WB or B45_C410)
	begin
		B5_Control = (ER_WB | B45_C410);
	end


always @(B5_Control or EAB[5] or EAB[4])
	begin
		if(~B5_Control) begin
		case(EAB[5:4])

			2'b00: begin
				YHI <= 1;
				YLO <= 1;
				EARD <= 1;
				STREN <= 0;
				end
			
			2'b01: begin
				YHI <= 1;
				YLO <= 1;
				EARD <= 0;
				STREN <= 1;
				end
			
			2'b10: begin
				YHI <= 1;
				YLO <= 0;
				EARD <= 1;
				STREN <= 1;
				end
			
			2'b11: begin
				YHI <= 0;
				YLO <= 1;
				EARD <= 1;
				STREN <= 1;
				end
	
		endcase
	end
	else begin
		YHI <= 1;
		YLO <= 1;
		EARD <= 1;
		STREN <= 1;
	end
end


endmodule









