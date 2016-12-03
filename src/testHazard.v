`define JAL 4'b0110
module testHazard();

	reg[31:0] IF_op, DEC_op;
	reg[31:0] pcImm, IF_pc;
	
	wire IF_stall;
	
	hazardHandler handler(IF_op, pcImm, DEC_op, IF_pc, IF_stall);
	initial begin
		IF_op <= `JAL;
		DEC_op <= 0;
		IF_pc <= 1;
		pcImm <= 0;
		
		#10
		pcImm <= 1;
		#10
		IF_pc <= 0;
		#10
		IF_op <= 0;
		#10
		$finish;
	
	end
endmodule
