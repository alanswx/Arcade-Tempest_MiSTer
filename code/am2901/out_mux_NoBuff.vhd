library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library basic;
use basic.mnemonics.all;

entity out_mux_NoBuff is port(
     ad,f:in unsigned(3 downto 0);
     dest_ctl:in std_logic_vector(2 downto 0);
     oe:in std_logic;
     y:out unsigned(3 downto 0));
end out_mux_NoBuff;

architecture archout_mux of out_mux_NoBuff is
signal y_int:unsigned(3 downto 0);
signal y_foo:unsigned(3 downto 0);
begin
y<=y_foo;
y_int<=ad when dest_ctl=rama else f;
y_foo<=y_int when oe='1' else "ZZZZ";
end archout_mux;