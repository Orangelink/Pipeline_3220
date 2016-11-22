module Multiplexer4bit(a,b,c,d,selector,out);
   parameter bitwidth = 32;

   input[bitwidth-1:0] a;
   input[bitwidth-1:0] b;
   input[bitwidth-1:0] c;
   input[bitwidth-1:0] d;
   input[1:0] selector;

   output[bitwidth-1:0] out;
   reg[bitwidth-1:0] out;

   always @ (a,b,c,d,selector,out)
     begin
        case (selector)
          4'b00 : out = a;
          4'b01 : out = b;
          4'b10 : out = c;
          4'b11 : out = d;
          default: out = {bitwidth{1'b0}};
        endcase //case (selector)
     end //always @ (a,b,c,d,selector,out):
endmodule
