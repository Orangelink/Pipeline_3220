//Pipeline Controller skeleton
//TODOS:
//add logic, add outputs needed that were added to Project2.v for the pipeline processor
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
module PipelineController(IF_op, IF_func, DEC_op, DEC_func,
								  EX_op, EX_func, MEM_op, MEM_func, WB_op, WB_func, 
								  allowBr, brBaseMux, rs1Mux, rs2Mux, alu2Mux, 
								  aluOp, cmpOp, wrReg, wrMem, dstRegMux, ME_MEM_sel);
								  
	input [3:0] IF_op, DEC_op, EX_op, MEM_op, WB_op;
	input [3:0] IF_func, DEC_func, EX_func, MEM_func, WB_func;
	
	output allowBr;
   output brBaseMux;
   output rs1Mux;
   output [1:0] rs2Mux;
   output [1:0] alu2Mux;
   output [3:0] aluOp;
   output [3:0] cmpOp;
   output wrReg;
   output wrMem;
   output [1:0] dstRegMux;
	output MEM_MUX_sel;
	
   reg [1:0] IF_output;
	assign allowBr = IF_output[0];
	assign brBaseMux = IF_output[1];
	always @ (IF_op) begin
		//allowBr
		if IF_op == `BRANCH begin
			IF_output <= 2'b0_1;
		end
		//allowBr and brBaseMux
		else if IF_op == `JAL begin
			IF_output <= 2'b1_1;
		end
		else begin
			IF_output <= 2'b0_0;
		end
	end
	
	
	assign rs1Mux = DEC_output[2];
	assign rs2Mux = DEC_output[1:0];
	reg [2:0] DEC_output;
	always @ (DEC_op) begin
		if DEC_op == `BRANCH begin
			DEC_output <= 3'b1_10;
		end
		else if DEC_op == `SWOP begin:
			DEC_output <= 3'b0_01;
		end
		else begin
			DEC_output <= 3'b0_00;
		end
	end
	
	
	reg [9:0] EX_output;
	assign alu2Mux = EX_output[9:8];
	assign aluOp = EX_output[7:4];
	assign cmpOp = EX_output[7:4];
	//TODO
	always @ (EX_func, EX_op) begin
		
	end
	
	//TODO
	wire [7:0] MEM_input;
	reg [1:0] MEM_output;
	assign MEM_input = {{MEM_op}, {MEM_func}};

	//TODO
	wire [7:0] WB_input;
	reg [2:0] WB_output;
	assign MEM_input = {{MEM_op}, {MEM_func}};

								  
endmodule								  