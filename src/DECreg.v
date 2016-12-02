module DECreg(wrt_en, reset, clk, IF_brBaseOffset, IF_pcout, immval, regData1, regData2,
					rs1, rs2, rd, opcode, func, IF_prediction, wrReg, wrMem, MEM_Mux_sel,
					alu2Muxsel, DEC_brBaseOffset, DEC_pc, DEC_immval, DEC_regData1, DEC_regData2,
					DEC_rs1, DEC_rs2, DEC_rd, EX_op, EX_func, DEC_prediction, DEC_wrReg, DEC_wrMem, DEC_ME_Mux_sel,
					DEC_alu2Muxsel);
	parameter DBITS = 32;
	parameter REG_INDEX_BIT_WIDTH = 4;
	
	input wrt_en, clk, reset;
	input IF_prediction, wrReg, wrMem, MEM_Mux_sel;
	input[DBITS-1:0] IF_brBaseOffset, IF_pcout, immval, regData1, regData2;
	input[REG_INDEX_BIT_WIDTH-1:0] rs1, rs2, rd, opcode, func;
	input[1:0] alu2Muxsel;
	
	output  DEC_prediction, DEC_wrReg, DEC_wrMem, DEC_ME_Mux_sel;
	output [DBITS-1:0] DEC_brBaseOffset, DEC_pc, DEC_immval, DEC_regData1, DEC_regData2;
	output [REG_INDEX_BIT_WIDTH-1:0] DEC_rs1, DEC_rs2, DEC_rd, EX_op, EX_func;
	output [1:0] DEC_alu2Muxsel;
	
	Register #(DBITS, 0) BrBaseReg(clk, reset, wrt_en, IF_brBaseOffset, DEC_brBaseOffset);
	Register #(DBITS, 0) pcoutReg(clk, reset, wrt_en, IF_pcout, DEC_pc);
	Register #(DBITS, 0) immvalReg(clk, reset, wrt_en, immval, DEC_immval);
	Register #(DBITS, 0) regData1Reg(clk, reset, wrt_en, regData1, DEC_regData1);
	Register #(DBITS, 0) regData2Reg(clk, reset, wrt_en, regData2, DEC_regData2);
	Register #(REG_INDEX_BIT_WIDTH, 0) rs1Reg(clk, reset, wrt_en, rs1, DEC_rs1);
	Register #(REG_INDEX_BIT_WIDTH, 0) rs2Reg(clk, reset, wrt_en, rs2, DEC_rs2);
	Register #(REG_INDEX_BIT_WIDTH, 0) rdReg(clk, reset, wrt_en, rd, DEC_rd);
	Register #(REG_INDEX_BIT_WIDTH, 0) opReg(clk, reset, wrt_en, opcode, EX_op);
	Register #(REG_INDEX_BIT_WIDTH, 0) funcReg(clk, reset, wrt_en, func, EX_func);
	Register #(2, 0) alu2Reg(clk, reset, wrt_en, alu2Muxsel, DEC_alu2Muxsel);
	Register #(1, 0) wrRegReg(clk, reset, wrt_en, wrReg, DEC_wrReg);
	Register #(1, 0) wrMemReg(clk, reset, wrt_en, wrMem, DEC_wrMem);
	Register #(1, 0) DEC_Mem_selReg(clk, reset, wrt_en, MEM_Mux_sel, DEC_ME_Mux_sel);
	Register #(1, 0) predictionReg(clk, reset, wrt_en, IF_prediction, DEC_prediction);

endmodule
