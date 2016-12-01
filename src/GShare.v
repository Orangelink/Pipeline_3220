module GShare(predictPc, updatePc, clk, predict, update, reality, prediction);
	parameter bit_width = 32;
	parameter tableLength = 1 << 12;
	input[bit_width -1 : 0] predictPc, updatePc;
	input predict, update, reality, clk;
	output prediction;
	reg[1:0] predictionReg;
	assign prediction = predictionReg[1];
	
	reg[1:0] lookup [0:tableLength - 1];
	reg[11:0] gHistory;
	initial begin
		integer i;
		for(i = 0; i < tableLength; i = i + 1) begin
			lookup[i] <= 2'b10;
		end
		predictionReg <= 2'b00;
		gHistory <= 12'b000000000000;
	end
	
	always @ (posedge clk) begin
		if (predict == 1) begin
			predictionReg <= lookup[predictPc ^ gHistory];
			gHistory[11:1] = gHistory[10:0];
			gHistory[0] <= predictionReg[1];
		end
		if (update == 1) begin
			if (reality == 1) begin
				if(lookup[updatePc ^ gHistory] < 3) begin
					lookup[updatePc ^ gHistory] <= lookup[updatePc ^ gHistory] + 1; 
				end
			end
			else if (reality == 0) begin
				if(lookup[updatePc ^ gHistory] > 0) begin
					lookup[updatePc ^ gHistory] <= lookup[updatePc ^ gHistory] - 1;
				end
			end
		end
	end
	



endmodule
