library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library basic;
use basic.mnemonics.all;

entity src_op is port(
       src_ctl:in std_logic_vector(2 downto 0);
       d,ad,bd,q:in unsigned(3 downto 0);
       r,s:buffer unsigned(3 downto 0));
end src_op;

architecture archsrc_op of src_op is
begin
--decode alu operand r:
with src_ctl select
     r<=ad when aq|ab,
        "0000"when zq|zb|za,
        d when others;
with src_ctl select
     s<=bd when ab|zb,
        q when aq|zq|dq,
        ad when za|da,
        "0000" when others;
end archsrc_op;