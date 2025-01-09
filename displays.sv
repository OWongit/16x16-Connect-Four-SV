module displays(clk, RST, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, scoreG, scoreR);
	input logic clk, RST;
	input logic [2:0] scoreG, scoreR;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	

	hexFlash FLASHHEX0 (.clk(clk), .trigger(scoreR == 3'b101), .HEXin(7'b0100100), .HEXout(HEX0));
	hexFlash FLASHHEX1 (.clk(clk), .trigger(scoreR == 3'b101), .HEXin(7'b0001100), .HEXout(HEX1));
	
	hexFlash FLASHHEX4 (.clk(clk), .trigger(scoreG == 3'b101), .HEXin(7'b1111001), .HEXout(HEX4));
	hexFlash FLASHHEX5 (.clk(clk), .trigger(scoreG == 3'b101), .HEXin(7'b0001100), .HEXout(HEX5));

	always_comb begin
	
		if(scoreG == 3'b001)				//1
				HEX3 = 7'b1111001;
		else if(scoreG == 3'b010)		//2
				HEX3 = 7'b0100100;
		else if(scoreG == 3'b011)		//3
				HEX3 = 7'b0110000;
		else if(scoreG == 3'b100)		//4
				HEX3 = 7'b0011001;
		else									//0 
				HEX3 = 7'b1000000;		
				
		if(scoreR == 3'b001)				//1
				HEX2 = 7'b1111001;
		else if(scoreR == 3'b010)		//2
				HEX2 = 7'b0100100;
		else if(scoreR == 3'b011)		//3
				HEX2 = 7'b0110000;
		else if(scoreR == 3'b100)		//4
				HEX2 = 7'b0011001;
		else									//0
				HEX2 = 7'b1000000;		
	end
endmodule


module  displays_testbench();
	logic clk, RST;
	logic [2:0] scoreG, scoreR;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	displays dut (.clk, .RST, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .scoreG, .scoreR);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		 RST <= 1;			   					@(posedge clk);
		 RST <= 0;									@(posedge clk);
		 scoreG <= 3'b100;
		 scoreG <= 3'b101;
										 repeat(15) @(posedge clk);

		
		$stop;
	end
endmodule