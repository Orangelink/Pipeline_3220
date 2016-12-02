`timescale 1ns/1ps
`define ALUR 4'b1100
`define ADD 4'b0111
`define TWO  32'b00000000000000000000000000000010
`define FIVE  32'b00000000000000000000000000000101
`define ONE 4'b0001
`define THREE 4'b0011

module TestMEreg();

	parameter DBITS = 32; 
	parameter REG_INDEX_BIT_WIDTH = 4; 
	
	reg wrt_en, reset, clk; 
	reg [3:0] op, func;
	reg [DBITS-1:0] result; 
	reg [REG_INDEX_BIT_WIDTH-1:0] rd; 
	reg wrReg;
	
	wire [3:0] ME_func, ME_op;
	wire [DBITS-1:0] ME_result;
	wire [REG_INDEX_BIT_WIDTH-1:0] ME_rd;
	wire ME_wrReg;
	
	MEreg myMEreg(wrt_en, reset, clk, op, func, result, rd, wrReg,
				 ME_func, ME_op, ME_result, ME_rd, ME_wrReg); 
					 
	initial begin
		clk = 1'b0;
		reset = 1'b0; 
		wrt_en = 1'b1;
		func = `ADD;
		op = `ALUR; 
		result = `TWO;
		rd =  `THREE; 
		wrReg = 1'b1; 
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
