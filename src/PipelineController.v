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
								  EX_op, EX_func, ME_op, ME_func, WB_op, WB_func, 
								  allowBr, brBaseMux, rs1Mux, rs2Mux, alu2Mux, 
								  aluOp, cmpOp, wrReg, wrMem, dstRegMux, MEM_Mux_sel);
								  
	input [3:0] IF_op, DEC_op, EX_op, ME_op, WB_op;
	input [3:0] IF_func, DEC_func, EX_func, ME_func, WB_func;
	
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
	output MEM_Mux_sel;
	
   reg [1:0] IF_output;
	assign allowBr = IF_output[0];
	assign brBaseMux = IF_output[1];
	always @ (IF_op) begin
		//allowBr
		if (IF_op == `BRANCH) begin
			IF_output <= 2'b0_1;
		end
		//allowBr and brBaseMux
		else if (IF_op == `JAL) begin
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
		if (DEC_op == `BRANCH) begin
			DEC_output <= 3'b1_10;
		end
		else if (DEC_op == `SWOP) begin
			DEC_output <= 3'b0_01;
		end
		else begin
			DEC_output <= 3'b0_00;
		end
	end
	
	
//	assign alu2Mux = EX_output[9:8];
//	assign aluOp = EX_output[7:4];
//	assign cmpOp = EX_output[3:0];
   assign alu2Mux = EX_output[13:12];
   assign aluOp = EX_output[11:8];
   assign cmpOp = EX_output[7:4];
	wire[7:0] EX_inputSignals;
   assign EX_inputSignals = {{EX_op}, {EX_func}};
	reg [18:0] EX_output;
	always @ (EX_inputSignals) begin
      case (EX_inputSignals)
        8'b11000111: EX_output = 19'b0_0_0_00_00_0111_0000_1_0_00;
        8'b11000110: EX_output = 19'b0_0_0_00_00_0110_0000_1_0_00;
        8'b11000000: EX_output = 19'b0_0_0_00_00_0000_0000_1_0_00;
        8'b11000001: EX_output = 19'b0_0_0_00_00_0001_0000_1_0_00;
        8'b11000010: EX_output = 19'b0_0_0_00_00_0010_0000_1_0_00;
        8'b11001000: EX_output = 19'b0_0_0_00_00_1000_0000_1_0_00;
        8'b11001001: EX_output = 19'b0_0_0_00_00_1001_0000_1_0_00;
        8'b11001010: EX_output = 19'b0_0_0_00_00_1010_0000_1_0_00;
        8'b01000111: EX_output = 19'b0_0_0_00_01_0111_0000_1_0_00;
        8'b01000110: EX_output = 19'b0_0_0_00_01_0110_0000_1_0_00;
        8'b01000000: EX_output = 19'b0_0_0_00_01_0000_0000_1_0_00;
        8'b01000001: EX_output = 19'b0_0_0_00_01_0001_0000_1_0_00;
        8'b01000010: EX_output = 19'b0_0_0_00_01_0010_0000_1_0_00;
        8'b01001000: EX_output = 19'b0_0_0_00_01_1000_0000_1_0_00;
        8'b01001001: EX_output = 19'b0_0_0_00_01_1001_0000_1_0_00;
        8'b01001010: EX_output = 19'b0_0_0_00_01_1010_0000_1_0_00;
        8'b01001111: EX_output = 19'b0_0_0_00_01_1111_0000_1_0_00;
        8'b11010000: EX_output = 19'b0_0_0_00_00_0110_0000_1_0_11;
        8'b11010011: EX_output = 19'b0_0_0_00_00_0110_0011_1_0_11;
        8'b11010101: EX_output = 19'b0_0_0_00_00_0110_0101_1_0_11;
        8'b11010110: EX_output = 19'b0_0_0_00_00_0110_0110_1_0_11;
        8'b11011001: EX_output = 19'b0_0_0_00_00_0110_1001_1_0_11;
        8'b11011010: EX_output = 19'b0_0_0_00_00_0110_1010_1_0_11;
        8'b11011100: EX_output = 19'b0_0_0_00_00_0110_1100_1_0_11;
        8'b11011111: EX_output = 19'b0_0_0_00_00_0110_1111_1_0_11;
        8'b01010000: EX_output = 19'b0_0_0_00_01_0110_0000_1_0_11;
        8'b01010011: EX_output = 19'b0_0_0_00_01_0110_0011_1_0_11;
        8'b01010101: EX_output = 19'b0_0_0_00_01_0110_0101_1_0_11;
        8'b01010110: EX_output = 19'b0_0_0_00_01_0110_0110_1_0_11;
        8'b01011001: EX_output = 19'b0_0_0_00_01_0110_1001_1_0_11;
        8'b01011010: EX_output = 19'b0_0_0_00_01_0110_1010_1_0_11;
        8'b01011100: EX_output = 19'b0_0_0_00_01_0110_1100_1_0_11;
        8'b01011111: EX_output = 19'b0_0_0_00_01_0110_1111_1_0_11;
        8'b01110000: EX_output = 19'b0_0_0_00_01_0111_0000_1_0_01;
        8'b00110000: EX_output = 19'b0_0_0_01_01_0111_0000_0_1_00;
        8'b00100000: EX_output = 19'b1_0_1_10_00_0110_0000_0_0_00;
        8'b00100001: EX_output = 19'b1_0_1_10_10_0110_0101_0_0_00;
        8'b00100010: EX_output = 19'b1_0_1_10_10_0110_0110_0_0_00;
        8'b00100011: EX_output = 19'b1_0_1_10_00_0110_0011_0_0_00;
        8'b00100101: EX_output = 19'b1_0_1_10_00_0110_0101_0_0_00;
        8'b00100110: EX_output = 19'b1_0_1_10_00_0110_0110_0_0_00;
        8'b00101000: EX_output = 19'b1_0_1_10_10_0110_1100_0_0_00;
        8'b00101001: EX_output = 19'b1_0_1_10_00_0110_1001_0_0_00;
        8'b00101010: EX_output = 19'b1_0_1_10_00_0110_1010_0_0_00;
        8'b00101011: EX_output = 19'b1_0_1_10_00_0110_1111_0_0_00;
        8'b00101100: EX_output = 19'b1_0_1_10_11_0110_1100_0_0_00;
        8'b00101101: EX_output = 19'b1_0_1_10_10_0110_1001_0_0_00;
        8'b00101110: EX_output = 19'b1_0_1_10_10_0110_1010_0_0_00;
        8'b00101111: EX_output = 19'b1_0_1_10_10_0110_1111_0_0_00;
        8'b01100000: EX_output = 19'b1_1_0_00_00_0000_0000_1_0_10;
        default: EX_output = 19'b0_0_00_00_0000_0000_0_0_00;
      endcase // case (inputSignals)
   end
	
	//TODO
	
	
