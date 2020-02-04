architecture behav of bus_interface is
begin
  mem_read <= fsm_read;
  mem_write <= fsm_write;
  a_out <= next_ea;
  d_out <= next_ed;
  ed <= d_in when edsel = memory_in else (others => 'Z');
end architecture behav;
