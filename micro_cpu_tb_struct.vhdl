library work; use work.all;
library work; use work.types.all;
library ieee; use ieee.std_logic_1164.all;

architecture struct of micro_cpu_tb is
  signal clk, res_n: std_logic;
  signal d_in, d_out: word;
  signal mem_read, mem_write: std_logic;
begin
  micro_cpu: entity work.micro_cpu
  port map(
    clk => clk,
    res_n => res_n,
    d_in => d_in,
    d_out => d_out,
    mem_read => mem_read,
    mem_write => mem_write);
  
  clk_res_gen: entity work.clk_res_gen
  port map(
    clk => clk,
    res_n => res_n);
end architecture struct;
