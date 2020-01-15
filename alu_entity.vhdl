library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity alu is
  port(
    clk: in std_logic;
    xsel: in xsel_type;
    cinsel: in cinsel_type;
    alumode: in alumode_type;
    acena: in std_logic;
    srena: in std_logic;
    edsel: in edsel_type;
    ix: in word;
    ed: out word;
    sr: out std_logic_vector(3 downto 0));
end entity alu;