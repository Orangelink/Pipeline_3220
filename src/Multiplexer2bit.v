module Multiplexer2bit(a,b,selector,out);
   parameter bitwidth = 32;

   input[bitwidth-1:0] a;
   input[bitwidth-1:0] b;
   input selector;

   output[bitwidth-1:0] out;
   reg[bitwidth-1:0] out;


   always @ (a,b,selector,out)
     begin
        case (selector)
          1'b0 : out = a;
          1'b1 : out = b;
          default: out = {bitwidth{1'b0}};
        endcase //case (selector)
     end //always @ (a,b,selector,out):
endmodule
