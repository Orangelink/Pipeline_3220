`timescale 1ns/1ps
`define ZERO 32'b00000000000000000000000000000000
`define ONE  32'b00000000000000000000000000000001
`define TWO  32'b00000000000000000000000000000010
`define BRANCH 4'b0010
`define ADD 4'b1100 

`define BF 4'b0011
`define BEQ 4'b0110
`define BLT 4'b1001
`define BLTE 4'b1100
`define BEQZ 4'b0010
`define BLTZ 4'b1101
`define BLTEZ 4'b1000

`define BT 4'b0000
`define BNE 4'b0101
`define BGTE 4'b1010
`define BGT 4'b1011
`define BNEZ 4'b0001
`define BGTEZ 4'b1110
`define BGTZ 4'b1111
module TesttakeBranch();
	parameter bitwidth = 32;
	
	reg [3:0] opcode, func;
	reg [(bitwidth - 1) : 0] src_data0, src_data1; 
	
	wire taken; 
	
	takeBranch myTakeBranch(opcode, func, src_data0, src_data1, taken);

	initial begin
		//TEST CASE 1: not a branch opcode
		//Expected Output: Does nothing 
		opcode = `ADD;
		src_data0 = `ONE;
		src_data1 = `TWO; 
		func = `BEQZ; 
		#10
		//TEST CASE 2: data0 = 1 < data1 = 2
		//Expected Output 1
		opcode = `BRANCH;
		func = `BLT; 
		#10 
		opcode = `BRANCH;
		func = `BGT;
		#10 $finsih;
	end

endmodule
