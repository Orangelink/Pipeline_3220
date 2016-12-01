`timescale 1ns/1ps
`define BRANCH 4'b0010
`define ALU-R 4'b1100
`define ALU-I 4'b0100

module testbranchHandler();
   parameter DBITS = 32;
	parameter REG_INDEX_BIT_WIDTH = 4;
	
	reg [(REG_INDEX_BIT_WIDTH - 1):0] PC, EX_PC;
	reg [3:0] EX_opcode;
	reg EX_condFlag;
	reg [(DBITS - 1) : 0] imm; 
	reg prediction;
	
	wire [1:0] correct; 
	wire reset; 
	wire [(REG_INDEX_BIT_WIDTH - 1):0] newPC; 
	
	branchHandler mybranchHandler(PC, EX_PC, EX_opcode, EX_condFlag, prediction, imm, correct, reset, newPC);
					 
	initial begin
		//Test Case 1: predict->taken, actual->taken
		PC = 4'b1000; //PC at 12 
		EX_PC = 4'b0100; //EX_PC at 4
		EX_opcode = `BRANCH; 
		EX_condFlag = 1'b1; //branch evaluates true
		imm = 32'b000000000000000000000000001000;
		prediction = 1'b1; 
		//Expected Results:
		//correct = 2'b10
		//reset = 1'b0
		//newPC = 4'b1100
		#10
		//Test Case 2: predict->taken, actual->not taken
		EX_condFlag = 1'b0; //branch evaluates to not taken
		//Expected Results:
		//correct = 2'b00
		//reset = 1'b1
		//newPC = 4'b0100
		#10 
		//Test Case 3: predict->not taken, actual->taken
		prediction = 1'b0; 
		EX_condFlag = 1'b1; 
		//Expected Results:
		//correct = 2'b01
		//reset = 1'b1
		//newPC = 4'b1000
		#10 $finish; 
	end

endmodule 
