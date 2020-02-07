library ieee;
use ieee.std_logic_1164.all;

package synch_pkg is
      component rsynch port(
         clk,reset:in std_logic;
         d:in std_logic;
         q:buffer std_logic);
      end component;

      component psynch port(
         clk,preset:in std_logic;
         d:in std_logic;
         q:buffer std_logic);
      end component;
end synch_pkg;