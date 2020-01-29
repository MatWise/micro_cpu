library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity micro_cpu is
port(
  clk, res_n: in std_logic;
  d_in: in word;
  d_out, a_out: out word;
  mem_read, mem_write: out std_logic);
end entity micro_cpu;
  