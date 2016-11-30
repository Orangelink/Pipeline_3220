`define BRANCH 4'b0010
`define SW 4'b0011
module forwardingUnit(reg_index, reg_data, MEM_opcode, MEM_index, MEM_data, WB_opcode, WB_index, WB_data, data_forwarded);

   parameter REG_INDEX_BIT_WIDTH = 4;
	parameter bitwidth = 32; 
	input [3:0] MEM_opcode, WB_opcode; 
	input [(REG_INDEX_BIT_WIDTH - 1) : 0] reg_index, MEM_index, WB_index; 
	input [(bitwidth - 1) : 0] reg_data, MEM_data, WB_data; 
	
	output [(bitwidth - 1) : 0] data_forwarded; 
	reg[(bitwidth - 1) : 0] out;
	
	always @ (*) begin
		if (reg_index == MEM_index && reg_index != WB_index && (MEM_opcode == `BRANCH || MEM_opcode == `SW))
			out = MEM_data; 
		else if (reg_index != MEM_index && reg_index == WB_index && (WB_opcode == `BRANCH || WB_opcode == `SW))
			out = WB_data;
		else if (reg_index == MEM_index && reg_index == WB_index && (MEM_opcode == `BRANCH || MEM_opcode == `SW) && (WB_opcode == `BRANCH || WB_opcode == `SW))
			out = MEM_data;
		else 
			out = reg_data; 
	end
	
	assign data_forwarded = out; 
	
endmodule
