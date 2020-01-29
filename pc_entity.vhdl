library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity pc is
  port(
    clk, res_n: in std_logic;
    edsel: in edsel_type;
    easel: in std_logic;
    pcsel: in std_logic;
    pdsel: in std_logic;
    pcena: in std_logic;
    ix: in word;
    ed: out word;
    ea: out word);
end entity pc;
