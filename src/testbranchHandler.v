`timescale 1ns/1ps
`define BRANCH 4'b0010
`define ALU-R 4'b1100
`define ALU-I 4'b0100

module testbranchHandler();
   parameter DBITS = 32;
	
	reg [(DBITS - 1):0] EX_PC_IMM, EX_PC;
	reg [3:0] EX_opcode;
	reg EX_condFlag;
	reg prediction;
	
	wire correctOut; 
	wire reset; 
	wire [(DBITS - 1):0] newPC; 
	
	branchHandler mybranchHandler(EX_PC_IMM, EX_PC, EX_opcode, EX_condFlag, prediction, correctOut, reset, newPC);

	initial begin
		//Test Case 1: predict->taken, actual->taken
		EX_PC = 32'b000000000000000000000000000100;
		EX_PC_IMM = 32'b000000000000000000000000001000;
		EX_opcode = `BRANCH; 
		EX_condFlag = 1'b1; //branch evaluates true
		prediction = 1'b1; 
		//Expected Results:
		//correct = 1
		//reset = 0
		//newPC = EX_PC
		#10
		//Test Case 2: predict->taken, actual->not taken
		EX_condFlag = 1'b0; //branch evaluates to not taken
		//Expected Results:
		//correct = 0
		//reset = 1
		//newPC = EX_PC
		#10 
		//Test Case 3: predict->not taken, actual->taken
		prediction = 1'b0; 
		EX_condFlag = 1'b1; 
		//Expected Results:
		//correct = 0
		//reset = 1
		//newPC = EX_PC_IMM
		#10 $finish; 
	end

endmodule 
