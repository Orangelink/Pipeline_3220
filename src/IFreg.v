module IFreg(wrt_en, reset, clk, brBaseOffset, pcIncremented, instWord, prediction,
				 IF_brBaseOffset, IF_pcIncremented, IF_instWord, IF_prediction);
	parameter DBITS = 32;
	
	input prediction, wrt_en, clk, reset;
	input [DBITS-1:0] brBaseOffset, pcIncremented, instWord;
	output [DBITS-1:0] IF_brBaseOffset, IF_pcIncremented, IF_instWord;
	output IF_prediction;
	
	Register #(DBITS, 0) BrBaseReg(clk, reset, wrt_en, brBaseOffset, IF_brBaseOffset);
	Register #(DBITS, 0) pcIncrementedReg(clk, reset, wrt_en, pcIncremented, IF_pcIncremented);
	Register #(DBITS, 0) instWordReg(clk, reset, wrt_en, instWord, IF_instWord);
	Register #(1, 0) predictionReg(clk, reset, wrt_en, prediction, IF_prediction);
endmodule
