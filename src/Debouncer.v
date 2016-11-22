//                              -*- Mode: Verilog -*-
// Filename        : debounce.v
// Description     : a simple switch debouncer
//
// This code was patterned after
// https://www.eecs.umich.edu/courses/eecs270/270lab/270_docs/debounce.html
//
// with help from the class notes
//
module Debouncer(clk, in, out);
   input      clk;
   input      in;
   output     out;

   reg        out;
   reg        gate_0;
   reg        gate_1;

   always @(posedge clk) begin
      gate_0 <= in;
   end

   always @(posedge clk) begin
      gate_1 <= gate_0;
   end

   reg [15:0] cnt;

   always @(posedge clk) begin
     if(out == gate_1)
       cnt <= 0;
     else
       begin
          cnt <= cnt + 1'b1;
          if(cnt == 16'hffff) out <= ~out;
       end
   end
endmodule // Debouncer
