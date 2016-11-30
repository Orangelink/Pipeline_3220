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

`define BRANCH 4'b0010 

module takeBranch(opcode, func, src_data0, src_data1, taken);
   parameter bitwidth = 32;
	input[3:0] opcode, func;
	input[(bitwidth - 1) : 0] src_data0, src_data1; 
	output taken; 
	reg taken; 
	always @(*) begin
		if (opcode == `BRANCH) begin
			case(func)
				`BF: taken = 1'b0; 
				`BT: taken = 1'b1; 
				`BEQ: taken = (src_data0 == src_data1) ? 1'b1 : 1'b0; 
				`BNE: taken = (src_data0 != src_data1) ? 1'b1 : 1'b0; 
				`BLT: taken = (src_data0 < src_data1) ? 1'b1 : 1'b0; 
				`BGTE: taken = (src_data0 >= src_data1) ? 1'b1 : 1'b0;
				`BLTE: taken = (src_data0 <= src_data1) ? 1'b1 : 1'b0; 
				`BGT: taken = (src_data0 > src_data1) ? 1'b1 : 1'b0; 
				`BEQZ: taken = (src_data0 == 0) ? 1'b1 : 1'b0; 
				`BNEZ: taken = (src_data0 != 0) ? 1'b1 : 1'b0; 
				`BLTZ: taken = (src_data0 < 0) ? 1'b1 : 1'b0; 
				`BGTEZ: taken = (src_data0 >= 0) ? 1'b1 : 1'b0; 
				`BLTEZ: taken = (src_data0 <= 0) ? 1'b1 : 1'b0; 
				`BGTZ: taken = (src_data0 > 0) ? 1'b1 : 1'b0;
				default taken = 1'b0;
			endcase
		end 

	end
	
endmodule
