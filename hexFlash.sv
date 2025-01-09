module hexFlash(clk, trigger, HEXin, HEXout);
    input  logic        clk;       
    input  logic        trigger;        
    input  logic [6:0]  HEXin;   
    output logic [6:0]  HEXout;

	 logic [31:0] countRATE = 0;
    logic [3:0]  countFLASH = 0;
    logic        active = 0;
    logic        displayON = 0;

    always_ff @(posedge clk) begin
        if (trigger && !active) begin
            // Start flashing sequence
            active       <= 1;
            countRATE <= 0;
            countFLASH <= 0;
            displayON   <= 1;
        end else if (active) begin
            if (countRATE < 4'b1111) begin
                countRATE <= countRATE + 1;
            end else begin
                // Toggle display state
                displayON   <= ~displayON;
                countRATE <= 0;
                if (!displayON) begin
                    // Increment flash count after each off state
                    countFLASH <= countFLASH + 1;
                    if (countFLASH == 4'b1011) begin
                        // Stop after desired number of flashes
                        active <= 0;
                    end
                end
            end
        end
    end

    always_comb begin
        if (active & displayON) begin
            HEXout = 7'b1111111;
        end else begin
            HEXout = HEXin;
        end
    end

endmodule

module  hexFlash_testbench();
    logic        clk;       
    logic        trigger;        
    logic [6:0]  HEXin;   
    logic [6:0]  HEXout;
	
	hexFlash dut (.clk, .trigger, .HEXin, .HEXout);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		 HEXin <= 7'b1010101;			   					@(posedge clk);
		 trigger <= 1;												@(posedge clk);
		 trigger <= 0;												@(posedge clk);
														 repeat(25) @(posedge clk);
	end
endmodule