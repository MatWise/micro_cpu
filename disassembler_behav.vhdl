architecture behav of disassembler is
begin
  process(ir) is
    variable opc_am: std_logic_vector(5 downto 0);
    variable opc: opc_type;
    variable disassembled_ir_int: disassembled_ir_type;
    variable xsel_ir: std_logic_vector(1 downto 0); 
    variable xsel: xsel_type;   
    variable cinsel_ir: std_logic_vector(1 downto 0); 
    variable cinsel: cinsel_type; 
    variable alumode_ir: std_logic_vector(3 downto 0);
    variable alumode: alumode_type;
    variable condition: condition_type;  
  begin
    opc_am := ir(14 downto 12) & ir(10 downto 8);
    case opc_am is
    when "000000" =>
      case ir(7 downto 0) is
      when x"A0" => opc := lsl_ac;
      when x"A1" => opc := lsr_ac;
      when x"A2" => opc := rol_ac;
      when x"A3" => opc := ror_ac;
      when x"A4" => opc := asl_ac;
      when x"A5" => opc := asr_ac;
      when x"A6" => opc := rcl_ac;
      when x"A7" => opc := rcr_ac;
      when x"8B" => opc := rol_ac;
      when x"4C" => opc := clr_ac;
      when x"9C" => opc := inc_ac;
      when x"9F" => opc := dec_ac;
      when others => opc := illegal;
      end case;
    when "000001" =>
      case ir(7 downto 0) is
      when x"0C" => opc := load_i;
      when x"88" => opc := or_i;
      when x"89" => opc := xor_i;
      when x"8A" => opc := and_i;
      when x"8D" => opc := add_i;
      when x"AD" => opc := addc_i;
      when x"8E" => opc := sub_i;
      when x"AE" => opc := subc_i;
      when x"26" => opc := rcl_i;
      when x"27" => opc := rcr_i;
      when others => opc := illegal;
      end case;
    when "000010" =>
      case ir(7 downto 0) is
      when x"0C" => opc := load_m;
      when x"88" => opc := or_m;
      when x"89" => opc := xor_m;
      when x"8A" => opc := and_m;
      when x"8D" => opc := add_m;
      when x"AD" => opc := addc_m;
      when x"8E" => opc := sub_m;
      when x"AE" => opc := subc_m;
      when x"20" => opc := lsl_m;
      when x"21" => opc := lsr_m;
      when x"22" => opc := rol_m;
      when x"23" => opc := ror_m;
      when x"24" => opc := asl_m;
      when x"25" => opc := asr_m;
      when x"26" => opc := rcl_m;
      when x"27" => opc := rcr_m;
      when x"0B" => opc := rol_m;
      when x"4E" => opc := neg_m;
      when x"1C" => opc := inc_m;    
      when x"1F" => opc := dec_m;
      when others => opc := illegal;
      end case;
    when "000011" =>
      case ir(7 downto 0) is
      when x"0C" => opc := load_mi;
      when x"88" => opc := or_mi;
      when x"89" => opc := xor_mi;
      when x"8A" => opc := and_mi;
      when x"8D" => opc := add_mi;
      when x"AD" => opc := addc_mi;
      when x"8E" => opc := sub_mi;
      when x"AE" => opc := subc_mi;
      when x"20" => opc := lsl_mi;
      when x"21" => opc := lsr_mi;
      when x"22" => opc := rol_mi;
      when x"23" => opc := ror_mi;
      when x"24" => opc := asl_mi;
      when x"25" => opc := asr_mi;
      when x"26" => opc := rcl_mi;
      when x"27" => opc := rcr_mi;
      when x"0B" => opc := rol_mi;
      when x"4E" => opc := neg_mi;
      when x"1C" => opc := inc_mi;    
      when x"1F" => opc := dec_mi;
      when others => opc := illegal;
      end case;
    when "010000" =>
      case ir(7 downto 0) is
      when x"0C" => opc := loadi;
      when others => opc := illegal;
      end case;
     when "011010" =>
      case ir(7 downto 0) is
      when x"00" => opc := store_m;
      when others => opc := illegal;
      end case;
     when "011011" =>
      case ir(7 downto 0) is
      when x"00" => opc := store_mi;
      when others => opc := illegal;
      end case;
     when "100000" =>
      case ir(7 downto 0) is
      when x"00" => opc := jmp;
      when others => opc := illegal;
      end case;
     when "101001" =>
      case ir(7 downto 0) is
      when x"0C" => opc := bsr;
      when others => opc := illegal;
      end case;
     when "110001" =>
      case ir(7 downto 0) is
      when x"01" => opc := bra;
      when x"02" => opc := bhi;
      when x"03" => opc := bls;
      when x"04" => opc := bcc;
      when x"05" => opc := bcs;
      when x"06" => opc := bne;
      when x"07" => opc := beq;
      when x"08" => opc := bvc;
      when x"09" => opc := bvs;
      when x"0A" => opc := bpl;
      when x"0B" => opc := bmi;
      when x"0C" => opc := bge;
      when x"0D" => opc := blt;
      when x"0E" => opc := bgt;
      when x"0F" => opc := ble;
      when others => opc := illegal;
      end case;
    when others => opc := illegal;
    end case;
    
    xsel_ir := ir(7 downto 6);
    case xsel_ir is
    when "00" => xsel := bus_ix;
    when "01" => xsel := constant_zero;
    when others => xsel := ac_feedback;
    end case;

    cinsel_ir := ir(5 downto 4);
    case cinsel_ir is
    when "00" => cinsel := constant_zero;
    when "01" => cinsel := constant_one;
    when others => cinsel := carry_flag;
    end case;

    alumode_ir := ir(3 downto 0);
    case alumode_ir is
    when "0000" => alumode := lsl;  condition := F;
    when "0001" => alumode := lsr;  condition := T;
    when "0010" => alumode := lrol; condition := HI;
    when "0011" => alumode := lror; condition := LS;
    when "0100" => alumode := asl;  condition := CC;
    when "0101" => alumode := asr;  condition := CS;
    when "0110" => alumode := rcl;  condition := NE;
    when "0111" => alumode := rcr;  condition := EQ;
    when "1000" => alumode := lor;  condition := VC;
    when "1001" => alumode := lxor; condition := VS;
    when "1010" => alumode := land; condition := PL;
    when "1011" => alumode := lnot; condition := MI;
    when "1100" => alumode := axc;  condition := GE;
    when "1101" => alumode := axyc; condition := LT;
    when "1110" => alumode := sxyc; condition := GT;
    when others => alumode := sxc;  condition := LE;
    end case;
    
    disassembled_ir.opc <= opc;
    disassembled_ir.xsel <= xsel;
    disassembled_ir.cinsel <= cinsel;
    disassembled_ir.alumode <= alumode;
    disassembled_ir.condition <= condition;
  end process;

end architecture behav;