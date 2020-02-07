library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library basic;
use basic.mnemonics.all;
use basic.regs_pkg.all;

entity q_reg is port(
       clk,rst:in std_logic;
       f:in unsigned(3 downto 0);
       dest_ctl:in std_logic_vector(2 downto 0);
       qs0,qs3:inout std_logic;
       q:buffer unsigned(3 downto 0));
end q_reg;

architecture archq_reg of q_reg is
       signal q_en:std_logic;
       signal data:unsigned(3 downto 0);
begin
--define q register
u1:ureg generic map(4)
      port map(clk,rst,q_en,data,q);
--define q_en
with dest_ctl select
      q_en<='1' when qreg|ramqd|ramqu,
            '0' when others;
--define data input to q register:
with dest_ctl select
      data<=(f(2),f(1),f(0),qs0)when ramqu,--shift up
            (qs3,f(3),f(2),f(1))when ramqd,--shift down
            f when qreg,
            "----"when others;
--define qs0 and qs3 inouts:
qs3<=f(3)when(dest_ctl=ramu or dest_ctl=ramqu)else 'Z';
qs0<=f(0)when(dest_ctl=ramd or dest_ctl=ramqd)else 'Z';
end archq_reg;