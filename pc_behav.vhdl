library ieee; use ieee.numeric_std.all;

architecture behav of pc is
  signal pc, pc_int: word;
begin
  logic: process(pdsel, pcsel, ix, pc) is
    variable adder: word;
  begin
    if pdsel = '1' then
      adder := std_logic_vector(unsigned(pc) + 1);
    elsif pdsel = '0' then
      adder := std_logic_vector(unsigned(pc) + unsigned(ix));
    end if;
    
    if pcsel = '0' then
      pc_int <= adder;
    elsif pcsel = '1' then
      pc_int <= ix;
    end if;
  end process logic;
  
  reg: process(clk, res_n) is
  begin
    if res_n = '0' then
      pc <= (others => '0');
    elsif clk = '1' and clk'event then
      if pcena = '1' then
        pc <= pc_int;
      end if;
    end if;
  end process reg;
  
  pc_output: process(easel, edsel) is
  begin
    if easel = '1' then
      ea <= pc;
    end if;
    if edsel = reg_pc then
      ed <= pc;
    end if;
  end process pc_output;
end architecture behav;
