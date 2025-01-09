module board(clk, RST, player, RedPixels, GrnPixels, placement, left, right);
    input logic               clk, RST, player, left, right;
	 input logic  [7:0]       placement; // column of placement
    output logic [15:0][15:0] RedPixels; // 16x16 array of red LEDs
    output logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs


	 
	 column column0 (.clk, .RST, .player, .RedPixels(RedPixels[00]), .GrnPixels(GrnPixels[00]), .placement((placement == 8'b00000001) & right), .dropping(placement == 8'b00000001));
	 column column1 (.clk, .RST, .player, .RedPixels(RedPixels[01]), .GrnPixels(GrnPixels[01]), .placement((placement == 8'b00000010) & right), .dropping(placement == 8'b00000010));
	 column column2 (.clk, .RST, .player, .RedPixels(RedPixels[02]), .GrnPixels(GrnPixels[02]), .placement((placement == 8'b00000100) & right), .dropping(placement == 8'b00000100));
	 column column3 (.clk, .RST, .player, .RedPixels(RedPixels[03]), .GrnPixels(GrnPixels[03]), .placement((placement == 8'b00001000) & right), .dropping(placement == 8'b00001000));
	 column column4 (.clk, .RST, .player, .RedPixels(RedPixels[04]), .GrnPixels(GrnPixels[04]), .placement((placement == 8'b00010000) & right), .dropping(placement == 8'b00010000));
	 column column5 (.clk, .RST, .player, .RedPixels(RedPixels[05]), .GrnPixels(GrnPixels[05]), .placement((placement == 8'b00100000) & right), .dropping(placement == 8'b00100000));
	 column column6 (.clk, .RST, .player, .RedPixels(RedPixels[06]), .GrnPixels(GrnPixels[06]), .placement((placement == 8'b01000000) & right), .dropping(placement == 8'b01000000));
	 column column7 (.clk, .RST, .player, .RedPixels(RedPixels[07]), .GrnPixels(GrnPixels[07]), .placement((placement == 8'b10000000) & right), .dropping(placement == 8'b10000000));
	 column column8 (.clk, .RST, .player, .RedPixels(RedPixels[08]), .GrnPixels(GrnPixels[08]), .placement((placement == 8'b10000000) & left), .dropping(placement == 8'b10000000));
	 column column9 (.clk, .RST, .player, .RedPixels(RedPixels[09]), .GrnPixels(GrnPixels[09]), .placement((placement == 8'b01000000) & left), .dropping(placement == 8'b01000000));
	 column column10 (.clk, .RST, .player, .RedPixels(RedPixels[10]), .GrnPixels(GrnPixels[10]), .placement((placement == 8'b00100000) & left), .dropping(placement == 8'b00100000));
	 column column11 (.clk, .RST, .player, .RedPixels(RedPixels[11]), .GrnPixels(GrnPixels[11]), .placement((placement == 8'b00010000) & left), .dropping(placement == 8'b00010000));
	 column column12 (.clk, .RST, .player, .RedPixels(RedPixels[12]), .GrnPixels(GrnPixels[12]), .placement((placement == 8'b00001000) & left), .dropping(placement == 8'b00001000));
	 column column13 (.clk, .RST, .player, .RedPixels(RedPixels[13]), .GrnPixels(GrnPixels[13]), .placement((placement == 8'b00000100) & left), .dropping(placement == 8'b00000100));
	 column column14 (.clk, .RST, .player, .RedPixels(RedPixels[14]), .GrnPixels(GrnPixels[14]), .placement((placement == 8'b00000010) & left), .dropping(placement == 8'b00000010));
	 column column15 (.clk, .RST, .player, .RedPixels(RedPixels[15]), .GrnPixels(GrnPixels[15]), .placement((placement == 8'b00000001) & left), .dropping(placement == 8'b00000001));

endmodule


module board_testbench();
	 logic 					left, right;
    logic               clk, RST, player;
	 logic  [7:0]       placement;
    logic [15:0][15:0] RedPixels; // 16x16 array of red LEDs
    logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs
	
	board dut (.clk, .RST, .player, .RedPixels, .GrnPixels, .placement, .left, .right);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
	RST = 1;  @(posedge clk);
	RST = 0;  @(posedge clk);
	player = 0; placement[00] = 1; left <= 1; @(posedge clk);
	placement[00] = 0; left <= 0;						 @(posedge clk);
									 repeat(15)  @(posedge clk);
	placement[00] = 1; left <= 1; 						 @(posedge clk);
	placement[00] = 0; left <= 0;						 @(posedge clk);
									 repeat(15)  @(posedge clk);
								$stop;
	end
	
endmodule