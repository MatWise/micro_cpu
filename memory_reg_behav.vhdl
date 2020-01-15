library ieee; use ieee.numeric_std.all;

architecture behav of memory_reg is
  signal mx, ir_int, aa, aa_int: word;
begin
  reg: process(clk) is
  begin
    if clk = '1' and clk'event then
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
  
  logic: process(mx, easel, ed, aa) is
    variable adder: word;
  begin
    adder := std_logic_vector(unsigned(mx) + unsigned(aa));
    if aasel = '0' then
      aa_int <= ed;
    elsif aasel = '1' then
      aa_int <= adder;
    end if;
  end process logic;    
  
  memory_reg_output: process(ir_int, mx, easel) is
  begin
    if easel = '1' then
      ea <= aa;
    end if;
    ir <= ir_int;
    ix <= mx;
  end process memory_reg_output;
end architecture behav;
