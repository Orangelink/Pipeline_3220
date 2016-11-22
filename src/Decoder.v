module Decoder(inst, op_code, func_code, rd, rs1, rs2, imm);
      parameter bitwidth=32;
      input[bitwidth-1:0] inst;
      output[3:0] op_code,func_code,rd,rs1,rs2;
      reg[3:0] op_code,func_code,rd,rs1,rs2;
      output[15:0] imm;
      reg[15:0] imm;
      always @(inst) 
      begin
         op_code = inst[31:28];
         func_code = inst[27:24];
         rd  = inst[23:20];
         rs1 = inst[19:16];
         rs2 = inst[15:12];
         imm = inst[15:0];
      end
endmodule
