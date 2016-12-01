`timescale 1ns/1ps
`define ZERO 32'b00000000000000000000000000000000
`define ONE  32'b00000000000000000000000000000001
`define TWO  32'b00000000000000000000000000000010
module GshareTest();
	reg[31:0] predictPc, updatePc;
	reg clk, predict, update, reality;
	wire prediction;
	GShare GShare1(predictPc, updatePc, clk, predict, update, reality, prediction);
	initial begin
		predictPc <= `ZERO;
		updatePc <= `ZERO;
		clk <= 0;
		predict <= 0;
		update <= 0;
		reality <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		predict <= 1;
	
		#10
		clk <= 1;
		#10
		clk <= 0;
		update <= 1;
		reality <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		predict <= 1;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		reality <= 1;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		update <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		update <= 1;
		reality <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		update <= 0;
		#10
		clk <= 1;
		#10
		clk <= 0;
		#10
		clk <= 1;
		#10
		clk <= 0;
		#10
		clk <= 1;
		#10
		clk <= 0;
		
		#10
		$finish;
	end
endmodule
