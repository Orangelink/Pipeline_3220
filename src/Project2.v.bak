//                              -*- Mode: Verilog -*-
// Filename        : Project2.v
// Description     : A single-cycle processor
// Author          : Lucas Christian and Joon Choi
//
module Project2(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,CLOCK_50,FPGA_RESET_N);
   input  [9:0] SW;
   input  [3:0] KEY;
   input  CLOCK_50;
   input  FPGA_RESET_N;
   output [9:0] LEDR;
   output [6:0] HEX0,HEX1,HEX2,HEX3;

   parameter DBITS         				 = 32;
   parameter INST_SIZE      			 = 32'd4;
   parameter INST_BIT_WIDTH				 = 32;
   parameter START_PC       			 = 32'h40;
   parameter REG_INDEX_BIT_WIDTH 		 = 4;
   parameter ADDR_KEY  					 = 32'hF0000010;
   parameter ADDR_SW   					 = 32'hF0000014;
   parameter ADDR_HEX  					 = 32'hF0000000;
   parameter ADDR_LEDR 					 = 32'hF0000004;

   parameter IMEM_INIT_FILE				 = "test/programs/Test2.mif";
   parameter IMEM_ADDR_BIT_WIDTH 		 = 11;
   parameter IMEM_DATA_BIT_WIDTH 		 = INST_BIT_WIDTH;
   parameter IMEM_PC_BITS_HI     		 = IMEM_ADDR_BIT_WIDTH + 2;
   parameter IMEM_PC_BITS_LO     		 = 2;

   parameter DMEMADDRBITS 				 = 13;
   parameter DMEMWORDBITS				 = 2;
   parameter DMEMWORDS					 = 2048;

   // Interconnecting wires
   wire clk;                    // Clock
   wire reset;                  // Reset
   wire [15:0] hex;             // Hex output register value

   wire [DBITS - 1:0] pcIn;     // New PC input to PC register
   wire [DBITS - 1:0] pcOut;    // Output of PC register
   wire [DBITS - 1:0] pcIncremented; // Incremented PC (PC + 4)

   wire [DBITS - 1:0] brBase;        // Branch base value (added with offset to form new PC)
   wire [DBITS - 1:0] brBaseOffset;  // Branch offset (added to base to form new PC)

   wire [IMEM_DATA_BIT_WIDTH - 1: 0] instWord; // Instruction word from memory
   wire [3:0] opcode;                          // Decoded opcode
   wire [3:0] func;                            // Decoded function
   wire [3:0] rd;                              // Decoded dest reg. no.
   wire [3:0] rs1;                             // Decoded source reg. 1 no.
   wire [3:0] rs2;                             // Decoded source reg. 2 no.
   wire [15:0] immediate;                      // Decoded immediate bits
   wire [DBITS - 1:0] immval;                  // Sign-extended immediate value
   wire [DBITS - 1:0] instOffset;              // Immediate value shifted to word address
   wire rs1MuxSel;                             // rs1Mux select signal
   wire [1:0] rs2MuxSel;                       // rs2Mux select signal
   wire [1:0] alu2MuxSel;                      // alu2Mux select signal
   wire [3:0] aluOp;                           // ALU arithmetic function opcode
   wire [3:0] cmpOp;                           // ALU comparison function opcode
   wire brBaseMuxSel;                          // brBaseMux select signal
   wire [1:0] dstRegMuxSel;                    // dstRegMux select signal
   wire allowBr;                               // whether to allow branch
   wire takeBr;                                // whether to take the branch
   wire wrMem;                                 // write enable for data memory
   wire wrReg;                                 // write enable for register file
   wire [3:0] regWriteNo;                      // destination reg. number
   wire [3:0] regRead1No;                      // source reg. 1 number
   wire [3:0] regRead2No;                      // source reg. 2 number
   wire [DBITS - 1:0] regData1;                // source reg. 1 data
   wire [DBITS - 1:0] regData2;                // source reg. 2 data
   wire [DBITS - 1:0] wrRegData;               // data to write to destination register
   wire [DBITS - 1:0] a;                       // ALU operand A
   wire [DBITS - 1:0] b;                       // ALU operand B
   wire [DBITS - 1:0] aluResult;               // ALU arithmetic output
   wire condFlag;                              // ALU condition flag output
   wire [DBITS - 1:0] condRegResult;           // ALU condition flag result zero-extended
   wire [DBITS - 1:0] dataMemOut;              // Data memory output
   wire [9:0] debounced_SW;                    // debounced switches


   // Clock divider and reset
   assign reset = ~FPGA_RESET_N;
   // We run at around 25 MHz. Timing analyzer estimates the design can support
   // around 33 MHz if we really wanted to
   ClockDivider	#(1, 1'b0) clk_divider(CLOCK_50, 1'b0, clk);
   
   //debounce SW
   Debouncer SW0(clk, SW[0], debounced_SW[0]);
   Debouncer SW1(clk, SW[1], debounced_SW[1]);
   Debouncer SW2(clk, SW[2], debounced_SW[2]);
   Debouncer SW3(clk, SW[3], debounced_SW[3]);
   Debouncer SW4(clk, SW[4], debounced_SW[4]);
   Debouncer SW5(clk, SW[5], debounced_SW[5]);
   Debouncer SW6(clk, SW[6], debounced_SW[6]);
   Debouncer SW7(clk, SW[7], debounced_SW[7]);
   Debouncer SW8(clk, SW[8], debounced_SW[8]);
   Debouncer SW9(clk, SW[9], debounced_SW[9]);   

   // Render HEX digits
   SevenSeg hex0Disp(hex[3:0], HEX0);
   SevenSeg hex1Disp(hex[7:4], HEX1);
   SevenSeg hex2Disp(hex[11:8], HEX2);
   SevenSeg hex3Disp(hex[15:12], HEX3);

   // Create PC and its logic
   Register #(DBITS, START_PC) pc(clk, reset, 1'b1, pcIn, pcOut);

   // Increment the PC by 4 for use in several places
   Adder #(DBITS) pcIncrementer(pcOut, 32'd4, pcIncremented);

   // BR/JAL base + offset calculation
   Multiplexer2bit #(DBITS) brBaseMux(pcIncremented, regData1, brBaseMuxSel, brBase);
   Adder #(DBITS) brOffsetAdder(brBase, instOffset, brBaseOffset);

   // Take branch if allowed AND condition flag is true
   assign takeBr = allowBr & condFlag;
   Multiplexer2bit #(DBITS) nextPcMux(pcIncremented, brBaseOffset, takeBr, pcIn);

   // Create instruction memory
   InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH)
       instMem(pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instWord);

   // Instruction decoder splits out all pertinent fields
   Decoder #(IMEM_DATA_BIT_WIDTH) decoder(instWord, opcode, func, rd, rs1, rs2, immediate);

   // Sign extend the immediate value
   SignExtension #(16, DBITS) immSext(immediate, immval);

   // Instruction offset for use in BR/JAL calculations
   Shiftbit #(DBITS, 2) instOffsetShift(immval, instOffset);

   // Controller examines opcode, func, and ALU condition to generate control signals
   SCProcController controller(// Outputs
                               .allowBr         (allowBr),
                               .brBaseMux       (brBaseMuxSel),
                               .rs1Mux          (rs1MuxSel),
                               .rs2Mux          (rs2MuxSel),
                               .alu2Mux         (alu2MuxSel[1:0]),
                               .aluOp           (aluOp[3:0]),
                               .cmpOp           (cmpOp[3:0]),
                               .wrReg           (wrReg),
                               .wrMem           (wrMem),
                               .dstRegMux       (dstRegMuxSel[1:0]),
                               // Inputs
                               .opcode          (opcode[3:0]),
                               .func            (func[3:0]));

   // Create the register file
   assign regWriteNo = rd;
   Multiplexer2bit #(4) rs1Mux(rs1, rd, rs1MuxSel, regRead1No);
   Multiplexer4bit #(4) rs2Mux(rs2, rd, rs1, 4'b0, rs2MuxSel, regRead2No);
   
   RegisterFile #(DBITS) regFile(clk, reset, wrReg, regWriteNo, regRead1No,
                                 regRead2No, regData1, regData2, wrRegData);

   // Assign destination register data
   assign condRegResult = {{DBITS - 1{1'b0}} ,{condFlag}};
   Multiplexer4bit #(DBITS) dstRegMux(aluResult, dataMemOut, pcIncremented,
                                      condRegResult, dstRegMuxSel, wrRegData);

   // Create ALU unit
   Alu #(DBITS) procAlu(a, b, aluOp, cmpOp, condFlag, aluResult);

   // Assign ALU inputs
   assign a = regData1;
   Multiplexer4bit #(DBITS) alu2Mux(regData2, immval, 32'b0, 32'b0, alu2MuxSel, b);

   // Create Data Memory
   DataMemory #(IMEM_INIT_FILE)
      datamem(clk, wrMem, aluResult, regData2, debounced_SW, KEY, LEDR, hex, dataMemOut);
   // KEYS, SWITCHES, HEXS, and LEDS are memory mapped IO

endmodule
