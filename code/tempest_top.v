`timescale 1ns / 1ps

module tempest_top( 	clk_96MHz,
//							linscale,
//							CENTER_not,
//							VCTR_not,
//							DVX_out,
//							DVX12inv,
//							DVY_out,
//							DVY12inv,
//							x0,
//							y0,
//							A6502,
							RESET_n,
//							IRQ_n,
//							VMEM_n,
							R_Wn,
							Dout,
							Din,
							clk_6MHz,
							Enable,
							VGGO_n,
							Din_MB,
							Dout_MB,
	VIDEO_R_OUT,
	VIDEO_G_OUT,
	VIDEO_B_OUT,

	HSYNC_OUT,
	VSYNC_OUT,
	VGA_DE,
	VID_HBLANK,
	VID_VBLANK
							);

	// Clock Signals						
	input wire clk_96MHz;
	//wire clk_96MHz;
	wire clk_12MHz;
	output wire clk_6MHz;
	wire clk_3MHz;
	wire clk_1500kHz;
	wire Phi_1;
	wire Phi_2;
	wire clk_3kHz;
	output wire Enable;

	output wire [3:0] VIDEO_R_OUT;
	output wire [3:0] VIDEO_G_OUT;
	output wire [3:0] VIDEO_B_OUT;

	output wire HSYNC_OUT;
	output wire VSYNC_OUT;
	output wire VGA_DE;
	output wire VID_HBLANK;
	output wire VID_VBLANK;




	
	// 6502	
	wire [1:0] Mode = 2'b00;	// 6502 Select

	input wire RESET_n;
	wire IRQ_n;

	output wire R_Wn;
	wire [23:0] A6502;
	output wire [7:0] Din;
	output wire [7:0] Dout;
	
	wire [15:0] Stack;
	wire [15:0] ProgC;
	wire [7:0] Flags;
	
	// Address Decoder
	output wire [7:0] Dout_MB;
	wire [7:0] Dout_RAM;
	wire [7:0] Dout_ROM;
	wire [7:0] Dout_VG;
	output wire [7:0] Din_MB;
	wire [7:0] Din_RAM;
	wire [7:0] Din_VG;
	wire IO_n;
	wire VMEM_n;	
	wire VGRST_n;
	input wire VGGO_n;		
	
	wire SD_en;
	wire SD_en_n;
	wire WRITE_n;
	wire WDCLR_n;
	wire PWR_n;
	
	wire [15:0] X_reg;
	wire [15:0] Y_reg;

	// VG
	/*output*/ wire [7:0] linscale;
	/*output*/ wire CENTER_not;
	/*output*/ wire VCTR_not;
	/*output*/ wire [12:0] DVX_out;
	/*output*/ wire DVX12inv;
	/*output*/ wire [12:0] DVY_out;
	/*output*/ wire DVY12inv;
	/*output*/ wire x0;
	/*output*/ wire y0;
	
	wire HALT;

	
 
T65					tempest_6502( 	
											.Mode(Mode),	// "00" is 6502
											.Res_n(RESET_n),
											.Enable(Enable),
											.Clk(clk_6MHz),
											.Rdy(1'b1),		// Rdy active-high	
											.Abort_n(1'b1),		// Abort_n  tied to 1
											.IRQ_n(IRQ_n),
											.NMI_n(1'b1),		// NMI_n tied to 1
											.SO_n(1'b1),		// SO_n
											.R_W_n(R_Wn),
											.Sync(),		// Sync NC
											.EF(),		// EF NC
											.MF(),		// MF NC
											.XF(),		// XF NC
											.ML_n(),		// ML_n NC
											.VP_n(),		// VP_n NC
											.VDA(),		// VDA NC
											.VPA(),		// VPA NC
											.A(A6502),	// 16-bit
											.DI(Din),	// 8-bit
											.DO(Dout),	// 8-bit
											.Stack(Stack),
											.ProgC(ProgC),
											.Flags(Flags),
											.X_reg(X_reg),
											.Y_reg(Y_reg)
											);
									

T65_Address_Decoder		addr_dec(	
												HALT,
												R_Wn,
												Phi_2,
												clk_96MHz,
												clk_6MHz,
												clk_3MHz,
												clk_3kHz,
												A6502[15:0],
												Dout,
												Dout_MB, 	
												Dout_RAM,   
												Dout_VG,	
												Din,		
												Din_MB,		
												Din_RAM,	
												Din_VG,
												IO_n,		
												VMEM_n,		
												VGRST_n,	
												/*VGGO_n*/,		
												RESET_n,	
												IRQ_n,		
												
												Dout_ROM, 
												SD_en,
												SD_en_n,
												WRITE_n,
												WDCLR_n,
												PWR_n
											);
						
clk_gen_top					clocks(	
											//clk_32MHz,
											clk_96MHz,
											clk_12MHz,
											clk_6MHz,
											clk_3MHz,
											clk_1500kHz,
											Phi_1,
											Phi_2,
											clk_3kHz,
											Enable
											);
									
								
vg_top						vg_top(
											clk_96MHz,
											clk_12MHz,
											clk_6MHz,
											clk_3MHz,
											clk_1500kHz,
											Phi_2,
											VGGO_n,
											RESET_n,
											VGRST_n,
											R_Wn,
											VMEM_n,
											A6502[12:0],
											Din_VG,
											Dout_VG,
											linscale,
											CENTER_not,
											VCTR_not,
											DVX_out,
											DVX12inv,
											DVY_out,
											DVY12inv,
											x0,
											y0,
											HALT
											
											);
											
Schematic_3B				MB(
									 Din_MB,
									 Dout_MB,
									 A6502[7:0],
									 IO_n,
									 R_Wn,
									 Phi_2,
									 clk_3kHz,
									 clk_3MHz,
									 clk_6MHz
									 
									 );

wire [2:0] rgb = DVY_out[2:0];									
 bwidow_dw bwidow_dw (
    .RESET(~RESET_n),
    .clk_50(clk_96MHz),
    .clk_12(clk_6MHz),
    .X_VECTOR({~DVX_out[12],DVX_out[11:3]}),
    .Y_VECTOR({~DVY_out[12],DVY_out[11:3]}),
    .Z_VECTOR(linscale),
    .RGB(rgb),
    //.BEAM_ENA(clk_1500kHz),
    .BEAM_ENA(Enable),
    .BEAM_ON(rgb[0]||rgb[1]||rgb[2]),
    .VIDEO_R_OUT(VIDEO_R_OUT),
    .VIDEO_G_OUT(VIDEO_G_OUT),
    .VIDEO_B_OUT(VIDEO_B_OUT),
    .HSYNC_OUT(HSYNC_OUT),
    .VSYNC_OUT(VSYNC_OUT),
    .VID_DE(VGA_DE),
    .VID_HBLANK(VID_HBLANK),
    .VID_VBLANK(VID_VBLANK),
      ); 
									 
endmodule 
