//                              -*- Mode: Verilog -*-
// Filename        : SCProcController.v
// Description     : Single Cycle Processor Controller
// Author          : Lucas Christian
//
module SCProcController(opcode, func, allowBr, brBaseMux, rs1Mux, rs2Mux,
                        alu2Mux, aluOp, cmpOp, wrReg, wrMem, dstRegMux);
   input [3:0] opcode;
   input [3:0] func;

   output allowBr;
   output brBaseMux;
   output rs1Mux;
   output [1:0] rs2Mux;
   output [1:0] alu2Mux;
   output [3:0] aluOp;
   output [3:0] cmpOp;
   output wrReg;
   output wrMem;
   output [1:0] dstRegMux;

   wire [7:0] inputSignals;
   reg [18:0] outputSignals;

   // Group inputs into bit vector
   assign inputSignals = {{opcode}, {func}};

   // Assign outputs from split bit vector
   assign allowBr = outputSignals[18];
   assign brBaseMux = outputSignals[17];
   assign rs1Mux = outputSignals[16];
   assign rs2Mux = outputSignals[15:14];
   assign alu2Mux = outputSignals[13:12];
   assign aluOp = outputSignals[11:8];
   assign cmpOp = outputSignals[7:4];
   assign wrReg = outputSignals[3];
   assign wrMem = outputSignals[2];
   assign dstRegMux = outputSignals[1:0];

   // Output signal generation map
   // These constants are generates from the included controller spreadsheet
   always @ (inputSignals) begin
      case (inputSignals)
        8'b11000111: outputSignals = 19'b0_0_0_00_00_0111_0000_1_0_00;
        8'b11000110: outputSignals = 19'b0_0_0_00_00_0110_0000_1_0_00;
        8'b11000000: outputSignals = 19'b0_0_0_00_00_0000_0000_1_0_00;
        8'b11000001: outputSignals = 19'b0_0_0_00_00_0001_0000_1_0_00;
        8'b11000010: outputSignals = 19'b0_0_0_00_00_0010_0000_1_0_00;
        8'b11001000: outputSignals = 19'b0_0_0_00_00_1000_0000_1_0_00;
        8'b11001001: outputSignals = 19'b0_0_0_00_00_1001_0000_1_0_00;
        8'b11001010: outputSignals = 19'b0_0_0_00_00_1010_0000_1_0_00;
        8'b01000111: outputSignals = 19'b0_0_0_00_01_0111_0000_1_0_00;
        8'b01000110: outputSignals = 19'b0_0_0_00_01_0110_0000_1_0_00;
        8'b01000000: outputSignals = 19'b0_0_0_00_01_0000_0000_1_0_00;
        8'b01000001: outputSignals = 19'b0_0_0_00_01_0001_0000_1_0_00;
        8'b01000010: outputSignals = 19'b0_0_0_00_01_0010_0000_1_0_00;
        8'b01001000: outputSignals = 19'b0_0_0_00_01_1000_0000_1_0_00;
        8'b01001001: outputSignals = 19'b0_0_0_00_01_1001_0000_1_0_00;
        8'b01001010: outputSignals = 19'b0_0_0_00_01_1010_0000_1_0_00;
        8'b01001111: outputSignals = 19'b0_0_0_00_01_1111_0000_1_0_00;
        8'b11010000: outputSignals = 19'b0_0_0_00_00_0110_0000_1_0_11;
        8'b11010011: outputSignals = 19'b0_0_0_00_00_0110_0011_1_0_11;
        8'b11010101: outputSignals = 19'b0_0_0_00_00_0110_0101_1_0_11;
        8'b11010110: outputSignals = 19'b0_0_0_00_00_0110_0110_1_0_11;
        8'b11011001: outputSignals = 19'b0_0_0_00_00_0110_1001_1_0_11;
        8'b11011010: outputSignals = 19'b0_0_0_00_00_0110_1010_1_0_11;
        8'b11011100: outputSignals = 19'b0_0_0_00_00_0110_1100_1_0_11;
        8'b11011111: outputSignals = 19'b0_0_0_00_00_0110_1111_1_0_11;
        8'b01010000: outputSignals = 19'b0_0_0_00_01_0110_0000_1_0_11;
        8'b01010011: outputSignals = 19'b0_0_0_00_01_0110_0011_1_0_11;
        8'b01010101: outputSignals = 19'b0_0_0_00_01_0110_0101_1_0_11;
        8'b01010110: outputSignals = 19'b0_0_0_00_01_0110_0110_1_0_11;
        8'b01011001: outputSignals = 19'b0_0_0_00_01_0110_1001_1_0_11;
        8'b01011010: outputSignals = 19'b0_0_0_00_01_0110_1010_1_0_11;
        8'b01011100: outputSignals = 19'b0_0_0_00_01_0110_1100_1_0_11;
        8'b01011111: outputSignals = 19'b0_0_0_00_01_0110_1111_1_0_11;
        8'b01110000: outputSignals = 19'b0_0_0_00_01_0111_0000_1_0_01;
        8'b00110000: outputSignals = 19'b0_0_0_01_01_0111_0000_0_1_00;
        8'b00100000: outputSignals = 19'b1_0_1_10_00_0110_0000_0_0_00;
        8'b00100001: outputSignals = 19'b1_0_1_10_10_0110_0101_0_0_00;
        8'b00100010: outputSignals = 19'b1_0_1_10_10_0110_0110_0_0_00;
        8'b00100011: outputSignals = 19'b1_0_1_10_00_0110_0011_0_0_00;
        8'b00100101: outputSignals = 19'b1_0_1_10_00_0110_0101_0_0_00;
        8'b00100110: outputSignals = 19'b1_0_1_10_00_0110_0110_0_0_00;
        8'b00101000: outputSignals = 19'b1_0_1_10_10_0110_1100_0_0_00;
        8'b00101001: outputSignals = 19'b1_0_1_10_00_0110_1001_0_0_00;
        8'b00101010: outputSignals = 19'b1_0_1_10_00_0110_1010_0_0_00;
        8'b00101011: outputSignals = 19'b1_0_1_10_00_0110_1111_0_0_00;
        8'b00101100: outputSignals = 19'b1_0_1_10_11_0110_1100_0_0_00;
        8'b00101101: outputSignals = 19'b1_0_1_10_10_0110_1001_0_0_00;
        8'b00101110: outputSignals = 19'b1_0_1_10_10_0110_1010_0_0_00;
        8'b00101111: outputSignals = 19'b1_0_1_10_10_0110_1111_0_0_00;
        8'b01100000: outputSignals = 19'b1_1_0_00_00_0000_0000_1_0_10;
        default: outputSignals = 19'b0_0_00_00_0000_0000_0_0_00;
      endcase // case (inputSignals)
   end
endmodule // SCProcController
