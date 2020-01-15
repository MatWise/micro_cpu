architecture behav of bus_interface is
begin
  process(fsm_read, fsm_write, edsel, ed, ea, d_in) is
  begin
    mem_read <= fsm_read;
    mem_write <= fsm_write;
    a_out <= ea;
    d_out <= ed;
    if edsel = memory_in then
      ed <= d_in;
    end if;
  end process;
end architecture behav;
