-- Set of registers
-- sizes:(1,size)
--
-- clk--posedge clock input
-- reset--asynchronous reset
-- load--active high input loads register
-- d--register input
-- q--register output
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity rreg1 is port
(clk,reset,load:in std_logic;
 d:in std_logic;
 q:buffer std_logic);
end;

architecture archrreg1 of rreg1 is
begin
process(reset,clk)
begin
if reset='1' then
   q<='0';
elsif rising_edge(clk) then
   if load='1' then
      q<=d;
   end if;
end if;
end process;
end archrreg1;
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity rreg is
generic(size:integer :=2);
port(clk,reset,load:in std_logic;
d:in std_logic_vector(size-1 downto 0);
q:buffer std_logic_vector(size-1 downto 0));
end rreg;

architecture archrreg of rreg is 
begin
process(reset,clk) 
begin
if reset='1'then
   q<=(others=>'0');
elsif rising_edge(clk) then
   if load='1' then
      q<=d;
   end if;
end if;
end process;
end archrreg;