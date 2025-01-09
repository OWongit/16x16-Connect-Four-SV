// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;
	 
	 //clk setup
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 assign SYSTEM_CLOCK = clk[13]; // 1526 Hz clock signal	 
	 
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
         logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic reset;                   // reset - toggle this on startup
	 
	 assign reset = SW[9];
	 assign LEDR[9] = reset;
	 assign LEDR[7:0] = SW[7:0];
	 
	 //LEDDRIVER setup
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST(reset), .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 //turn logic
	 logic turn;
	 logic inLeft, inRight;
	 assign turn = inLeft | inRight;
	 
	 logic [2:0] scoreRED, scoreGREEN;
	 
	 
	 //slower clock
	 counter COUNT (.clk(SYSTEM_CLOCK), .value(5'b11111), .out(SLOWclock));
	 
	 //game control
	 gameControl CONTROL (.clk(SLOWclock), .RST(reset), .player(plr), .RedPixels, .GrnPixels, .turn(turn), .scoreG(scoreGREEN), .scoreR(scoreRED), .nextRound(nxtRnd));

	 //score and hex displays
	 displays DISPLAY (.clk(SLOWclock), .RST(reset), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .scoreG(scoreGREEN), .scoreR(scoreRED));
	 
	 //for metastability of user spams
	 stabilizer stableL (.clk(SLOWclock), .reset(reset), .key(~KEY[3] | ~KEY[2]), .out(keyStableL));
	 stabilizer stableR (.clk(SLOWclock), .reset(reset), .key(~KEY[1] | ~KEY[0]), .out(keyStableR));
	 
	 //assign one true value/pulse for each press of key
	 uInput INPUTL (.clk(SLOWclock), .reset(reset), .key(keyStableL & ~keyStableR), .out(inLeft));
	 uInput INPUTR (.clk(SLOWclock), .reset(reset), .key(~keyStableL & keyStableR), .out(inRight));
	 
	 //board control
	 board BOARD (.clk(SLOWclock), .RST(reset | nxtRnd), .player(plr) ,.RedPixels(RedPixels), .GrnPixels(GrnPixels), .placement(SW[7:0]), .left(inLeft), .right(inRight));
	 
endmodule

module DE1_SoC_testbench();
	logic 		CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [35:0] GPIO_1;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_1);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	// Test the design.
		initial begin
		SW[9] <= 1;										@(posedge CLOCK_50);
		SW[9] <= 0;										@(posedge CLOCK_50);
															@(posedge CLOCK_50);		
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);
															@(posedge CLOCK_50);		
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);
															@(posedge CLOCK_50);		
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);
															@(posedge CLOCK_50);		
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);
															@(posedge CLOCK_50);		
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);
															@(posedge CLOCK_50);		
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);	
		KEY[3] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[3] <= 1;									@(posedge CLOCK_50);
		KEY[0] <= 0; SW[0] <= 1;					@(posedge CLOCK_50);
		KEY[0] <= 1;									@(posedge CLOCK_50);
											repeat(20)	@(posedge CLOCK_50);


		
		$stop;
	end

endmodule