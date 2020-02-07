library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library basic;
use basic.mnemonics.all;
use basic.regs_pkg.all;

entity ram_regs_E2 is port(
     clk,rst:in std_logic;
     a,b,f:in unsigned(3 downto 0);
     dest_ctl:in std_logic_vector(2 downto 0);
     ram0:inout std_logic;
	  ram3:in std_logic;
     ad,bd:buffer unsigned(3 downto 0));
end ram_regs_E2;

architecture archram_regs of ram_regs_E2 is
     signal ram_en:std_logic;
     signal data:unsigned(3 downto 0);
     signal en:std_logic_vector(15 downto 0);
     type ram_array is array (15 downto 0) of unsigned(3 downto 0);
     signal ab_data:ram_array;
begin
--define register array
gen: for i in 15 downto 0 generate
       ram:ureg generic map(4)
            port map(clk,rst,en(i),data,ab_data(i));
     end generate;
--decode b to determine which register is enabled
with dest_ctl select
     ram_en<='0' when qreg|nop,
             '1' when others;
decode_b:process(b)
       begin
           for i in 0 to 15 loop
             if to_integer(b)=i then en(i)<=ram_en;
             else en(i)<='0';
             end if;
           end loop;
       end process;
--define data input to register array(write):
with dest_ctl select
   data<=(f(2),f(1),f(0),ram0) when ramqu | ramu,--shift up
         (ram3,f(3),f(2),f(1)) when ramqd | ramd,--shift down
         f when rama | ramf,
         "----" when others;
--define reg_array output for a and b regs(read):
   ad<=ab_data(to_integer(a));
   bd<=ab_data(to_integer(b));
--define ram0 and ram3 inouts:
--ram3<=f(3) when (dest_ctl=ramu or dest_ctl=ramqu)else 'Z';
ram0<=f(0) when (dest_ctl=ramd or dest_ctl=ramqd)else 'Z';

end archram_regs;