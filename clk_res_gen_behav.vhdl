architecture behav of clk_res_gen is
begin
  osc: process is
  begin
    clk <= '1';
    wait for 20 ns;
    clk <= '0';
    wait for 20 ns;
  end process osc;
  
  reset: process is
  begin
    res_n <= '0';
    wait for 30 ns;
    res_n <= '1';
    wait;
  end process reset;
end architecture behav;
