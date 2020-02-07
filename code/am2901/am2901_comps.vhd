library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
package am2901_comps is 
      component ram_regs port( 
              clk,rst:in std_logic; 
              a,b,f:in unsigned(3 downto 0); 
              dest_ctl:in std_logic_vector(2 downto 0); 
              ram0,ram3:inout std_logic; 
              ad,bd:buffer unsigned(3 downto 0)); 
      end component; 
       
      component q_reg port( 
              clk,rst:in std_logic; 
              f:in unsigned(3 downto 0); 
              dest_ctl:in std_logic_vector(2 downto 0); 
              qs0,qs3:inout std_logic; 
              q:buffer unsigned(3 downto 0)); 
      end component; 
 
      component src_op port( 
              src_ctl:in std_logic_vector(2 downto 0); 
              d,ad,bd,q:in unsigned(3 downto 0); 
              r,s:buffer unsigned(3 downto 0)); 
      end component; 
 
      component alu port( 
              r,s:in unsigned(3 downto 0); 
              c_n:in std_logic;--carry or borrow 
              alu_ctl:in std_logic_vector(2 downto 0); 
              f:buffer unsigned(3 downto 0); 
              g_bar,p_bar:buffer std_logic; 
              c_n4:buffer std_logic; 
              ovr:buffer std_logic); 
      end component; 
 
      component out_mux port( 
              ad,f:in unsigned(3 downto 0); 
              dest_ctl:in std_logic_vector(2 downto 0); 
              oe:in std_logic; 
              y:buffer unsigned(3 downto 0)); 
      end component; 
end am2901_comps;
