library ieee; use ieee.std_logic_1164.all;
library work; use work.types.all;

entity condition_decoder is
  port(
    condition: in condition_type;
    sr: in std_logic_vector(3 downto 0);
    cc_out: out std_logic);
end entity condition_decoder;
