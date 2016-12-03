module testDECreg();
	parameter DBITS = 32;
	parameter REG_INDEX_BIT_WIDTH = 4;
	
	
	wire  DEC_prediction, DEC_wrReg, DEC_wrMem, DEC_ME_Mux_sel;
	wire [DBITS-1:0] DEC_brBaseOffset, DEC_pc, DEC_immval, DEC_regData1, DEC_regData2;
	wire [REG_INDEX_BIT_WIDTH-1:0] DEC_rs1, DEC_rs2, DEC_rd, EX_op, EX_func;
	wire [1:0] DEC_alu2MuxSel;
	
	reg clk;
	reg DEC_wrt_en;
	reg reset;
	reg[DBITS-1:0] IF_brBaseOffset;
	reg[DBITS - 1:0] IF_pcout;
	reg [DBITS - 1:0] immval;
	reg [DBITS - 1:0] regData1;
	reg [DBITS - 1:0] regData2;
	reg [REG_INDEX_BIT_WIDTH - 1:0] rs1;
	reg [REG_INDEX_BIT_WIDTH - 1:0] rs2;
	reg [REG_INDEX_BIT_WIDTH - 1:0] rd;
	reg[3:0] opcode;
	reg[3:0] func;
	reg IF_prediction;
	reg wrReg;
	reg wrMem;
	reg MEM_Mux_sel;
	reg[1:0] alu2MuxSel;	
	DECreg DECreg0(DEC_wrt_en, reset, clk, IF_brBaseOffset, IF_pcout, immval, regData1, regData2,
					rs1, rs2, rd, opcode, func, IF_prediction, wrReg, wrMem, MEM_Mux_sel,
					alu2MuxSel, DEC_brBaseOffset, DEC_pc, DEC_immval, DEC_regData1, DEC_regData2,
					DEC_rs1, DEC_rs2, DEC_rd, EX_op, EX_func, DEC_prediction, DEC_wrReg, DEC_wrMem, DEC_ME_Mux_sel,
					DEC_alu2MuxSel);
		
	initial begin
		DEC_wrt_en <= 1;
		IF_brBaseOffset <= -1;
		IF_pcout <= -2;
		immval <= -3;
		regData1 <= -4;
		regData2 <= -4;
		rs1 <= 3;
		rs2 <= 5;
		rd <= 2;
		opcode <= 1;
		func <= 5;
		IF_prediction <= 1;
		wrReg <= 0;
		wrMem <= 1;
		MEM_Mux_sel <= 1;
		alu2MuxSel <= 2;
		
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
