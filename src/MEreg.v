module MEreg(wrt_en, reset, clk, op, func, result, rd, wrReg,
				 ME_func, ME_op, ME_result, ME_rd, ME_wrReg); 

	parameter DBITS = 32; 
	parameter REG_INDEX_BIT_WIDTH = 4; 

	input wrt_en, reset, clk; 
	input [3:0] op, func;
	input [DBITS-1:0] result; 
	input [REG_INDEX_BIT_WIDTH-1:0] rd; 
	input wrReg;
	
	output [3:0] ME_func, ME_op;
	output [DBITS-1:0] ME_result;
	output [REG_INDEX_BIT_WIDTH-1:0] ME_rd;
	output ME_wrReg;
	
	Register #(4, 0) opReg(clk, reset, wrt_en, op, ME_op);
	Register #(4, 0) funcReg(clk, reset, wrt_en, func, ME_func);
	Register #(DBITS,0) resultReg(clk, reset, wrt_en, result, ME_result); 
	Register #(REG_INDEX_BIT_WIDTH,0) rdReg(clk, reset, wrt_en, rd, ME_rd);
	Register #(1,0) wrRegReg(clk, reset, wrt_en, wrReg, ME_wrReg);

endmodule
