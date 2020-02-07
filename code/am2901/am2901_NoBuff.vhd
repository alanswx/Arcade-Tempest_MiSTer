library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
library basic;
use basic.am2901_comps_NoBuff.all; 

entity am2901_NoBuff is port( 
     clk,rst:in std_logic; 
     a,b:in unsigned(3 downto 0); 
     d:in unsigned(3 downto 0); 
     i:in std_logic_vector(8 downto 0); 
     c_n:in std_logic; 
     oe:in std_logic; 
     ram0,ram3:inout std_logic; 
     qs0,qs3:inout std_logic; 
     y:out unsigned(3 downto 0); 
     g_bar,p_bar:buffer std_logic; 
     ovr:out std_logic; 
     c_n4:out std_logic; 
     f_0:buffer std_logic; 
     f_3:out std_logic); 
end am2901_NoBuff; 
 
architecture archam2901 of am2901_NoBuff is 
     alias dest_ctl:std_logic_vector(2 downto 0) is i(8 downto 6); 
     alias alu_ctl:std_logic_vector(2 downto 0) is i(5 downto 3); 
     alias src_ctl:std_logic_vector(2 downto 0) is i(2 downto 0); 
     signal ad,bd:unsigned(3 downto 0); 
     signal q:unsigned(3 downto 0); 
     signal r,s:unsigned(3 downto 0); 
     signal f:unsigned(3 downto 0);
	 signal f_3_foo:std_logic;
begin 
 
--instantiate and connect components 
u1:ram_regs port map(clk=>clk,rst=>rst,a=>a,b=>b,f=>f,dest_ctl=>dest_ctl,ram0=>ram0,ram3=>ram3,ad=>ad,bd=>bd); 
u2:q_reg port map(clk=>clk,rst=>rst,f=>f,dest_ctl=>dest_ctl,qs0=>qs0,qs3=>qs3,q=>q); 
u3:src_op port map(src_ctl=>src_ctl,d=>d,ad=>ad,bd=>bd,q=>q,r=>r,s=>s); 
u4:alu_NoBuff port map(r=>r,s=>s,c_n=>c_n,alu_ctl=>alu_ctl,f=>f,g_bar=>g_bar,p_bar=>p_bar,c_n4=>c_n4,ovr=>ovr); 
u5:out_mux_NoBuff port map(ad=>ad,f=>f,dest_ctl=>dest_ctl,oe=>oe,y=>y); 
 
--define f_0 and f_3 outputs 
f_3 <= f_3_foo;
f_0<='0' when f="0000" else 'Z'; 
f_3_foo<=f(3); 
 
end archam2901;
