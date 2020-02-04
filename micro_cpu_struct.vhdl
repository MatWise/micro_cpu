library work; use work.all;

architecture struct of micro_cpu is
  signal ea, ed: word;
  signal edsel: edsel_type;
  signal fsm_read, fsm_write: std_logic;
  signal xsel: xsel_type;
  signal cinsel: cinsel_type;
  signal alumode: alumode_type;
  signal acena, srena: std_logic;
  signal ix: word;
  signal sr: std_logic_vector(3 downto 0);
  signal aasel, easel, mxena, irena, aaena: std_logic;
  signal ir: word;
  signal pcsel, pdsel, pcena: std_logic;
  signal disassembled_ir: disassembled_ir_type;
  signal cc_out: std_logic;
  -- lookahead
  signal next_easel: std_logic;
  signal next_edsel: edsel_type;
  signal next_ea, next_ed: word;
begin
  interface: entity work.bus_interface
  port map(
    next_ea => next_ea,
    next_ed => next_ed,
    ed => ed,
    edsel => edsel,
    d_in => d_in,
    fsm_read => fsm_read,
    fsm_write => fsm_write,
    mem_read => mem_read,
    mem_write => mem_write,
    d_out => d_out,
    a_out => a_out);

  alu: entity work.alu
  port map(
    clk => clk,
    res_n => res_n,
    xsel => xsel,
    cinsel => cinsel,
    alumode => alumode,
    acena => acena,
    srena => srena,
    edsel => edsel,
    ix => ix,
    ed => ed,
    sr => sr,
    next_edsel => next_edsel,
    next_ed => next_ed);

  memory_reg: entity work.memory_reg
  port map(
    clk => clk,
    res_n => res_n,
    ed => ed,
    aasel => aasel,
    easel => easel,
    mxena => mxena,
    irena => irena,
    aaena => aaena,
    ix => ix,
    ir => ir,
    ea => ea,
    next_easel => next_easel,
    next_ea => next_ea);
  
  pc: entity work.pc
  port map(
    clk => clk,
    res_n => res_n,
    edsel => edsel,
    easel => easel,
    pcsel => pcsel,
    pdsel => pdsel,
    pcena => pcena,
    ix => ix,
    ed => ed,
    ea => ea,
    next_edsel => next_edsel,
    next_easel => next_easel,
    next_ed => next_ed,
    next_ea => next_ea);

  disassembler: entity work.disassembler
  port map(
    ir => ir,
    disassembled_ir => disassembled_ir);
  
  condition_decoder: entity work.condition_decoder
  port map(
    condition => disassembled_ir.condition,
    sr => sr,
    cc_out => cc_out);
  
  control_unit: entity work.control_unit
  port map(
    disassembled_ir => disassembled_ir,
    cc_out => cc_out,
    clk => clk,
    res_n => res_n,
    alumode => alumode,
    cinsel => cinsel,
    xsel => xsel,
    acena => acena,
    srena => srena,
    mxena => mxena,
    aasel => aasel,
    aaena => aaena,
    irena => irena,
    pdsel => pdsel,
    pcsel => pcsel,
    pcena => pcena,
    easel => easel,
    edsel => edsel,
    fsm_read => fsm_read,
    fsm_write => fsm_write,
    next_easel => next_easel,
    next_edsel => next_edsel);
end architecture struct;

