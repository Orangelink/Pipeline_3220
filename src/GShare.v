module GShare(predictPc, updatePc, clk, predict, update, reality, prediction);
	parameter bit_width = 32;
	parameter tableLength = 1 << 12;
	input[bit_width -1 : 0] predictPc, updatePc;
	input predict, update, reality, clk;
	output prediction;
	reg[1:0] predictionReg;
	assign prediction = predictionReg[1];
	wire[11:0] predictPcIndex;
	assign predictPcIndex = predictPc[11:0];
	wire[11:0] updatePcIndex;
	assign updatePcIndex = updatePc[11:0];
	
	reg[1:0] lookup [0:tableLength - 1];
	reg[11:0] gHistory;
	integer i;
	
	initial begin
		for(i = 0; i < tableLength; i = i + 1) begin
			lookup[i] <= 2'b10;
		end
		predictionReg <= 2'b00;
		gHistory <= 12'b0000000000000;
	end
	
	always @ (posedge clk) begin
		if (predict == 1) begin
			predictionReg <= lookup[predictPcIndex ^ gHistory];
		end
		if (update == 1) begin
			if (reality == 1) begin
				if(lookup[updatePcIndex ^ gHistory] < 3) begin
					lookup[updatePcIndex ^ gHistory] <= lookup[updatePcIndex ^ gHistory] + 2'b01;
				end
			end
			else if (reality == 0) begin
					if(lookup[updatePcIndex	^ gHistory] > 0) begin
					lookup[updatePcIndex ^ gHistory] <= lookup[updatePcIndex ^ gHistory] - 2'b01;
				end
			end
			gHistory[11:1] = gHistory[10:0];
			gHistory[0] <= reality;
		end
	end
	



endmodule
