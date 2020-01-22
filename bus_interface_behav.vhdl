architecture behav of bus_interface is
begin
  mem_read <= fsm_read;
  mem_write <= fsm_write;
  a_out <= ea;
  d_out <= ed;
  ed <= d_in when edsel = memory_in;
end architecture behav;
