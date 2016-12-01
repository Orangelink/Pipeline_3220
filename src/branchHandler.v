`define FOUR 4'b0100
`define BRANCH 4'b0010
`define TAKEN_NOT_SUPPOSED_TO 4'b00
`define NOT_TAKEN_SUPPOSED_TO 4'b01
module branchHandler (PC, EX_PC, EX_opcode, EX_condFlag, prediction, imm, correct, reset, newPC);
							 
   parameter DBITS = 32;
	parameter REG_INDEX_BIT_WIDTH = 4;

	input [(REG_INDEX_BIT_WIDTH - 1):0] PC, EX_PC;
	input [3:0] EX_opcode;
	input EX_condFlag;
	input prediction; 
	input [(DBITS - 1):0] imm; 
	//correct's first bit determines if the prediction was correct
	//correct's second bit determines what type of right/wrong prediction you had
	output [1:0] correct; 
	reg [1:0] correct; 
	output reset; 
	reg reset; 
	output [(REG_INDEX_BIT_WIDTH - 1):0] newPC; 
	reg [(REG_INDEX_BIT_WIDTH - 1):0] newPC; 
	
	always @ (*) begin
		if (EX_opcode == `BRANCH) begin
			//Case 1: you predict correctly 
			if (EX_condFlag == prediction) begin
				correct = 2'b10;//Note: 2'b11 also works
				newPC = PC + 4;//everything is fine, just go to next instruction 
				reset = 1'b0; 
			end 
			//Case 2: you predict taken, but you aren't supposed to
			//PC should be updated to instruction after branch (i.e. EX_PC)
			//Flush: You need to reset IF and DEC registers
			else if (EX_condFlag == 1'b0 && prediction == 1'b1) begin
				correct = `TAKEN_NOT_SUPPOSED_TO; 
				newPC = EX_PC;
				reset = 1'b1; 
			end
			//Case 3: you predict not taken, but you were supposed to
			//Update PC to instruction jump in branch statement (i.e. PC + imm)
			//Flush: You need to reset IF and DEC registers
			else if (EX_condFlag == 1'b1 && prediction == 1'b0) begin
				correct = `NOT_TAKEN_SUPPOSED_TO;
				newPC = EX_PC - 4 + imm; //TODO: set PC + imm
				reset = 1'b1; 
			end
			else begin
				//any other case? 
			end
		end
	end
	

	
	
endmodule
