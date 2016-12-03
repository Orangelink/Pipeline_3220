module testDECreg();
	parameter DBITS = 32;
	
	
	wire  DEC_prediction, DEC_wrReg, DEC_wrMem, DEC_ME_Mux_sel;
	wire [DBITS-1:0] DEC_brBaseOffset, DEC_pc, DEC_immval, DEC_regData1, DEC_regData2;
	wire [REG_INDEX_BIT_WIDTH-1:0] DEC_rs1, DEC_rs2, DEC_rd, EX_op, EX_func;
	wire [1:0] DEC_alu2Muxsel;
	
	
	reg DEC_wrt_en;
	reg reset;
	reg[DBITS-1:0] DEC_brBaseOffset;
	reg[DBITS - 1:0] DEC_pc;
	reg [DBITS - 1:0] DEC_immval;
	reg [DBITS - 1:0] DEC_regData1;
	reg [DBITS - 1:0] DEC_regData2;
	reg [REG_INDEX_BIT_WIDTH - 1:0] DEC_rs1;
	reg [REG_INDEX_BIT_WIDTH - 1:0] DEC_rs2;
	reg [REG_INDEX_BIT_WIDTH - 1:0] DEC_rd;
	reg[3:0] DEC_op;
	reg[3:0] DEC_func;
	reg DEC_prediction;
	reg DEC_wrReg;
	reg DEC_wrMem;
	reg DEC_ME_mux_sel;
	reg[1:0] DEC_alu2MuxSel;	
	DECreg DECreg0(DEC_wrt_en, resetReg, clk, IF_brBaseOffset, IF_pcout, immval, regData1, regData2,
					rs1, rs2, rd, opcode, func, IF_prediction, wrReg, wrMem, MEM_Mux_sel,
					alu2MuxSel, DEC_brBaseOffset, DEC_pc, DEC_immval, DEC_regData1, DEC_regData2,
					DEC_rs1, DEC_rs2, DEC_rd, EX_op, EX_func, DEC_prediction, DEC_wrReg, DEC_wrMem, DEC_ME_mux_sel,
					DEC_alu2MuxSel);
		
	initial begin
		DEC_wrt_en <= 1;
		DEC_brBaseOffset <= -1;
		DEC_pc <= -2;
		DEC_immval <= -3;
		DEC_regData1 <= -4;
		DEC_regData2 <= -4;
		DEC_rs1 <= 3;
		DEC_rs2 <= 5;
		DEC_rd <= 2;
		DEC_op <= 1;
		DEC_func <= 5;
		DEC_prediction <= 1;
		DEC_wrReg <= 0;
		DEC_wrMem <= 1;
		DEC_ME_mux_sel <= 1;
		DEC_alu2MuxSel <= 2;
		
		clk <= 0;
		reset <= 0;
		#10
		clk <= 1;
		#10
		clk <= 0;
		reset <= 1;
		#10
		clk <= 1;
		#10
		clk <= 0;
		reset <= 0;
		DEC_wrt_en <= 0;
		#10
		clk <= 1;
		#10
		clk <= 0;
		#10
		
		$finish;
		
	end
endmodule
