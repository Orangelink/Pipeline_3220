`timescale 1ns/1ps
`define ZERO 32'b00000000000000000000000000000000
`define ONE  32'b00000000000000000000000000000001
`define TWO  32'b00000000000000000000000000000010
`define BRANCH 4'b0010
`define SW 4'b0011
`define ADD 4'b1100 

module TestforwardingUnit();
   parameter REG_INDEX_BIT_WIDTH = 4;
	parameter bitwidth = 32;
	
	reg [3:0] MEM_opcode, WB_opcode; 
	reg [(REG_INDEX_BIT_WIDTH - 1) : 0] reg_index, MEM_index, WB_index; 
	reg [(bitwidth - 1) : 0] reg_data, MEM_data, WB_data; 
	
	wire [(bitwidth - 1) : 0] data_forwarded; 
	
	forwardingUnit myForwardingUnit(reg_index, reg_data, MEM_opcode, MEM_index, MEM_data, WB_opcode, WB_index, WB_data, data_forwarded);

	initial begin
		//TEST CASE 1: Non-equal indices
		//Expected Output: 32'b00000000000000000000000000000000
		reg_index = 4'b0000;
		MEM_index = 4'b0001;
		WB_index = 4'b0010;
		reg_data = `ZERO;
		MEM_data = `ONE;
		WB_data = `TWO; 
		MEM_opcode = `BRANCH; 
		WB_opcode = `BRANCH; 
		#10 
		//TEST CASE 2: reg_index == MEM_index
		//Expected Output: 32'b00000000000000000000000000000001
		MEM_index = 4'b0000;
		#10 
		//TEST CASE 3: reg_index == WB_index
		//Expected Output: 32'b00000000000000000000000000000010
		MEM_index = 4'b0001;
		WB_index = 4'b0000; 
		#10
		//TEST CASE 4: reg_index == MEM_index = WB_index
		//Expected Output: 32'b00000000000000000000000000000001
		MEM_index = 4'b0000;
		#10 
		//TEST CASE 5: opcode 1100
		//Expected Output: 32'b00000000000000000000000000000000
		MEM_opcode = `ADD;
		#10
		//TEST CASE 6: opcode 0011
		//Expected Output: 32'b00000000000000000000000000000001
		MEM_opcode = `SW; 
		#10 $finsih; 
		
	end

endmodule
