library ieee; use ieee.numeric_std.all;

architecture behav of memory_reg is
  signal mx, ir_int, aa, aa_int: word;
begin
  reg: process(clk, res_n) is
  begin
    if res_n = '0' then
      mx <= (others => '0');
      ir_int <= (others => '0');
      aa <= (others => '0');
    elsif clk = '1' and clk'event then
      if mxena = '1' then
        mx <= ed;
      end if;
      if irena = '1' then
        ir_int <= ed;
      end if;
      if aaena = '1' then
        aa <= aa_int;
      end if;
    end if;
  end process reg;
  
  logic: process(all) is
    variable adder: word;
  begin
    adder := std_logic_vector(unsigned(mx) + unsigned(aa));
    if aasel = '0' then
      aa_int <= ed;
    elsif aasel = '1' then
      aa_int <= adder;
    end if;
  end process logic;    
  
  memory_reg_output: process(all) is
  begin
    if easel = '1' then
      ea <= aa;
    else
      ea <= (others => 'Z'); 
    end if;
    ir <= ir_int;
    ix <= mx;
  end process memory_reg_output;

  lookahead: process(all) is
  begin
    if next_easel = '1' then
      next_ea <= aa when aaena = '0' else aa_int;
    else
      next_ea <= (others => 'Z');
    end if;
  end process lookahead;
end architecture behav;
