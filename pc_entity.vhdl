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
    ea: out word;
    -- lookahead
    next_edsel: in edsel_type;
    next_easel: in std_logic;
    next_ea: out word;
    next_ed: out word);
end entity pc;