//	always @ (EX_func, EX_op) begin
//		//alu2Mux
//		if EX_op == `ALUI || EX_op == `CMPI || EX_op == `LWOP || EX_op == `SWOP begin
//			EX_output[9:8] <= 2'b01;
//		end
//		else if EX_op == `BRANCH && (EX_func == `BNEZ || EX_func == `BEQZ || EX_func == `BLTEZ || EX_func == `BLTZ || EX_func == `BGTEZ || EX_func == `BGTZ) begin
//			EX_output[9:8] <= 2'b10;
//		end
//		else if EX_op == `BRANCH && EX_func == `LTE begin
//			EX_output[9:8] <= 2'b11;
//		end
//		else begin
//			EX_output[9:8] <= 2'b00;
//		end
//		//aluOp
//		if (EX_op == `ALUR || EX_op == `ALUI) begin
//			EX_output[7:4] <= EX_func;
//		end
//		else if (EX_op == `LWOP || EX_op == `SWOP) begin
//			EX_output[7:4] <= 4'b0111;
//		end
//		else if (EX_op == `JAL) begin
//			EX_output[7:4] <= 4'b0000;
//		end
//		else begin
//			EX_output[7:4] <= 4'b0110;
//		end
//		
//	end
	
	reg [1:0] MEM_output;
	assign wrMem = MEM_output[1];
	assign MEM_Mux_sel = MEM_output[0];
	always @ (ME_op) begin
		if (ME_op == `LWOP) begin
			MEM_output <= 2'b01;
		end
		else if (ME_op == `SWOP) begin
			MEM_output <= 2'b10;
		end
		else begin
			MEM_output <= 2'b00;
		end
	end

	wire [7:0] WB_input;
	reg [2:0] WB_output;
	assign wrReg = WB_output[2];
	assign dstRegMux = WB_output[1:0];
	always @ (WB_op) begin
		if (WB_op == `SWOP || WB_op == `BRANCH) begin
			WB_output[2] <= 1'b0;
		end
		else begin
			WB_output[2] <= 1'b1;
		end
		if (WB_op == `CMPR || WB_op == `CMPI) begin
			WB_output[1:0] <= 2'b11;
		end
		else if (WB_op == `LWOP) begin
			WB_output[1:0] <= 2'b01;
		end
		else if (WB_op == `JAL) begin
			WB_output[1:0] <= 2'b10;
		end
		else begin
			WB_output[1:0] <= 2'b00;
		end
	end
								  
endmodule								  