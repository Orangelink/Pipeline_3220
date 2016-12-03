`timescale 1ns/1ps
//opcodes
`define ALUR 4'b1100
`define ALUI 4'b0100
`define LWOP 4'b0111
`define SWOP 4'b0011
`define CMPR 4'b1101
`define CMPI 4'b0101
`define BRANCH 4'b0010
`define JAL 4'b0110

//functions
`define ADD 4'b0111
`define SUB 4'b0110
`define AND 4'b0000
`define OR 4'b0001
`define XOR 4'b0010
`define NAND 4'b1000
`define NOR 4'b1001
`define XNOR 4'b1010
`define MVHI 4'b1111
`define LWSW 4'b0000
`define F 4'b0011
`define  EQ 4'b0110
`define LT 4'b1001
`define LTE 4'b1100
`define T 4'b0000
`define NE 4'b0101
`define GTE 4'b1010
`define GT 4'b1111

//UNIQUE BRANCH
`define BEQZ 4'b0010
`define BLTZ 4'b1101
`define BLTEZ 4'b1000
`define BGT 4'b1011
`define BNEZ 4'b0001
`define BGTEZ 4'b1110
`define BGTZ 4'b1111
module TestPipelineController();
	
	reg [3:0] IF_op, DEC_op, EX_op, ME_op, WB_op;
	reg [3:0] IF_func, DEC_func, EX_func, ME_func, WB_func;
	
	wire allowBr;
   wire brBaseMux;
   wire rs1Mux;
   wire [1:0] rs2Mux;
   wire [1:0] alu2Mux;
   wire [3:0] aluOp;
   wire [3:0] cmpOp;
   wire wrReg;
   wire wrMem;
   wire [1:0] dstRegMux;
	wire MEM_Mux_sel;
	
	
	PipelineController myPipelineController(IF_op, IF_func, DEC_op, DEC_func,
														 EX_op, EX_func, ME_op, ME_func, WB_op, WB_func, 
														 allowBr, brBaseMux, rs1Mux, rs2Mux, alu2Mux, 
														 aluOp, cmpOp, wrReg, wrMem, dstRegMux, MEM_Mux_sel);
														 
	initial begin
		IF_op = `BRANCH;
		IF_func = `BEQZ;
		//Expected:
		//allowBr = 0
		//brbaseMux = 0
		DEC_op = `BRANCH;
		DEC_func = `BEQZ;
		//Expected: 
		//rs1Mux = 1
		//rs2Mux = 10
		EX_op = `ALUR;
		EX_func = `ADD;
		//Expected: 
		//alu2Mux = 00
		//aluOp = 0111
		//cmpOp = 0000
		ME_op = `LWOP;
		ME_func = `LWSW;
		//Expected: 
		//wrMem = 0
		//MEM_Mux_sel = 1
		WB_op = `SWOP;
		WB_func = `LWSW;
		//Expected: 
		//wrReg = 0
		//dstRegMux = 00
		#1
		IF_op = `JAL;
		IF_func = `LWSW;
		//Expected:
		//allowBr = 1
		//brbaseMux = 1
		DEC_op = `SWOP;
		DEC_func = `LWSW;
		//Expected: 
		//rs1Mux = 0
		//rs2Mux = 01
		EX_op = `ALUR;
		EX_func = `SUB;
		//Expected: 
		//alu2Mux = 00
		//aluOp = 0110
		//cmpOp = 0000
		ME_op = `SWOP;
		ME_func = `LWSW;
		//Expected: 
		//wrMem = 1
		//MEM_Mux_sel = 0
		WB_op = `BRANCH;
		WB_func = `BEQZ;
		//Expected: 
		//wrReg = 0
		//dstRegMux = 00
		#1 
		IF_op = `ALUR;
		IF_func = `ADD;
		//Expected:
		//allowBr = 0
		//brbaseMux = 0
		DEC_op = `ALUR;
		DEC_func = `ADD;
		//Expected: 
		//rs1Mux = 0
		//rs2Mux = 00
		EX_op = `CMPR;
		EX_func = `F;
		//Expected: 
		//alu2Mux = 00
		//aluOp = 0110
		//cmpOp = 0000
		ME_op = `ALUR;
		ME_func = `ADD;
		//Expected: 
		//wrMem = 0
		//MEM_Mux_sel = 0
		WB_op = `CMPR;
		WB_func = `F;
		//Expected: 
		//wrReg = 1
		//dstRegMux = 11
		#1 
		//DONE: IF, DEC, MEM
		//Keep testing EX and WB
		EX_op = `CMPI;
		EX_func = `LWSW;//lwsw used just fpr 4'b0000
		//Expected: 
		//alu2Mux = 01
		//aluOp = 0110
		//cmpOp = 0000 
		WB_op = `CMPI;
		WB_func = `F;
		//Expected: 
		//wrReg = 1
		//dstRegMux = 11
		#1
		EX_op = `LWOP;
		EX_func = `LWSW;
		//Expected: 
		//alu2Mux = 01
		//aluOp = 0111
		//cmpOp = 0000
		WB_op = `LWOP;
		WB_func = `LWSW;
		//Expected: 
		//wrReg = 1
		//dstRegMux = 01
		#1
		EX_op = `SWOP;
		EX_func = `LWSW;
		//Expected: 
		//alu2Mux = 01
		//aluOp = 0111
		//cmpOp = 0000
		WB_op = `JAL;
		WB_func = `LWSW;//used to get 0000
		//Expected: 
		//wrReg = 1
		//dstRegMux = 10
		#1
		EX_op = `CMPR;
		EX_func = `LWSW;//used to get 0000
		//Expected: 
		//alu2Mux = 00
		//aluOp = 0110
		//cmpOp = 0000 //0011
		WB_op = `ALUR;
		WB_func = `ADD;
		//Expected: 
		//wrReg = 1
		//dstRegMux = 00
		#1 $finish; 
	end


endmodule
