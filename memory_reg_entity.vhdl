library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity memory_reg is
  port(
    clk: in std_logic;
    ed: in word;
    aasel: in std_logic;
    easel: in std_logic;
    mxena: in std_logic;
    irena: in std_logic;
    aaena: in std_logic;
    ix: out word;
    ir: out word;
    ea: out word);
end entity memory_reg;
