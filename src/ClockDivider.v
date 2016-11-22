//                              -*- Mode: Verilog -*-
// Filename        : ClockDivider.v
// Description     : a simple clock divider
//
// cycle_time specifies time the clock remains
// in one state (i.e. half the period of the clock waveform).
//
// cycle_width specifies the number of bits in the cycle_time parameter.
//
module ClockDivider(clk_in, reset, clk_out);
   parameter cycle_width;
   parameter cycle_time;

   input clk_in;
   input reset;

   output clk_out;
   reg    clk_out;

   reg [cycle_width - 1 : 0] counter;

   always @(posedge clk_in or posedge reset) begin
      if (reset)
        begin
           counter <= cycle_time;
           clk_out <= 1'b0;
        end
      else if (counter == {cycle_width{1'b0}})
        begin
           counter <= cycle_time - {{cycle_width - 1{1'b0}}, {1{1'b1}}};
           clk_out <= ~clk_out;
        end
      else
        counter <= counter - {{cycle_width - 1{1'b0}}, {1{1'b1}}};
   end // always @ (posedge clk_in or posedge reset)
endmodule // ClockDivider
