module Alu(a,b,alu_func, cmp_func, flag, out);
   parameter bitwidth = 32;
   input signed [bitwidth-1:0]a,b;
   input[3:0] alu_func;
   input[3:0] cmp_func;

   output flag;
   reg flag;
   output signed [bitwidth-1:0] out;
   reg signed [bitwidth-1:0] out;
   
   always @(a,b,alu_func) begin
      case(alu_func)
        4'b0111: out = a + b;     //ADD
        4'b0110: out = a - b;     //SUB
        4'b0000: out = a & b;     //AND
        4'b0001: out = a | b;     //OR
        4'b0010: out = a ^ b;     //XOR
        4'b1000: out = ~(a & b);  //NAND
        4'b1001: out = ~(a | b);  //NOR
        4'b1010: out = ~(a ^ b);  //XNOR
        4'b1111: out = (b<<(bitwidth/2)); //MVHI
        default: out = {bitwidth{1'b0}};
      endcase //case(alu_func)
   end // always@(a,b,opcode) begin

   always @(out, cmp_func) begin
      case(cmp_func)
        4'b0000: flag = 1'b1;              //TRUE
        4'b0011: flag = 1'b0;              //FALSE
        4'b0101: flag = (out != {bitwidth{1'b0}}) ? 1'b1 : 1'b0;   // A!=B
        4'b0110: flag = (out == {bitwidth{1'b0}}) ? 1'b1 : 1'b0;   // A==B
        4'b1001:
          flag = ($signed(out) < $signed({bitwidth{1'b0}}))  ? 1'b1 : 1'b0;   // A<B
        4'b1010:
          flag = ($signed(out) >= $signed({bitwidth{1'b0}})) ? 1'b1 : 1'b0;   // A>=B
        4'b1100:
          flag = ($signed(out) <= $signed({bitwidth{1'b0}})) ? 1'b1 : 1'b0;   // A<=B
        4'b1111:
          flag = ($signed(out) > $signed({bitwidth{1'b0}}))  ? 1'b1 : 1'b0;   // A>B
        default: flag = 1'b0;
      endcase //case(opcode)
   end // always @ (out)
endmodule
