//                              -*- Mode: Verilog -*-
// Filename        : Project2.v
// Description     : A single-cycle processor
// Author          : Lucas Christian and Joon Choi
//
module Project2(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50,FPGA_RESET_N);
   input  [9:0] SW;
   input  [3:0] KEY;
   input  CLOCK_50;
   input  FPGA_RESET_N;
   output [9:0] LEDR;
   output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;

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
	wire MEM_Mux_sel;
	wire[3:0] EX_op, EX_func;
	
	
	//Pipeline Registers
	//IF opcode and function for branch purposes
	wire [3:0] IF_op, IF_func;
	assign IF_op = instWord[DBITS-1:DBITS-4];
	assign IF_func = instWord[DBITS-5:DBITS-8];
	
	//IF
	wire IF_wrt_en;
	assign IF_wrt_en = 1;
	wire[DBITS*3 - 1 + 1: 0] IF_in, IF_out;
	//IF PC + imm
	assign IF_in[DBITS*3 -1  + 1: DBITS * 2 + 1] = brBaseOffset;
	//IF PC
	assign IF_in[DBITS*2 - 1 + 1:DBITS + 1] = pcIncremented;
	//IF instWord
	assign IF_in[DBITS -1 + 1:1] = instWord;
	//prediction
	assign IF_in[0] = prediction;
	
	Register #(DBITS * 3 + 1, 0) IFreg(clk, resetReg, IF_wrt_en, IF_in, IF_out);
	
	//IF our br base offset
	wire[DBITS - 1:0] IF_brBaseOffset;
	assign IF_brBaseOffset = IF_out[DBITS*3 + 1 - 1:DBITS * 2 + 1];
	//IF out pc
	wire [DBITS - 1:0] IF_pcout;
	assign IF_pcout = IF_out[DBITS*2 + 1 - 1:DBITS + 1];
	//IF out instWord
	wire[DBITS - 1:0] IF_instWord;
	assign IF_instWord = IF_out[DBITS - 1 + 1:1];
	assign DEC_op = IF_instWord[DBITS-1:DBITS-4];
	assign DEC_func = IF_instWord[DBITS-5:DBITS-8];
	//IF prediction
	wire IF_prediction;
	assign IF_prediction = IF_out[0];
	
	//DECODE
	//TODO: add opcode and func values to pass to rest of stages for use with controller
	wire DEC_wrt_en;
	assign DEC_wrt_en = 1;
	wire[DBITS*5 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2 : 0] DEC_in, DEC_out;
	//DEC brBaseOffset
	assign DEC_in[DBITS*5 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2 : DBITS *4 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 1 + 2] = IF_brBaseOffset;
	//DEC PC
	assign DEC_in[DBITS*4 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2 : DBITS *3 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 1 + 2] = IF_pcout;
	//DEC signex
	assign DEC_in[DBITS * 3 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2 : DBITS * 2 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 1 + 2] = immval;
	//DEC regData1
	assign DEC_in[DBITS * 2 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2 : DBITS + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 1 + 2] = regData1;
	//DEC regData2
	assign DEC_in[DBITS + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 +1 + 1 + 2 : REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 +1 + 1 + 1 + 2] = regData2;
	//DEC src_reg1
	assign DEC_in[REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2 : REG_INDEX_BIT_WIDTH * 2 + (4*2) + 1 + 1 + 1 + 1 + 2] = rs1;
	//DEC src_reg2
	assign DEC_in[REG_INDEX_BIT_WIDTH * 2 + (4*2) + 1 + 1 + 1 + 2 : REG_INDEX_BIT_WIDTH * 1 + (4*2) + 1 + 1 + 1 + 1 + 2] = rs2;
	//DEC dst_reg
	assign DEC_in[REG_INDEX_BIT_WIDTH + (4*2) + 1 + 1 + 1 + 2 : (4*2) + 1 + 1 + 1 + 1 + 2] = rd;
	//EX OP
	assign DEC_in[(4*2) + 1 + 1 + 1 + 2 : 4 + 1 + 1 + 1 + 1 + 2] = opcode;
	//EX FUNC
	assign DEC_in[4 + 1 + 1 + 1 + 2 : 1 + 1 + 1 + 1 + 2] = func;
	//DEC prediction
	assign DEC_in[1 + 1 + 1 + 2] = IF_prediction;
	//DEC wrReg
	assign DEC_in[1+1+2] = wrReg;
	//DEC wrMem
	assign DEC_in[1+2] = wrMem;
	//DEC ME_mux_sel
	assign DEC_in[2] = MEM_Mux_sel;
	//DEC alu2srcsel
	assign DEC_in[1:0] = alu2MuxSel;
	
	Register #((DBITS*5 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 1 + 2), 0) DECreg(clk, resetReg, DEC_wrt_en, DEC_in, DEC_out);
	
	//DEC out brBaseOffset
	wire[DBITS-1:0] DEC_brBaseOffset;
	assign DEC_brBaseOffset = DEC_out[DBITS*5 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 2 : DBITS*4 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2];
	//DEC out PC
	wire[DBITS - 1:0] DEC_pc;
	assign DEC_pc = DEC_out[DBITS*4 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 2 : DBITS*3 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2];
	//DEC out signex
	wire [DBITS - 1:0] DEC_immval;
	assign DEC_immval = DEC_out[DBITS*3 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 2 : DBITS*2 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2];
	//DEC regdata1
	wire [DBITS - 1:0] DEC_regData1;
	assign DEC_regData1 = DEC_out[DBITS*2 + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 2 : DBITS + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2];
	//DEC regdata2
	wire [DBITS - 1:0] DEC_regData2;
	assign DEC_regData2 = DEC_out[DBITS + REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 2 : REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 1 + 2];
	//DEC src_reg1
	wire [REG_INDEX_BIT_WIDTH - 1:0] DEC_rs1;
	assign DEC_rs1 = DEC_out[REG_INDEX_BIT_WIDTH * 3 + (4*2) + 1 + 1 + 2 : REG_INDEX_BIT_WIDTH * 2 + (4*2) + 1 + 1 + 1 + 2];
	//DEC src_reg2
	wire [REG_INDEX_BIT_WIDTH - 1:0] DEC_rs2;
	assign DEC_rs2 = DEC_out[REG_INDEX_BIT_WIDTH * 2 + (4*2) + 1 + 1 + 2 : REG_INDEX_BIT_WIDTH * 1 + (4*2) + 1 + 1 + 1 + 2];
	//DEC dst_reg
	wire [REG_INDEX_BIT_WIDTH - 1:0] DEC_rd;
	assign DEC_rd = DEC_out[REG_INDEX_BIT_WIDTH + (4*2) + 1 + 1 + 2 : (4*2) + 1 + 1 + 1 + 2];
	//EX Op
	wire[3:0] DEC_op;
	assign EX_op = DEC_out[(4*2) + 1 + 1 + 2 : (4) + 1 + 1 + 1 + 2];
	//EX func
	wire[3:0] DEC_func;
	assign EX_func = DEC_out[(4) + 1 + 1 + 2 : 1 + 1 + 1 + 2];
	//DEC prediction
	wire DEC_prediction;
	assign DEC_prediction = DEC_out[1 + 1 + 1 + 2];
	//DEC wrReg
	wire DEC_wrReg;
	assign DEC_wrReg = DEC_out[1+1+2];
	//DEC wrMem
	wire DEC_wrMem;
	assign DEC_wrMem = DEC_out[1+2];
	//DEC MEM_Mux_sel
	wire DEC_ME_mux_sel;
	assign DEC_ME_mux_sel = DEC_out[2];
	//DEC alu2srcsel
	wire[1:0] DEC_alu2MuxSel;
	assign DEC_alu2MuxSel = DEC_out[1:0];
	
	//EXECUTE
	wire EX_wrt_en;
	assign EX_wrt_en = 1;
	wire[8 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1 : 0] EX_in, EX_out;
	assign EX_in[4 * 2 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1 : 5 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1] = EX_func;
	assign EX_in[ 4 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1 : 1 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1] = EX_op;
	assign EX_in[DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1: DBITS + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1] = regData2; 
	assign EX_in[DBITS + REG_INDEX_BIT_WIDTH * 2 + 1 + 1: REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1] = EX_intermediateResult;
	assign EX_in[REG_INDEX_BIT_WIDTH * 2 + 1 + 1:REG_INDEX_BIT_WIDTH * 1 + 1 + 1 + 1] = DEC_rs2;
	assign EX_in[REG_INDEX_BIT_WIDTH * 1 + 1 + 1: 1 + 1 + 1] = DEC_rd; 
	assign EX_in[1 + 1] = DEC_ME_mux_sel;
	assign EX_in[1] = DEC_wrReg;
	assign EX_in[0] = DEC_wrMem;
	Register #((4 * 2 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1 + 1 + 1), 0) EXreg(clk, reset, EX_wrt_en, EX_in, EX_out);
	
	//ME_op
	wire[3:0] ME_op;
	assign ME_op = EX_out[4 * 2 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1 : 5 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1];
	//ME_func
	wire[3:0] ME_func;
	assign ME_func = EX_out[4 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1 : 1 + DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1];

	//EX_regdata2
	wire[DBITS-1:0] EX_regData2;
	assign EX_regData2 = EX_out[DBITS * 2 + REG_INDEX_BIT_WIDTH * 2 + 1 + 1: DBITS + REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1];
	//EX_aluResult
	wire [DBITS-1:0] EX_aluResult;
	assign EX_aluResult = EX_out[DBITS + REG_INDEX_BIT_WIDTH * 2 + 1 + 1: REG_INDEX_BIT_WIDTH * 2 + 1 + 1 + 1];
	
	//EX_rs2
	wire [REG_INDEX_BIT_WIDTH-1:0] EX_rs2;
	assign EX_rs2 = EX_out[REG_INDEX_BIT_WIDTH * 2 + 1 + 1:REG_INDEX_BIT_WIDTH * 1 + 1 + 1 + 1];

	//EX_rd
	wire [REG_INDEX_BIT_WIDTH-1:0] EX_rd;
	assign EX_rd = EX_out[REG_INDEX_BIT_WIDTH * 1 + 1 + 1: 1 + 1 + 1];
	
	//EX_ME_mux_sel
	wire EX_ME_mux_sel;
	assign EX_ME_mux_sel = EX_out[1 + 1];
	
	//EX_wrReg
	wire EX_wrReg;
	assign EX_wrReg = EX_out[1];
	
	//EX_wrMem
	wire EX_wrMem;
	assign EX_wrMem = EX_out[0]; 
	
	//MEMORY register
	wire ME_wrt_en;
	assign ME_wrt_en = 1;
	wire[4 * 2 + DBITS + REG_INDEX_BIT_WIDTH:0] ME_in, ME_out;
	assign ME_in[4 * 2 + DBITS + REG_INDEX_BIT_WIDTH:5 + DBITS + REG_INDEX_BIT_WIDTH] = ME_op;
	assign ME_in[4 + DBITS + REG_INDEX_BIT_WIDTH:1 + DBITS + REG_INDEX_BIT_WIDTH] = ME_func;
	assign ME_in[DBITS + REG_INDEX_BIT_WIDTH: REG_INDEX_BIT_WIDTH + 1] = MEM_result;
	assign ME_in[REG_INDEX_BIT_WIDTH: 1] = EX_rd;
	assign ME_in[0] = EX_wrReg; 
	Register #((DBITS + REG_INDEX_BIT_WIDTH + 2 + (4 * 2)), 0) MEreg(clk, reset, ME_wrt_en, ME_in, ME_out);
	
	//ME_op
	wire [3:0] WB_op;
	assign WB_op = ME_out[4 * 2 + DBITS + REG_INDEX_BIT_WIDTH:5 + DBITS + REG_INDEX_BIT_WIDTH];
	//ME_func
	wire[3:0] WB_func;
	assign WB_func = ME_out[4 + DBITS + REG_INDEX_BIT_WIDTH:1 + DBITS + REG_INDEX_BIT_WIDTH];
	//ME_MEM_result
	wire [DBITS-1:0] ME_MEM_result;
	assign ME_MEM_result = ME_out[DBITS + REG_INDEX_BIT_WIDTH: REG_INDEX_BIT_WIDTH + 1];
	
	//ME_EX_rd
	wire [REG_INDEX_BIT_WIDTH-1:0] ME_rd; 
	assign ME_rd = ME_out[REG_INDEX_BIT_WIDTH: 1];
	
	//ME_EX_wrReg
	wire ME_wrReg;
	assign ME_wrReg = ME_out[0]; 
	
	
   // Clock divider and reset
   assign reset = ~FPGA_RESET_N;
   // We run at around 25 MHz. Timing analyzer estimates the design can support
   // around 33 MHz if we really wanted to
   ClockDivider	#(32, 1'b0) clk_divider(CLOCK_50, 1'b0, clk);
   
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
   SevenSeg hex4Disp(pcOut[3:0], HEX4);
   SevenSeg hex5Disp(pcOut[7:4], HEX5);

   // Create PC and its logic
   Register #(DBITS, START_PC) pc(clk, reset, 1'b1, pcIn, pcOut);

   // Increment the PC by 4 for use in several places
   Adder #(DBITS) pcIncrementer(pcOut, 32'd4, pcIncremented);

   // BR/JAL base + offset calculation
	//TODO: change this to work with pipeline. Specifically JAL needs work
   Multiplexer2bit #(DBITS) brBaseMux(pcIncremented, regData1, brBaseMuxSel, brBase);
   Adder #(DBITS) brOffsetAdder(brBase, instOffset, brBaseOffset);

   // Take branch if allowed AND condition flag is true
	// DEAL WITH BRANCH PREDICTION STUFF HERE
	// replace condflag with prediction, probably
	wire prediction;
	GShare branchPredictor(pcOut, (DEC_pc - 4), clk, allowBr, update, condFlag, prediction);
   assign takeBr = prediction & allowBr;
	wire [DBITS-1:0] pcIntermediate;
   Multiplexer2bit #(DBITS) nextPcMux1(pcIncremented, brBaseOffset, takeBr, pcIntermediate);
	Multiplexer2bit #(DBITS) nextPcMux2(newBrPC, pcIntermediate, correct, pcIn);

	
	//branch handler
	//use correct in mux, use update for branch predictor
	wire correct, update, resetReg;
	wire[DBITS-1:0] newBrPC;
	branchHandler branchHandle1(DEC_brBaseOffset, DEC_pc, EX_op, condFlag, DEC_prediction, correct, resetReg, update, clk, newBrPC);

   // Create instruction memory
   InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH)
       instMem(pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instWord);

   // Instruction decoder splits out all pertinent fields
   Decoder #(IMEM_DATA_BIT_WIDTH) decoder(IF_instWord, opcode, func, rd, rs1, rs2, immediate);

   // Sign extend the immediate value
   SignExtension #(16, DBITS) immSext(immediate, immval);

   // Instruction offset for use in BR/JAL calculations
   Shiftbit #(DBITS, 2) instOffsetShift(immval, instOffset);

   // Controller examines opcode, func, and ALU condition to generate control signals
   PipelineController controller(
                               // Inputs
                               .IF_op           (IF_op[3:0]),
                               .IF_func         (IF_func[3:0]),
                               .DEC_op          (DEC_op[3:0]),
                               .DEC_func        (DEC_func[3:0]),
                               .EX_op           (EX_op[3:0]),
                               .EX_func         (EX_func[3:0]),
                               .ME_op           (ME_op[3:0]),
                               .ME_func         (ME_func[3:0]),
                               .WB_op           (WB_op[3:0]),
                               .WB_func         (WB_func[3:0]),
										 // Outputs
                               .allowBr         (allowBr),
                               .brBaseMux       (brBaseMuxSel),
                               .rs1Mux          (rs1MuxSel),
                               .rs2Mux          (rs2MuxSel[1:0]),
                               .alu2Mux         (alu2MuxSel[1:0]),
                               .aluOp           (aluOp[3:0]),
                               .cmpOp           (cmpOp[3:0]),
                               .wrReg           (wrReg),
                               .wrMem           (wrMem),
                               .dstRegMux       (dstRegMuxSel[1:0]),
										 .MEM_Mux_sel     (MEM_Mux_sel)
										 );

   // Create the register file
   assign regWriteNo = WB_reg;
	assign wrRegData = WB_data;
   Multiplexer2bit #(4) rs1Mux(rs1, rd, rs1MuxSel, regRead1No);
   Multiplexer4bit #(4) rs2Mux(rs2, rd, rs1, 4'b0, rs2MuxSel, regRead2No);
   
   RegisterFile #(DBITS) regFile(clk, reset, ME_wrReg, regWriteNo, regRead1No,
                                 regRead2No, regData1, regData2, wrRegData);

	//DONE IN VERY HACKY WAY, CHECK HERE IF SOMETHING DOESN'T WORK
   // Assign destination register data
   assign condRegResult = {{DBITS - 1{1'b0}} ,{condFlag}};
	wire[DBITS -1 : 0] EX_intermediateResult;
   Multiplexer4bit #(DBITS) dstRegMux(aluResult, aluResult, DEC_pc,
                                      condRegResult, dstRegMuxSel, EX_intermediateResult);

   // Create ALU unit
   Alu #(DBITS) procAlu(a, b, aluOp, cmpOp, condFlag, aluResult);

   // Assign ALU inputs
   Multiplexer4bit #(DBITS) alu2Mux(forwarded_rs2, DEC_immval, 32'b0, 32'b0, DEC_alu2MuxSel, b);

   // Create Data Memory
   DataMemory #(IMEM_INIT_FILE)
      datamem(clk, EX_wrMem, EX_aluResult, EX_regData2, debounced_SW, KEY, LEDR, hex, dataMemOut);
   // KEYS, SWITCHES, HEXS, and LEDS are memory mapped IO

	//NEW PIPELINE MUX
	//TODO: logic for MEM_Mux_sel-- probably needs to be handled in controller
	wire[DBITS -1 :0] MEM_result;
	Multiplexer2bit #(DBITS) ME_Mux(EX_aluResult, dataMemOut, MEM_Mux_sel, MEM_result);
	
	//TODO: Writeback Logic
	//Need to funnel this information back to register file and to prior stages. Controller handled probably
	wire[DBITS - 1:0] WB_data;
	wire[REG_INDEX_BIT_WIDTH-1 : 0] WB_reg;
	assign WB_data = ME_MEM_result;
	assign WB_reg = ME_rd;
	
	//FORWARDING UNITS
	wire[DBITS-1:0] forwarded_rs2;
	forwardingUnit rs1Forward(DEC_rs1, DEC_regData1, ME_op, EX_rd, MEM_result, WB_op, WB_reg, WB_data, a);
	forwardingUnit rs2Forward(DEC_rs2, DEC_regData2, ME_op, EX_rd, MEM_result, WB_op, WB_reg, WB_data, forwarded_rs2);
endmodule
