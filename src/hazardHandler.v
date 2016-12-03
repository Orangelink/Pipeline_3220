
module hazardHandler(IF_op, pcImm, DEC_op, IF_pc, IF_stall);
	parameter DBITS = 32;
	
	input[DBITS-1:0] pcImm, IF_pc;
	input[3:0] IF_op, DEC_op;
	output IF_stall;
	reg IF_stall_reg;
	assign IF_stall = IF_stall_reg;
	
	initial begin
		IF_stall_reg <= 1;
	end
	always @ (*) begin
		if (IF_op == `JAL && pcImm != IF_pc) begin
			IF_stall_reg <= 0;
		end
		else begin
			IF_stall_reg <= 1;
		end
	end

endmodule
