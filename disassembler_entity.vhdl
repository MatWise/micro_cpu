library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity disassembler is
  port(
    ir: in word;
    disassembled_ir: out disassembled_ir_type);
end entity disassembler;
