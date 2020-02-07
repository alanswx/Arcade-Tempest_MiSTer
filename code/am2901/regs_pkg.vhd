library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
package regs_pkg is 
      component rdff1 port( 
         clk,reset:in std_logic; 
         d:        in std_logic; 
         q:        buffer std_logic); 
      end component; 
 
      component rdff  
         generic (size:integer :=2); 
         port(clk,reset:in std_logic; 
         d:             in std_logic_vector(size-1 downto 0); 
         q:             buffer std_logic_vector(size-1 downto 0)); 
      end component; 
 
      component rreg1 port( 
         clk,reset,load:in std_logic; 
         d:             in std_logic; 
         q:             buffer std_logic); 
      end component; 
 
      component reg 
         generic(size:integer:=2); 
         port(clk,load:in std_logic; 
              rst,pst: in std_logic; 
              d:       in std_logic_vector(size-1 downto 0); 
              q:       buffer std_logic_vector(size-1 downto 0)); 
      end component; 
 
      component ureg 
         generic(size:integer:=2); 
         port(clk,reset,load:in std_logic; 
         d:                  in unsigned(size-1 downto 0); 
         q:                  buffer unsigned(size-1 downto 0)); 
      end component; 
end regs_pkg; 
