library work; use work.all;
library work; use work.types.all;
library ieee; use ieee.std_logic_1164.all;

architecture struct of micro_cpu_synth is
  signal clk, res_n: std_logic;
  signal d_in, d_out: word;
  signal mem_read, mem_write: std_logic; -- mem_read is unused
begin
  micro_cpu: entity work.micro_cpu
  port map(
    clk => clk,
    res_n => res_n,
    d_in => d_in,
    d_out => d_out,
    mem_read => mem_read,
    mem_write => mem_write);
  
  ram: entity work.ram
  port map(
    address => a_out(7 downto 0), -- use lower bits of ea
    clock => clk,
    data => d_out,
    wren => mem_write,
    q => d_in);
end architecture struct;
