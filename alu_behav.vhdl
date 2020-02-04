library ieee; use ieee.numeric_std.all;

architecture behav of alu is
 signal ac, ac_int: word;
 signal sr_int: std_logic_vector(3 downto 0);
begin
  logic: process(all) is
    variable x, y: word;
    variable c_in: std_logic;
    variable c_word: word;

    variable au_x, au_y: word;
    variable au_l, au_f: word;
    variable au_h: std_logic_vector(word'left + 1 downto word'left);
    variable au_c, au_v: std_logic;

    variable n, z, v, c: std_logic;
    variable f: word;
  begin
    case xsel is
    when bus_ix => x := ix;
    when constant_zero => x := (others => '0');
    when ac_feedback => x := ac;
    end case;
    y := ix;
    
    case cinsel is
    when constant_zero => c_in := '0';
    when constant_one => c_in := '1';
    when carry_flag => c_in := sr_int(2);
    end case;

    au_x := x;
    if alumode = axc or alumode = sxc then
      au_y := (others => '0');
    else
      au_y := ix;
    end if;

    c_word := (0 => c_in, others => '0');

    if alumode = axc or alumode = axyc then 
      au_l := std_logic_vector(
        unsigned('0' & au_x(au_x'left - 1 downto au_x'right)) + 
        unsigned('0' & au_y(au_y'left - 1 downto au_y'right)) + unsigned(c_word));
      au_h := std_logic_vector(
        unsigned('0' & au_x(au_x'left downto au_x'left)) +
        unsigned('0' & au_y(au_y'left downto au_y'left)) + 
        unsigned('0' & au_l(au_l'left downto au_l'left)));
    else
      au_l := std_logic_vector(
        unsigned('0' & au_x(au_x'left - 1 downto au_x'right)) - 
        unsigned('0' & au_y(au_y'left - 1 downto au_y'right)) - unsigned(c_word));
      au_h := std_logic_vector(
        unsigned('0' & au_x(au_x'left downto au_x'left)) - 
        unsigned('0' & au_y(au_y'left downto au_y'left)) -
        unsigned('0' & au_l(au_l'left downto au_l'left)));
    end if;

    au_c := au_h(au_h'left);
    au_v := au_h(au_h'left) xor au_l(au_l'left);
    au_f := au_h(au_h'right) & au_l(au_l'left - 1 downto au_l'right);
    
    case alumode is 
    when lsl =>  f := x(x'left - 1 downto x'right) & '0';        c := x(x'left);  v := x(x'left) xor x(x'left - 1); 
    when lsr =>  f := '0' & x(x'left downto x'right + 1);        c := x(x'right); v := x(x'left) xor '0';
    when lrol => f:= x(x'left - 1 downto x'right) & x(x'left);   c := x(x'left);  v := x(x'left) xor x(x'left - 1); 
    when lror => f := x(x'right) & x(x'left downto x'right + 1); c := x(x'right); v := x(x'left) xor x(x'right);
    when asl =>  f := x(x'left - 1 downto x'right) & '0';        c := x(x'left);  v := x(x'left) xor x(x'left - 1); 
    when asr =>  f := x(x'left) & x(x'left downto x'right + 1);  c := x(x'right); v := x(x'left) xor x(x'left);
    when rcl =>  f := x(x'left - 1 downto x'right) & c_in;       c := x(x'left);  v := x(x'left) xor x(x'left - 1); 
    when rcr =>  f := c_in & x(x'left downto x'right + 1);       c := x(x'right); v := x(x'left) xor c_in;
    when lor =>  f := x or y;                                    c := '0';        v := '0';
    when lxor => f := x xor y;                                   c := '0';        v := '0';
    when land => f := x and y;                                   c := '0';        v := '0';
    when lnot => f := not x;                                     c := '0';        v := '0';
    when axc | axyc | sxyc | sxc => f := au_f;                   c := au_c;       v := au_v;
    end case;

  n := f(f'left);
  if f = x"0000" then
    z := '1';
  else
    z := '0';
  end if;
  ac_int <= f;
  sr_int <= (n, z, v, c);
end process logic;

  reg: process(clk, res_n) is
    begin
      if res_n = '0' then
        ac <= (others => '0');
        sr <= (others => '0');
      elsif clk = '1' and clk'event then
        ac <= ac_int;
        sr <= sr_int;
      end if;
    end process reg;

  ac_output: process(all) is
  begin
    if edsel = reg_ac then
      ed <= ac;
    else
      ed <= (others => 'Z');
    end if;
  end process ac_output;

  lookahead: process(all) is
  begin
    if next_edsel = reg_ac then
      next_ed <= ac when acena = '0' else ac_int;
    else
      next_ed <= (others => 'Z');
    end if;
  end process lookahead;
  
end architecture behav;

