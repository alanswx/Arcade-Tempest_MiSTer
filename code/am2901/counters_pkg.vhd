library ieee; 
use ieee.std_logic_1164.all; 
 
package counters_pkg is 
      component ascount 
         generic(countersize:integer:=2); 
         port(clk,areset,sreset,enable:in std_logic; 
         count:buffer std_logic_vector(countersize-1 downto 0)); 
      end component; 
end counters_pkg;
