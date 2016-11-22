module Adder(a, b, out);
   parameter bitwidth = 32;
   input[bitwidth-1: 0] a,b;
   output[bitwidth-1:0] out;
   reg[bitwidth-1:0] out;

   always @(a,b) begin
      out = a+b;
   end
endmodule
