module bimodalPredictor(predictPc, updatePc, clk, predict, update, reality, prediction)
	parameter bit_width = 32;
	parameter tableLength = 1 << 12;
	input[bit_width -1 : 0] predictPc, updatePc;
	input predict, update, reality;
	output prediction;
	reg predictionReg;
	assign prediction = predicitonReg;
	
	reg[1:0] lookup [0:tableLength - 1];
	initial begin
		for(i = 0; i < tableLength; i = i + 1) begin
			lookup[i] <= 2b'10;
		end
		predicitonReg <= 1b'0;
	end
	
	always @ (posedge clk) begin
		if (predict == 1) begin
			predictionReg <= lookup[predictPc][1];
		end
		if (update == 1) begin
			if (reality == 1) begin
				if(lookup[updatePc] < 3) begin
					lookup[updatePc] <= lookup[updatePc] + 1; 
				end
			end
			else if (reality == 0) begin
				if(lookup[updatePc] > 0) begin
					lookup[updatePc] <= lookup[updatePc] - 1;
				end
			end
		end
	end
	
endmodule
