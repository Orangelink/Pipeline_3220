module Shiftbit(din,dout);
   parameter bitwidth = 32;
   parameter shift_by = 2;
   
   input[bitwidth-1:0] din;
   output[bitwidth-1:0] dout;
   reg[bitwidth-1:0] dout;
   
   always @(din) begin
      dout = din<<shift_by;
   end
endmodule
