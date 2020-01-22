library ieee; use ieee.std_logic_1164.all;

package types is
  constant N: positive := 16;
  subtype word is std_logic_vector(N-1 downto 0);
  type opc_type is (
    -- ac:  implicit (accumulator)
    -- i:   immediate
    -- m:   memory
    -- mi:  memory indirect
    -- dmi: displaced memory indirect
    illegal,
    load_i, load_m,  load_mi,  load_dmi,
    or_i,   or_m,    or_mi,    or_dmi,
    xor_i,  xor_m,   xor_mi,   xor_dmi,
    and_i,  and_m,   and_mi,   and_dmi,
    add_i,  add_m,   add_mi,   add_dmi,
    addc_i, addc_m,  addc_mi,  addc_dmi,
    sub_i,  sub_m,   sub_mi,   sub_dmi,
    subc_i, subc_m,  subc_mi,  subc_dmi,
    lsl_ac, lsl_m,   lsl_mi,   lsl_dmi,
    lsr_ac, lsr_m,   lsr_mi,   lsr_dmi,
    rol_ac, rol_m,   rol_mi,   rol_dmi,
    ror_ac, ror_m,   ror_mi,   ror_dmi,
    asl_ac, asl_m,   asl_mi,   asl_dmi,
    asr_ac, asr_m,   asr_mi,   asr_dmi,
    rcl_ac, rcl_m,   rcl_mi,   rcl_dmi, rcl_i, -- ask
    rcr_ac, rcr_m,   rcr_mi,   rcr_dmi, rcr_i, -- ask
    not_ac, not_m,   not_mi,   not_dmi,
            neg_m,   neg_mi,   neg_dmi,
    clr_ac,
    inc_ac, inc_m,   inc_mi,   inc_dmi,
    dec_ac, dec_m,   dec_mi,   dec_dmi,
    loadi,
            store_m, store_mi, store_dmi,
    jmp,
    bsr, bra, bhi, bls, bcc, bcs, bne, beq,
    bvc, bvs, bpl, bmi, bge, blt, bgt, ble);

    type alumode_type is (
      lsl, lsr, lrol, lror, asl, asr, rcl, rcr, lor, lxor, land, lnot, axc, axyc, sxyc, sxc);
    
    type xsel_type is (
      bus_ix, constant_zero, ac_feedback);
    
    type cinsel_type is (
      constant_zero, constant_one, carry_flag);
   
    type edsel_type is (
      reg_ac, reg_pc, memory_in);
    
    type condition_type is (
      F,   -- False
      T,   -- True
      HI,  -- Higher
      LS,  -- Lower or same
      CC,  -- Carry clear
      CS,  -- Carry set
      NE,  -- Not equal
      EQ,  -- Equal
      VC,  -- Overflow clear
      VS,  -- Overflow set
      PL,  -- Plus
      MI,  -- Minus
      GE,  -- Greater or equal
      LT,  -- Less than
      GT,  -- Greater than
      LE); -- Less or equal
 
    type disassembled_ir_type is record
        opc: opc_type;
        xsel: xsel_type;
        cinsel: cinsel_type;
        alumode: alumode_type;
        condition: condition_type;
      end record disassembled_ir_type;
end package types;
