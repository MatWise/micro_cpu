library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity control_unit is
port(
  disassembled_ir: in disassembled_ir_type;
  cc_out:          in std_logic;
  clk, res_n:      in std_logic;
  alumode:         out alumode_type;
  cinsel:          out cinsel_type;
  xsel:            out xsel_type;
  acena:           out std_logic;
  srena:           out std_logic;
  mxena:           out std_logic;
  aasel:           out std_logic;
  aaena:           out std_logic;
  irena:           out std_logic;
  pdsel:           out std_logic;
  pcsel:           out std_logic;
  pcena:           out std_logic;
  easel:           out std_logic;
  edsel:           out edsel_type;
  fsm_read:        out std_logic;
  fsm_write:       out std_logic;
  -- lookahead
  next_easel:      out std_logic;
  next_edsel:      out edsel_type);
end entity control_unit;
