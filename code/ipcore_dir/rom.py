import sys
import math

def main(args):
   rom=[]
   with open(args[0],mode="r") as fp:
       cnt=0
       for line in fp:
         line=line.strip()
         rom.append(line)
   width = len(rom[0])
   entries = len(rom)
   addrwidth=(int(math.log(entries,2)))
   #print(width,entries,addrwidth)
   # pull mif off name
   namearray=args[0].split('.')
   romfile = open(namearray[0]+".v", "w")  
   romfile.write("module "+namearray[0]+"\n")
   romfile.write("(\n")
   romfile.write("input clk,\n")
   romfile.write("input ["+str(addrwidth-1)+":0] addr,\n")
   romfile.write("output ["+str(width-1)+":0] dout,\n")
   romfile.write("input cs );\n")
   romfile.write("reg ["+str(width-1)+":0] q;\n")
   romfile.write("always @(posedge clk) \n");
   romfile.write("begin \n");
   romfile.write("case (addr) \n");
   cnt=0
   for line in rom:
         outline="\t"+str(addrwidth)+"'h"+hex(cnt)+": q<="+str(width)+"'b"+line+";\n"
         #print(outline)
         romfile.write(outline)
         #        8'h00: d = 4'b0000;
         cnt=cnt+1
   romfile.write("endcase\n");
   romfile.write("end\n");
   romfile.write("assign dout=q;\n")
   romfile.write("endmodule\n")
   romfile.close()
if __name__ == "__main__":
   main(sys.argv[1:])

