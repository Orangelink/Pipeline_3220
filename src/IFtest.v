module IFTest();
	parameter DBITS = 32;
	
	reg[DBITS-1:0] brBaseOffset;
	reg[DBITS-1:0] pcIncremented;
	reg[DBITS-1:0] instWord;
	reg prediction, clk, reset, IF_wrt_en;
	wire IF_prediction;
	wire[DBITS-1:0] IF_brBaseOffset, IF_pcIncremented, IF_instWord;

	
	initial begin
		brBaseOffset <= 1;
		pcIncremented <= 32'b11111111111111111111111111111110;
		instWord <= 3;
		prediction <= 1;
		IF_wrt_en <= 1;
		reset <= 0;
		
		clk <= 0;	
		#10
		clk <= 1;
		#10
		
		reset <= 1;
		clk <= 0;	
		#10
		clk <= 1;
		#10
		reset <= 0;
		
		IF_wrt_en <= 0;
		
		clk <= 0;	
		#10
		clk <= 1;
		#10
		IF_wrt_en <= 1;
		clk <= 0;	
		#10
		clk <= 1;
		#10
		
		$finish;
	end
	
	
	IFreg IFreg0(IF_wrt_en, reset, clk, brBaseOffset, pcIncremented, instWord, prediction,
			IF_brBaseOffset, IF_pcIncremented, IF_instWord, IF_prediction);
endmodule
