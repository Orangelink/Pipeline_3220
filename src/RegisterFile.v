module RegisterFile(clk, reset, reg_wr_en, wr_select, reg_select1, reg_select2,
                    reg_data1, reg_data2, wr_data);
   parameter bitwidth = 32;
   
   input clk, reset, reg_wr_en;
   input[3:0] reg_select1, reg_select2 , wr_select;
   input[bitwidth-1:0] wr_data;

   output[bitwidth - 1:0] reg_data1, reg_data2;
   reg[bitwidth - 1:0] reg_data1, reg_data2;
   
   wire[bitwidth-1:0] regout[0:15];   

   Register #(bitwidth,0) R0(clk, reset, (wr_select == 4'd0) & reg_wr_en, wr_data, regout[0]);
   Register #(bitwidth,0) R1(clk, reset, (wr_select == 4'd1) & reg_wr_en, wr_data, regout[1]);
   Register #(bitwidth,0) R2(clk, reset, (wr_select == 4'd2) & reg_wr_en, wr_data, regout[2]);
   Register #(bitwidth,0) R3(clk, reset, (wr_select == 4'd3) & reg_wr_en, wr_data, regout[3]);
   Register #(bitwidth,0) R4(clk, reset, (wr_select == 4'd4) & reg_wr_en, wr_data, regout[4]);
   Register #(bitwidth,0) R5(clk, reset, (wr_select == 4'd5) & reg_wr_en, wr_data, regout[5]);
   Register #(bitwidth,0) R6(clk, reset, (wr_select == 4'd6) & reg_wr_en, wr_data, regout[6]);
   Register #(bitwidth,0) R7(clk, reset, (wr_select == 4'd7) & reg_wr_en, wr_data, regout[7]);
   Register #(bitwidth,0) R8(clk, reset, (wr_select == 4'd8) & reg_wr_en, wr_data, regout[8]);
   Register #(bitwidth,0) R9(clk, reset, (wr_select == 4'd9) & reg_wr_en, wr_data, regout[9]);
   Register #(bitwidth,0) R10(clk, reset, (wr_select == 4'd10) & reg_wr_en, wr_data, regout[10]);
   Register #(bitwidth,0) R11(clk, reset, (wr_select == 4'd11) & reg_wr_en, wr_data, regout[11]);
   Register #(bitwidth,0) R12(clk, reset, (wr_select == 4'd12) & reg_wr_en, wr_data, regout[12]);
   Register #(bitwidth,0) R13(clk, reset, (wr_select == 4'd13) & reg_wr_en, wr_data, regout[13]);
   Register #(bitwidth,0) R14(clk, reset, (wr_select == 4'd14) & reg_wr_en, wr_data, regout[14]);
   Register #(bitwidth,0) R15(clk, reset, (wr_select == 4'd15) & reg_wr_en, wr_data, regout[15]);

   always @* begin
      case(reg_select1)
        4'b0000: reg_data1 = regout[0];
        4'b0001: reg_data1 = regout[1];
        4'b0010: reg_data1 = regout[2];
        4'b0011: reg_data1 = regout[3];
        4'b0100: reg_data1 = regout[4];
        4'b0101: reg_data1 = regout[5];
        4'b0110: reg_data1 = regout[6];
        4'b0111: reg_data1 = regout[7];
        4'b1000: reg_data1 = regout[8];
        4'b1001: reg_data1 = regout[9];
        4'b1010: reg_data1 = regout[10];
        4'b1011: reg_data1 = regout[11];
        4'b1100: reg_data1 = regout[12];
        4'b1101: reg_data1 = regout[13];
        4'b1110: reg_data1 = regout[14];
        4'b1111: reg_data1 = regout[15];
      endcase // case (reg_select1)
   end // always @ (reg_select1, regout)

   always @* begin
      case(reg_select2)
        4'b0000: reg_data2 = regout[0];
        4'b0001: reg_data2 = regout[1];
        4'b0010: reg_data2 = regout[2];
        4'b0011: reg_data2 = regout[3];
        4'b0100: reg_data2 = regout[4];
        4'b0101: reg_data2 = regout[5];
        4'b0110: reg_data2 = regout[6];
        4'b0111: reg_data2 = regout[7];
        4'b1000: reg_data2 = regout[8];
        4'b1001: reg_data2 = regout[9];
        4'b1010: reg_data2 = regout[10];
        4'b1011: reg_data2 = regout[11];
        4'b1100: reg_data2 = regout[12];
        4'b1101: reg_data2 = regout[13];
        4'b1110: reg_data2 = regout[14];
        4'b1111: reg_data2 = regout[15];
      endcase // case (reg_select2)
   end // always @ (reg_select2, regout)

endmodule // RegisterFile
