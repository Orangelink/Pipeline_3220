module EXreg(wrt_en, reset, clk, func, op, regData2, intermediateResult, rs2, rd, ME_mux_sel, wrReg, wrMem,
				 EX_func, EX_op, EX_regData2, EX_intermediateResult, EX_rs2, EX_rd, EX_ME_mux_sel, EX_wrReg, EX_wrMem); 

	parameter DBITS = 32; 
	parameter REG_INDEX_BIT_WIDTH = 4; 
	
	input wrt_en, reset, clk; 
	input [3:0] func, op;
	input [DBITS-1:0] regData2, intermediateResult; 
	input [REG_INDEX_BIT_WIDTH-1:0] rs2, rd; 
	input ME_mux_sel, wrReg, wrMem;
	
	output reg[3:0] EX_func, EX_op;
	output reg[DBITS-1:0] EX_regData2, EX_intermediateResult;
	output reg[REG_INDEX_BIT_WIDTH-1:0] EX_rs2, EX_rd;
	output reg EX_ME_mux_sel, EX_wrReg, EX_wrMem;
	
	Register #(4,0) funcReg(clk, reset, wrt_en, func, EX_func); 
	Register #(4,0) opReg(clk, reset, wrt_en, op, EX_op);
	Register #(DBITS,0) regData2Reg(clk, reset, wrt_en, regData2, EX_regData2); 
	Register #(DBITS,0) intermediateResultReg(clk, reset, wrt_en, intermediateResult, EX_intermediateResult);
	Register #(REG_INDEX_BIT_WIDTH,0) rs2Reg(clk, reset, wrt_en, rs2, EX_rs2);
	Register #(REG_INDEX_BIT_WIDTH,0) rdReg(clk, reset, wrt_en, rd, EX_rd);
	Register #(1,0) Me_mux_selReg(clk, reset, wrt_en, ME_mux_sel, EX_ME_mux_sel);
	Register #(1,0) wrRegReg(clk, reset, wrt_en, wrReg, EX_wrReg);
	Register #(1,0) wrMemReg(clk, reset, wrt_en, wrMem, EX_wrMem); 
	
endmodule
