module row(clk, RST, player, RedPixels, GrnPixels, aboveG, belowG, aboveR, belowR);
		input logic               clk, player, RST, aboveG, aboveR, belowG, belowR;
		output logic RedPixels; 
		output logic GrnPixels; 
	 
		enum {off, onGreen, onRed} ps, ns;

		always_comb begin
			case(ps)
				onGreen:	if(belowG | belowR) ns = onGreen;
							else ns = off;
				onRed:	if(belowG | belowR) ns = onRed;
							else ns = off;
				
				off:		if(aboveG & ~aboveR) ns = onGreen;
							else if(aboveR & ~aboveG) ns = onRed;
							else ns = off;
			
			endcase
		end
		
		
		assign GrnPixels = (ps == onGreen);
		assign RedPixels = (ps == onRed);
		
		
		always_ff @(posedge clk) begin
			if(RST) ps <= off;
			else ps <= ns;
		end
endmodule


module row_testbench();

		logic  clk, player, RST, aboveG, belowG, aboveR, belowR;
		logic RedPixels; 
		logic GrnPixels; 
	
	row dut (.clk, .RST, .player, .RedPixels, .GrnPixels, .aboveG, .belowG, .aboveR, .belowR);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
	RST <= 1;  @(posedge clk);
	RST <= 0;  @(posedge clk);
	player <= 0; aboveR <= 1; aboveG <=0; belowG <= 0;	belowR <= 0;		@(posedge clk);
																								@(posedge clk);
	player <= 1; aboveR <= 1; aboveG <=0; belowG <= 1;	belowR <= 0; 		@(posedge clk);
																								@(posedge clk);
																								@(posedge clk);
																								@(posedge clk);
	$stop;
	end
	
endmodule