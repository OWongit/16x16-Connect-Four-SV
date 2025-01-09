module column(clk, RST, player, RedPixels, GrnPixels, placement, dropping);
    input logic         clk, RST, player, placement, dropping;
    output logic [15:0] RedPixels; // 16 array of red LEDs
    output logic [15:0] GrnPixels; // 16 array of green LEDs
	 
		//logic for dropping
		assign RedPixels[00] = dropping & ~player;
		assign GrnPixels[00] = dropping & player;
	 
	 
		row row1 (.clk, .RST, .player, .RedPixels(RedPixels[01]), .GrnPixels(GrnPixels[01]), .aboveG(placement & player), .belowG(GrnPixels[02]), .aboveR(placement & ~player), .belowR(RedPixels[02]));
		row row2 (.clk, .RST, .player, .RedPixels(RedPixels[02]), .GrnPixels(GrnPixels[02]), .aboveG(GrnPixels[01]), .belowG(GrnPixels[03]), .aboveR(RedPixels[01]), .belowR(RedPixels[03]));
		row row3 (.clk, .RST, .player, .RedPixels(RedPixels[03]), .GrnPixels(GrnPixels[03]), .aboveG(GrnPixels[02]), .belowG(GrnPixels[04]), .aboveR(RedPixels[02]), .belowR(RedPixels[04]));
		row row4 (.clk, .RST, .player, .RedPixels(RedPixels[04]), .GrnPixels(GrnPixels[04]), .aboveG(GrnPixels[03]), .belowG(GrnPixels[05]), .aboveR(RedPixels[03]), .belowR(RedPixels[05]));
		row row5 (.clk, .RST, .player, .RedPixels(RedPixels[05]), .GrnPixels(GrnPixels[05]), .aboveG(GrnPixels[04]), .belowG(GrnPixels[06]), .aboveR(RedPixels[04]), .belowR(RedPixels[06]));
		row row6 (.clk, .RST, .player, .RedPixels(RedPixels[06]), .GrnPixels(GrnPixels[06]), .aboveG(GrnPixels[05]), .belowG(GrnPixels[07]), .aboveR(RedPixels[05]), .belowR(RedPixels[07]));
		row row7 (.clk, .RST, .player, .RedPixels(RedPixels[07]), .GrnPixels(GrnPixels[07]), .aboveG(GrnPixels[06]), .belowG(GrnPixels[08]), .aboveR(RedPixels[06]), .belowR(RedPixels[08]));
		row row8 (.clk, .RST, .player, .RedPixels(RedPixels[08]), .GrnPixels(GrnPixels[08]), .aboveG(GrnPixels[07]), .belowG(GrnPixels[09]), .aboveR(RedPixels[07]), .belowR(RedPixels[09]));
		row row9 (.clk, .RST, .player, .RedPixels(RedPixels[09]), .GrnPixels(GrnPixels[09]), .aboveG(GrnPixels[08]), .belowG(GrnPixels[10]), .aboveR(RedPixels[08]), .belowR(RedPixels[10]));
		row row10 (.clk, .RST, .player, .RedPixels(RedPixels[10]), .GrnPixels(GrnPixels[10]), .aboveG(GrnPixels[09]), .belowG(GrnPixels[11]), .aboveR(RedPixels[09]), .belowR(RedPixels[11]));
		row row11 (.clk, .RST, .player, .RedPixels(RedPixels[11]), .GrnPixels(GrnPixels[11]), .aboveG(GrnPixels[10]), .belowG(GrnPixels[12]), .aboveR(RedPixels[10]), .belowR(RedPixels[12]));
		row row12 (.clk, .RST, .player, .RedPixels(RedPixels[12]), .GrnPixels(GrnPixels[12]), .aboveG(GrnPixels[11]), .belowG(GrnPixels[13]), .aboveR(RedPixels[11]), .belowR(RedPixels[13]));
		row row13 (.clk, .RST, .player, .RedPixels(RedPixels[13]), .GrnPixels(GrnPixels[13]), .aboveG(GrnPixels[12]), .belowG(GrnPixels[14]), .aboveR(RedPixels[12]), .belowR(RedPixels[14]));
		row row14 (.clk, .RST, .player, .RedPixels(RedPixels[14]), .GrnPixels(GrnPixels[14]), .aboveG(GrnPixels[13]), .belowG(GrnPixels[15]), .aboveR(RedPixels[13]), .belowR(RedPixels[15]));
		row row15 (.clk, .RST, .player, .RedPixels(RedPixels[15]), .GrnPixels(GrnPixels[15]), .aboveG(GrnPixels[14]), .belowG(1'b1), .aboveR(RedPixels[14]), .belowR(1'b1));
		
endmodule

module column_testbench();

    logic  clk, RST, player, placement, dropping;
    logic [15:0] RedPixels; //16 array of red LEDs
    logic [15:0] GrnPixels;
	
	column dut (.clk, .RST, .player, .RedPixels, .GrnPixels, .placement, .dropping);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
	RST <= 1; player <= 0; 																	@(posedge clk);
	RST <= 0;  																					@(posedge clk);
	player <= 1; placement <= 1;											         	@(posedge clk);
	player <= 1; placement <= 0;											         	@(posedge clk);
																					repeat(15)	@(posedge clk);
																									@(posedge clk);
   player <= 0; placement <= 1;											         	@(posedge clk);
	player <= 0; placement <= 0;											         	@(posedge clk);
																					repeat(15)	@(posedge clk);
																									@(posedge clk);		
	$stop;
	end
	
endmodule
