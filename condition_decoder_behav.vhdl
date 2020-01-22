architecture behav of condition_decoder is
begin
  process(condition, sr) is
  begin
    case condition is
    when F => cc_out <= '0';
    when T => cc_out <= '1';
    when HI => cc_out <= '1' when sr(0) = '0' and sr(2) = '0' else '0';
    when LS => cc_out <= '1' when sr(0) = '1' or sr(2) = '1' else '0';
    when CC => cc_out <= '1' when sr(0) = '0' else '0';
    when CS => cc_out <= '1' when sr(0) = '1' else '0';
    when NE => cc_out <= '1' when sr(2) = '0' else '0';
    when EQ => cc_out <= '1' when sr(2) = '1' else '0';
    when VC => cc_out <= '1' when sr(1) = '0' else '0';
    when VS => cc_out <= '1' when sr(1) = '1' else '0';
    when PL => cc_out <= '1' when sr(3) = '0' else '0';
    when MI => cc_out <= '1' when sr(3) = '1' else '0';
    when GE => cc_out <= '0' when (sr(3) = '1' and sr(1) = '0') or (sr(3) = '0' and sr(1) = '1') else '1';
    when LT => cc_out <= '1' when (sr(3) = '1' and sr(1) = '0') or (sr(3) = '0' and sr(1) = '1') else '0';
    when GT => cc_out <= '0' when (sr(3) = '1' and sr(1) = '0') or (sr(3) = '0' and sr(1) = '1') or sr(2) = '1' else '1';
    when LE => cc_out <= '1' when (sr(3) = '1' and sr(1) = '0') or (sr(3) = '0' and sr(1) = '1') or sr(2) = '1' else '0';
    end case;
  end process;
end architecture behav;
