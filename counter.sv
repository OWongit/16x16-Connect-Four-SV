module counter(clk, value, out, RST);
	input logic 			clk, RST;
	input logic [31:0] 	        value;
	output logic 			out; //true if count == value
	logic [31:0] 			count = 0;
	
	always_ff @(posedge clk) begin
		if(RST)
			count = 0;
		else if(count == value) begin
			count <= 0;
			out <= 0;
		end else begin
			count <= count + 1;
			out <= 1;
		end
	end
	

endmodule

module counter_testbench();
	logic 			clk;
	logic [31:0] 	value;
	logic 			out; //true if count == value
	
	counter dut (.clk, .value, .out);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		 value <= 2'b11;							@(posedge clk);
										 repeat(13) @(posedge clk);

		
		$stop;
	end
endmodule