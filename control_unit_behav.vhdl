architecture behav of control_unit is
 type fsm_state is (
    fetch_opc,
    decode,
    fetch_i,
    fetch_m,
    load_addr,
    load_op,
    execute,
    store,
    ac_to_aa,
    ac_to_mx,
    jump,
    branch,
    save_pc,
    calc_addr);
  signal current_state: fsm_state;
  signal next_state, next_state_int: fsm_state;
begin
  state_reg: process(clk, res_n) is
  begin
    if res_n = '0' then
      current_state <= fetch_opc;
      next_state <= decode;
    elsif clk'event and clk = '1' then
      current_state <= next_state;
      next_state <= next_state_int;
    end if;
  end process state_reg;

  do_fsm: process(current_state) is
  begin
    case current_state is
    when fetch_opc => 
      easel <= '1';
      edsel <= memory_in;
      mxena <= '0';
      aasel <= '-';
      aaena <= '0';
      irena <= '1';
      pdsel <= '1';
      pcsel <= '0';
      pcena <= '1';
      acena <= '0';
      fsm_read <= '1';
      fsm_write <= '0';
    when decode =>
      easel <= '-';
      edsel <= reg_ac;
      mxena <= '0';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '0';
      fsm_read <= '0';
      fsm_write <= '0';
    when fetch_i => 
      easel <= '1';
      edsel <= memory_in;
      mxena <= '1';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '1';
      pcsel <= '0';
      pcena <= '1';
      acena <= '0';
      fsm_read <= '1';
      fsm_write <= '0';
    when fetch_m => 
      easel <= '1';
      edsel <= memory_in;
      mxena <= '0';
      aasel <= '0';
      aaena <= '1';
      irena <= '0';
      pdsel <= '1';
      pcsel <= '0';
      pcena <= '1';
      acena <= '0';
      fsm_read <= '1';
      fsm_write <= '0';
    when load_addr => 
      easel <= '0';
      edsel <= memory_in;
      mxena <= '0';
      aasel <= '0';
      aaena <= '1';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '0';
      fsm_read <= '1';
      fsm_write <= '0';
    when load_op => 
      easel <= '0';
      edsel <= memory_in;
      mxena <= '1';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '0';
      fsm_read <= '1';
      fsm_write <= '0';
    when execute => 
      easel <= '-';
      edsel <= reg_ac;
      mxena <= '0';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '1';
      fsm_read <= '0';
      fsm_write <= '0';
    when store => 
      easel <= '0';
      edsel <= reg_ac;
      mxena <= '0';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '0';
      fsm_read <= '0';
      fsm_write <= '1';
    when ac_to_aa => 
      easel <= '-';
      edsel <= reg_ac;
      mxena <= '0';
      aasel <= '0';
      aaena <= '1';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '0';
      fsm_read <= '0';
      fsm_write <= '0';
    when ac_to_mx => 
      easel <= '-';
      edsel <= reg_ac;
      mxena <= '1';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '0';
      fsm_read <= '0';
      fsm_write <= '0';
    when jump => 
      easel <= '-';
      edsel <= reg_ac;
      mxena <= '0';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '1';
      pcena <= '1';
      acena <= '0';
      fsm_read <= '0';
      fsm_write <= '0';
    when branch => 
      easel <= '-';
      edsel <= reg_pc;
      mxena <= '1';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '0';
      pcsel <= '0';
      pcena <= '1';
      acena <= '0';
      fsm_read <= '0';
      fsm_write <= '0';
    when save_pc => 
      easel <= '-';
      edsel <= reg_ac;
      mxena <= '0';
      aasel <= '-';
      aaena <= '0';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '1';
      fsm_read <= '0';
      fsm_write <= '0';
    when calc_addr => 
      easel <= '-';
      edsel <= reg_ac;
      mxena <= '0';
      aasel <= '1';
      aaena <= '1';
      irena <= '0';
      pdsel <= '-';
      pcsel <= '-';
      pcena <= '0';
      acena <= '0';
      fsm_read <= '0';
      fsm_write <= '0';
    end case;
  end process do_fsm;
  
  calc_srena: process(all) is
  begin
    if disassembled_ir.xsel = bus_ix and 
       disassembled_ir.cinsel = constant_zero and 
       disassembled_ir.alumode = axc then
      srena <= '0';
    else
      srena <= acena;
    end if;
  end process calc_srena;

  determine_transition: process(all)
  begin
    case current_state is
    when fetch_opc => 
      next_state_int <= decode;
    when decode =>
      case disassembled_ir.opc is
      when lsl_ac | lsr_ac | rol_ac | ror_ac | asl_ac | asr_ac | rcl_ac | rcr_ac | not_ac | clr_ac | inc_ac | dec_ac =>
        next_state_int <= execute;
      when load_i   | or_i      |
           xor_i    | and_i     |
           add_i    | addc_i    |
           sub_i    | subc_i    |
           rcl_i    | rcr_i     |
           load_dmi | or_dmi    |
           xor_dmi  | and_dmi   |
           add_dmi  | addc_dmi  |
           sub_dmi  | subc_dmi  |
           lsl_dmi  | lsr_dmi   |
           rol_dmi  | ror_dmi   |
           asl_dmi  | asr_dmi   |
           rcl_dmi  | rcr_dmi   |
           not_dmi  | neg_dmi   |
           inc_dmi  | dec_dmi   |
           store_dmi =>
        next_state_int <= fetch_i;
      when loadi =>
        next_state_int <= ac_to_aa;
      when jmp =>
        next_state_int <= ac_to_mx;
      when others =>
        next_state_int <= fetch_m;
      end case;
    when fetch_i =>
      case disassembled_ir.opc is
      when load_dmi | or_dmi    |
           xor_dmi  | and_dmi   |
           add_dmi  | addc_dmi  |
           sub_dmi  | subc_dmi  |
           lsl_dmi  | lsr_dmi   |
           rol_dmi  | ror_dmi   |
           asl_dmi  | asr_dmi   |
           rcl_dmi  | rcr_dmi   |
           not_dmi  | neg_dmi   |
           inc_dmi  | dec_dmi   |
           store_dmi =>
        next_state_int <= fetch_m;
      when bsr =>
        next_state_int <= branch;
      when bra | bhi | bls | bcc | bcs | bne | beq | bvc | 
           bvs | bpl | bmi | bge | blt | bgt | ble =>
        if cc_out = '1' then
          next_state_int <= branch;
        else
          next_state_int <= fetch_opc;
        end if;
      when others => 
        next_state_int <= execute;
      end case;
    when fetch_m =>
      case disassembled_ir.opc is
      when load_mi  | load_dmi  |
           or_mi    | or_dmi    | 
           xor_mi   | xor_dmi   | 
           and_mi   | and_dmi   | 
           add_mi   | add_dmi   | 
           addc_mi  | addc_dmi  | 
           sub_mi   | sub_dmi   | 
           subc_mi  | subc_dmi  | 
           lsl_mi   | lsl_dmi   | 
           lsr_mi   | lsr_dmi   |  
           rol_mi   | rol_dmi   | 
           ror_mi   | ror_dmi   | 
           asl_mi   | asl_dmi   | 
           asr_mi   | asr_dmi   |
           rcl_mi   | rcl_dmi   |
           rcr_mi   | rcr_dmi   |
           not_mi   | not_dmi   |
           neg_mi   | neg_dmi   |
           inc_mi   | inc_dmi   |
           dec_mi   | dec_dmi   |
           store_mi | store_dmi =>
        next_state_int <= load_addr;
      when store_m =>
        next_state_int <= store;
      when others => 
        next_state_int <= load_op;
      end case; 
    when load_addr =>
      case disassembled_ir.opc is
      when store_mi =>
        next_state_int <= store;
      when load_dmi | or_dmi    |
           xor_dmi  | and_dmi   |
           add_dmi  | addc_dmi  |
           sub_dmi  | subc_dmi  |
           lsl_dmi  | lsr_dmi   |
           rol_dmi  | ror_dmi   |
           asl_dmi  | asr_dmi   |
           rcl_dmi  | rcr_dmi   |
           not_dmi  | neg_dmi   |
           inc_dmi  | dec_dmi   |
           store_dmi =>
        next_state_int <= calc_addr;
      when others =>
        next_state_int <= load_op;
      end case;
    when load_op =>
      next_state_int <= execute;
    when execute =>
      next_state_int <= fetch_opc;
    when store =>
      next_state_int <= fetch_opc;
    when ac_to_aa =>
      next_state_int <= load_op;
    when ac_to_mx =>
      next_state_int <= jump;
    when jump =>
      next_state_int <= fetch_opc;
    when branch =>
      case disassembled_ir.opc is
      when bsr =>
        next_state_int <= save_pc;
      when others =>
        next_state_int <= fetch_opc;
      end case;
    when save_pc =>
      next_state_int <= fetch_opc;
    when calc_addr =>
      case disassembled_ir.opc is
      when store_dmi =>
        next_state_int <= store;
      when others =>
        next_state_int <= load_op;
      end case;
    end case;
  end process determine_transition;

  lookahead: process(next_state) is
  begin
    case next_state is
    when fetch_opc => 
      next_easel <= '1';
      next_edsel <= memory_in;
    when decode =>
      next_easel <= '-';
      next_edsel <= reg_ac;
    when fetch_i => 
      next_easel <= '1';
      next_edsel <= memory_in;
    when fetch_m => 
      next_easel <= '1';
      next_edsel <= memory_in;
    when load_addr => 
      next_easel <= '0';
      next_edsel <= memory_in;
    when load_op => 
      next_easel <= '0';
      next_edsel <= memory_in;
    when execute => 
      next_easel <= '-';
      next_edsel <= reg_ac;
    when store => 
      next_easel <= '0';
      next_edsel <= reg_ac;
    when ac_to_aa => 
      next_easel <= '-';
      next_edsel <= reg_ac;
    when ac_to_mx => 
      next_easel <= '-';
      next_edsel <= reg_ac;
    when jump => 
      next_easel <= '-';
      next_edsel <= reg_ac;
    when branch => 
      next_easel <= '-';
      next_edsel <= reg_pc;
    when save_pc => 
      next_easel <= '-';
      next_edsel <= reg_ac;
    when calc_addr => 
      next_easel <= '-';
      next_edsel <= reg_ac;
    end case;
  end process lookahead;
end architecture behav;

