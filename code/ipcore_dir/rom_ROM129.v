module rom_ROM129
(
input clk,
input [7:0] addr,
output [3:0] dout,
input cs );
reg [3:0] q;
always @(posedge clk) 
begin 
case (addr) 
	8'h0x0: q<=4'b0111;
	8'h0x1: q<=4'b0000;
	8'h0x2: q<=4'b0010;
	8'h0x3: q<=4'b1000;
	8'h0x4: q<=4'b0000;
	8'h0x5: q<=4'b0100;
	8'h0x6: q<=4'b0100;
	8'h0x7: q<=4'b0000;
	8'h0x8: q<=4'b0000;
	8'h0x9: q<=4'b0000;
	8'h0xa: q<=4'b0000;
	8'h0xb: q<=4'b0010;
	8'h0xc: q<=4'b1000;
	8'h0xd: q<=4'b0000;
	8'h0xe: q<=4'b0000;
	8'h0xf: q<=4'b0000;
	8'h0x10: q<=4'b1011;
	8'h0x11: q<=4'b1011;
	8'h0x12: q<=4'b1011;
	8'h0x13: q<=4'b1011;
	8'h0x14: q<=4'b1011;
	8'h0x15: q<=4'b1011;
	8'h0x16: q<=4'b0100;
	8'h0x17: q<=4'b1011;
	8'h0x18: q<=4'b1011;
	8'h0x19: q<=4'b1011;
	8'h0x1a: q<=4'b1011;
	8'h0x1b: q<=4'b1011;
	8'h0x1c: q<=4'b1011;
	8'h0x1d: q<=4'b1011;
	8'h0x1e: q<=4'b1011;
	8'h0x1f: q<=4'b1011;
	8'h0x20: q<=4'b0011;
	8'h0x21: q<=4'b0011;
	8'h0x22: q<=4'b0011;
	8'h0x23: q<=4'b0011;
	8'h0x24: q<=4'b0011;
	8'h0x25: q<=4'b0011;
	8'h0x26: q<=4'b0011;
	8'h0x27: q<=4'b0011;
	8'h0x28: q<=4'b0011;
	8'h0x29: q<=4'b0011;
	8'h0x2a: q<=4'b0011;
	8'h0x2b: q<=4'b0011;
	8'h0x2c: q<=4'b0011;
	8'h0x2d: q<=4'b0011;
	8'h0x2e: q<=4'b0011;
	8'h0x2f: q<=4'b0011;
	8'h0x30: q<=4'b0011;
	8'h0x31: q<=4'b0011;
	8'h0x32: q<=4'b0011;
	8'h0x33: q<=4'b0011;
	8'h0x34: q<=4'b0011;
	8'h0x35: q<=4'b0011;
	8'h0x36: q<=4'b0011;
	8'h0x37: q<=4'b0011;
	8'h0x38: q<=4'b0011;
	8'h0x39: q<=4'b0011;
	8'h0x3a: q<=4'b0011;
	8'h0x3b: q<=4'b0011;
	8'h0x3c: q<=4'b0011;
	8'h0x3d: q<=4'b0011;
	8'h0x3e: q<=4'b0011;
	8'h0x3f: q<=4'b0011;
	8'h0x40: q<=4'b1011;
	8'h0x41: q<=4'b0011;
	8'h0x42: q<=4'b0011;
	8'h0x43: q<=4'b0100;
	8'h0x44: q<=4'b0000;
	8'h0x45: q<=4'b0111;
	8'h0x46: q<=4'b0001;
	8'h0x47: q<=4'b0001;
	8'h0x48: q<=4'b0000;
	8'h0x49: q<=4'b0000;
	8'h0x4a: q<=4'b0010;
	8'h0x4b: q<=4'b0010;
	8'h0x4c: q<=4'b0001;
	8'h0x4d: q<=4'b0000;
	8'h0x4e: q<=4'b0000;
	8'h0x4f: q<=4'b0000;
	8'h0x50: q<=4'b0000;
	8'h0x51: q<=4'b0000;
	8'h0x52: q<=4'b0000;
	8'h0x53: q<=4'b0000;
	8'h0x54: q<=4'b0000;
	8'h0x55: q<=4'b0000;
	8'h0x56: q<=4'b0000;
	8'h0x57: q<=4'b0000;
	8'h0x58: q<=4'b0000;
	8'h0x59: q<=4'b0000;
	8'h0x5a: q<=4'b0000;
	8'h0x5b: q<=4'b0000;
	8'h0x5c: q<=4'b0000;
	8'h0x5d: q<=4'b0000;
	8'h0x5e: q<=4'b0010;
	8'h0x5f: q<=4'b0000;
	8'h0x60: q<=4'b0000;
	8'h0x61: q<=4'b0010;
	8'h0x62: q<=4'b0010;
	8'h0x63: q<=4'b0001;
	8'h0x64: q<=4'b0000;
	8'h0x65: q<=4'b0000;
	8'h0x66: q<=4'b0000;
	8'h0x67: q<=4'b0000;
	8'h0x68: q<=4'b0000;
	8'h0x69: q<=4'b0000;
	8'h0x6a: q<=4'b0000;
	8'h0x6b: q<=4'b0000;
	8'h0x6c: q<=4'b0000;
	8'h0x6d: q<=4'b0000;
	8'h0x6e: q<=4'b0000;
	8'h0x6f: q<=4'b0000;
	8'h0x70: q<=4'b0000;
	8'h0x71: q<=4'b0000;
	8'h0x72: q<=4'b0000;
	8'h0x73: q<=4'b0000;
	8'h0x74: q<=4'b0000;
	8'h0x75: q<=4'b0000;
	8'h0x76: q<=4'b0000;
	8'h0x77: q<=4'b0000;
	8'h0x78: q<=4'b0000;
	8'h0x79: q<=4'b0000;
	8'h0x7a: q<=4'b0000;
	8'h0x7b: q<=4'b0000;
	8'h0x7c: q<=4'b1000;
	8'h0x7d: q<=4'b0000;
	8'h0x7e: q<=4'b0000;
	8'h0x7f: q<=4'b0000;
	8'h0x80: q<=4'b0000;
	8'h0x81: q<=4'b0010;
	8'h0x82: q<=4'b0010;
	8'h0x83: q<=4'b0001;
	8'h0x84: q<=4'b0000;
	8'h0x85: q<=4'b0000;
	8'h0x86: q<=4'b0000;
	8'h0x87: q<=4'b0000;
	8'h0x88: q<=4'b0000;
	8'h0x89: q<=4'b0000;
	8'h0x8a: q<=4'b0000;
	8'h0x8b: q<=4'b0000;
	8'h0x8c: q<=4'b0000;
	8'h0x8d: q<=4'b0000;
	8'h0x8e: q<=4'b0000;
	8'h0x8f: q<=4'b0000;
	8'h0x90: q<=4'b0000;
	8'h0x91: q<=4'b0000;
	8'h0x92: q<=4'b0000;
	8'h0x93: q<=4'b0000;
	8'h0x94: q<=4'b0000;
	8'h0x95: q<=4'b0000;
	8'h0x96: q<=4'b0000;
	8'h0x97: q<=4'b0000;
	8'h0x98: q<=4'b0010;
	8'h0x99: q<=4'b0010;
	8'h0x9a: q<=4'b0010;
	8'h0x9b: q<=4'b0000;
	8'h0x9c: q<=4'b0000;
	8'h0x9d: q<=4'b0000;
	8'h0x9e: q<=4'b0000;
	8'h0x9f: q<=4'b0000;
	8'h0xa0: q<=4'b0000;
	8'h0xa1: q<=4'b0000;
	8'h0xa2: q<=4'b0000;
	8'h0xa3: q<=4'b0000;
	8'h0xa4: q<=4'b0000;
	8'h0xa5: q<=4'b0000;
	8'h0xa6: q<=4'b0000;
	8'h0xa7: q<=4'b0000;
	8'h0xa8: q<=4'b0000;
	8'h0xa9: q<=4'b0000;
	8'h0xaa: q<=4'b0000;
	8'h0xab: q<=4'b0000;
	8'h0xac: q<=4'b0000;
	8'h0xad: q<=4'b0000;
	8'h0xae: q<=4'b0000;
	8'h0xaf: q<=4'b0100;
	8'h0xb0: q<=4'b0000;
	8'h0xb1: q<=4'b0000;
	8'h0xb2: q<=4'b0000;
	8'h0xb3: q<=4'b0000;
	8'h0xb4: q<=4'b1000;
	8'h0xb5: q<=4'b0000;
	8'h0xb6: q<=4'b0111;
	8'h0xb7: q<=4'b0100;
	8'h0xb8: q<=4'b0000;
	8'h0xb9: q<=4'b0000;
	8'h0xba: q<=4'b0000;
	8'h0xbb: q<=4'b0001;
	8'h0xbc: q<=4'b1100;
	8'h0xbd: q<=4'b0000;
	8'h0xbe: q<=4'b0000;
	8'h0xbf: q<=4'b0110;
	8'h0xc0: q<=4'b0000;
	8'h0xc1: q<=4'b0000;
	8'h0xc2: q<=4'b0010;
	8'h0xc3: q<=4'b0000;
	8'h0xc4: q<=4'b0010;
	8'h0xc5: q<=4'b0000;
	8'h0xc6: q<=4'b0000;
	8'h0xc7: q<=4'b0000;
	8'h0xc8: q<=4'b0000;
	8'h0xc9: q<=4'b0000;
	8'h0xca: q<=4'b0000;
	8'h0xcb: q<=4'b0010;
	8'h0xcc: q<=4'b0011;
	8'h0xcd: q<=4'b0001;
	8'h0xce: q<=4'b0000;
	8'h0xcf: q<=4'b0000;
	8'h0xd0: q<=4'b0001;
	8'h0xd1: q<=4'b0000;
	8'h0xd2: q<=4'b0000;
	8'h0xd3: q<=4'b0000;
	8'h0xd4: q<=4'b0001;
	8'h0xd5: q<=4'b0000;
	8'h0xd6: q<=4'b0000;
	8'h0xd7: q<=4'b1010;
	8'h0xd8: q<=4'b1000;
	8'h0xd9: q<=4'b0011;
	8'h0xda: q<=4'b0000;
	8'h0xdb: q<=4'b0000;
	8'h0xdc: q<=4'b0000;
	8'h0xdd: q<=4'b0000;
	8'h0xde: q<=4'b0000;
	8'h0xdf: q<=4'b0010;
	8'h0xe0: q<=4'b0010;
	8'h0xe1: q<=4'b0000;
	8'h0xe2: q<=4'b0010;
	8'h0xe3: q<=4'b0000;
	8'h0xe4: q<=4'b0000;
	8'h0xe5: q<=4'b0000;
	8'h0xe6: q<=4'b0001;
	8'h0xe7: q<=4'b1000;
	8'h0xe8: q<=4'b0000;
	8'h0xe9: q<=4'b0000;
	8'h0xea: q<=4'b0000;
	8'h0xeb: q<=4'b0011;
	8'h0xec: q<=4'b0000;
	8'h0xed: q<=4'b0001;
	8'h0xee: q<=4'b0000;
	8'h0xef: q<=4'b0010;
	8'h0xf0: q<=4'b0000;
	8'h0xf1: q<=4'b0001;
	8'h0xf2: q<=4'b0000;
	8'h0xf3: q<=4'b0010;
	8'h0xf4: q<=4'b0000;
	8'h0xf5: q<=4'b0000;
	8'h0xf6: q<=4'b0000;
	8'h0xf7: q<=4'b0001;
	8'h0xf8: q<=4'b0000;
	8'h0xf9: q<=4'b0000;
	8'h0xfa: q<=4'b0000;
	8'h0xfb: q<=4'b0000;
	8'h0xfc: q<=4'b0000;
	8'h0xfd: q<=4'b0000;
	8'h0xfe: q<=4'b1000;
	8'h0xff: q<=4'b0000;
endcase
end
assign dout=q;
endmodule
