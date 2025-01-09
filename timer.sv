module timer(clk, value, out, RST);
	input logic 			clk, RST;
	input logic [31:0] 	value;
	output logic 			out; //true if count == value
	logic [31:0] 			count;
	logic 					on = 0;
	
	always_ff @(posedge clk) begin
		if(RST) begin
			count = 0;
			on <= 1;
		end else if((count == value) & on) begin
			count <= 0;
			out <= 1;
			on <= 0;
		end else begin
			count <= count + 1;
			out <= 0;
		end
	end
	

endmodule

module  timer_testbench();
	logic 			clk, RST;
	logic [31:0] 	value;
	logic 			out; //true if count == value
	
	timer dut (.clk, .value, .out, .RST);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		 value <= 2'b11; RST <= 1;			   @(posedge clk);
		 RST <= 0;									@(posedge clk);
										 repeat(13) @(posedge clk);

		
		$stop;
	end
endmodule