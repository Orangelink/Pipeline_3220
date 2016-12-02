`timescale 1ns/1ps
`define ALUR 4'b1100
`define ADD 4'b0111
`define TWO  32'b00000000000000000000000000000010
`define FIVE  32'b00000000000000000000000000000101
`define ONE 4'b0001
`define THREE 4'b0011

module TestEXreg();

	parameter DBITS = 32; 
	parameter REG_INDEX_BIT_WIDTH = 4; 
	
	reg wrt_en, reset, clk; 
	reg [3:0] func, op;
	reg [DBITS-1:0] regData2, intermediateResult; 
	reg [REG_INDEX_BIT_WIDTH-1:0] rs2, rd; 
	reg ME_mux_sel, wrReg, wrMem;
	
	wire [3:0] EX_func, EX_op;
	wire [DBITS-1:0] EX_regData2, EX_intermediateResult;
	wire [REG_INDEX_BIT_WIDTH-1:0] EX_rs2, EX_rd;
	wire  EX_ME_mux_sel, EX_wrReg, EX_wrMem;
	
	
	EXreg myEXreg(wrt_en, reset, clk, func, op, regData2, intermediateResult, rs2, rd, ME_mux_sel, wrReg, wrMem,
				 EX_func, EX_op, EX_regData2, EX_intermediateResult, EX_rs2, EX_rd, EX_ME_mux_sel, EX_wrReg, EX_wrMem); 
				 
	initial begin
		clk = 1'b0;
		reset = 1'b0; 
		wrt_en = 1'b1;
		func = `ADD;
		op = `ALUR; 
		regData2 = `TWO;
		intermediateResult = `FIVE;
		rs2 = `ONE;
		rd =  `THREE; 
		ME_mux_sel = 1'b1;
		wrReg = 1'b1; 
		wrMem = 1'b1; 
		#10
		clk = 1'b1;
		#10
		clk = 1'b0;
		reset = 1'b1; 
		#10
		clk = 1'b1;
		
		#10 $finish; 
	end
	
endmodule
