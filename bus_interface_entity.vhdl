library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity bus_interface is
  port(
    ea: in word;
    ed: inout word;
    edsel: in edsel_type;
    d_in: in word;
    fsm_read: in std_logic;
    fsm_write: in std_logic;
    mem_read: out std_logic;
    mem_write: out std_logic;
    d_out, a_out: out word);
end entity bus_interface;
