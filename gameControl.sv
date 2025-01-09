module gameControl(clk, RST, player, RedPixels, GrnPixels, turn, scoreG, scoreR, nextRound);
	input logic 			clk, RST, turn;
	input logic [15:0][15:0] 	RedPixels, GrnPixels;
	output logic 			player, nextRound;
	output logic [2:0] 		scoreG, scoreR;

	//create delay for scanning
	timer TIMER (.clk(clk), .value(5'b11111), .out(SLOWERtimer), .RST(turn));
	logic scan;
	assign scan = SLOWERtimer;
	
	//winner states
	enum{none, PR, PG} ps, ns;
	
	
    always_comb begin
	ns = none; //prevent latches  
	case(ps)
		
	none: begin
	// check Green
        // Horizontal check
        for (int i = 0; i < 16; i++) begin
            for (int j = 1; j <= 12; j++) begin
                if (GrnPixels[i][j] & GrnPixels[i][j+1] &
                    GrnPixels[i][j+2] & GrnPixels[i][j+3] & scan) begin
								ns = PG;
                end
            end
        end

        // Vertical check
        for (int j = 1; j < 16; j++) begin
            for (int i = 0; i <= 12; i++) begin
                if (GrnPixels[i][j] & GrnPixels[i+1][j] &
                    GrnPixels[i+2][j] & GrnPixels[i+3][j] & scan) begin
								ns = PG;
                end
            end
        end

        // Diagonal (top-left to bottom-right) check
        for (int i = 0; i <= 12; i++) begin
            for (int j = 1; j <= 12; j++) begin
                if (GrnPixels[i][j] & GrnPixels[i+1][j+1] &
                    GrnPixels[i+2][j+2] & GrnPixels[i+3][j+3] & scan) begin
								ns = PG;
                end
            end
        end

        // Diagonal (bottom-left to top-right) check
        for (int i = 3; i < 16; i++) begin
            for (int j = 1; j <= 12; j++) begin
                if (GrnPixels[i][j] & GrnPixels[i-1][j+1] &
                    GrnPixels[i-2][j+2] & GrnPixels[i-3][j+3] & scan) begin
								ns = PG;
                end
            end
        end
		  
	// check Red
        // Horizontal check
        for (int i = 0; i < 16; i++) begin
            for (int j = 1; j <= 12; j++) begin
                if (RedPixels[i][j] & RedPixels[i][j+1] &
                    RedPixels[i][j+2] & RedPixels[i][j+3] & scan) begin
								ns = PR;
                end
            end
        end

        // Vertical check
        for (int j = 1; j < 16; j++) begin
            for (int i = 0; i <= 12; i++) begin
                if (RedPixels[i][j] & RedPixels[i+1][j] &
                    RedPixels[i+2][j] & RedPixels[i+3][j] & scan) begin
								ns = PR;
                end
            end
        end

        // Diagonal (top-left to bottom-right) check
        for (int i = 0; i <= 12; i++) begin
            for (int j = 1; j <= 12; j++) begin
                if (RedPixels[i][j] & RedPixels[i+1][j+1] &
                    RedPixels[i+2][j+2] & RedPixels[i+3][j+3] & scan) begin
								ns = PR;
                end
            end
        end

        // Diagonal (bottom-left to top-right) check
        for (int i = 3; i < 16; i++) begin
            for (int j = 1; j <= 12; j++) begin
                if (RedPixels[i][j] & RedPixels[i-1][j+1] &
                    RedPixels[i-2][j+2] & RedPixels[i-3][j+3] & scan) begin
								ns = PR;
                end
            end
        end
	end
		  PR: ns = PR;
		  
		  PG: ns = PG;
		  
		  default: ns = none;
		 
	endcase
    end
	
	
	
	always_ff @(posedge clk) begin
		if(ps == none & ns == PG) begin
			scoreG <= scoreG + 1;
		end
		else if(ps == none & ns == PR) begin
			scoreR <= scoreR + 1;
		end
		else begin
			scoreG <= scoreG;
			scoreR <= scoreR;
		end
		
		if(RST) begin
			scoreG <= 3'b000;
			scoreR <= 3'b000;
			ps <= none;
			nextRound <= 0;
			player <= 1;
		end
		else if(nextRound) begin
			ps <= none;
			nextRound <= 0;
		end
		else
			ps <= ns;
		
		if(ps == PG | ps == PR)
			nextRound <= 1;
		else
			nextRound <= 0;
			
		if(turn) player <= ~player;
		
		if(scoreG == 3'b101 | scoreR == 3'b101) begin
			scoreG <= 3'b000;
			scoreR <= 3'b000;
		end
	end
	
endmodule


module gameControl_testbench();
	logic 					clk, RST, turn;
	logic [15:0][15:0] 	RedPixels, GrnPixels;
	logic 					player, nextRound;
	logic [2:0] 			scoreG, scoreR;
	
	gameControl dut (.clk, .RST, .player, .RedPixels, .GrnPixels, .turn, .scoreG, .scoreR, .nextRound);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
	RST  <= 1;  							 																   	 @(posedge clk);
	RST  <= 0;  									                                             	 @(posedge clk);
	turn <= 1; RedPixels[00][01] <= 1; RedPixels[00][02] <= 1; RedPixels[00][03] <= 1;		 @(posedge clk);
	turn <= 0; RedPixels[00][04] <= 1;	                            							 	 @(posedge clk);
																									repeat(100)		 @(posedge clk);
		turn <= 1; RedPixels[00][01] <= 1; RedPixels[00][02] <= 1; RedPixels[00][03] <= 1;   @(posedge clk);
	turn <= 0; RedPixels[00][04] <= 1;	                            								 @(posedge clk);
																									repeat(100) 	 @(posedge clk);
		turn <= 1; RedPixels[00][01] <= 1; RedPixels[00][02] <= 1; RedPixels[00][03] <= 1;	 @(posedge clk);
	turn <= 0; RedPixels[00][04] <= 1;	                            								 @(posedge clk);
																									repeat(100)		 @(posedge clk);
		turn <= 1; RedPixels[00][01] <= 1; RedPixels[00][02] <= 1; RedPixels[00][03] <= 1;	 @(posedge clk);
	turn <= 0; RedPixels[00][04] <= 1;	                            								 @(posedge clk);
																									repeat(100)		 @(posedge clk);
		turn <= 1; RedPixels[00][01] <= 1; RedPixels[00][02] <= 1; RedPixels[00][03] <= 1;	 @(posedge clk);
	turn <= 0; RedPixels[00][04] <= 1;	                            								 @(posedge clk);
																									repeat(100)		 @(posedge clk);
		turn <= 1; RedPixels[00][01] <= 1; RedPixels[00][02] <= 1; RedPixels[00][03] <= 1;	 @(posedge clk);
	turn <= 0; RedPixels[00][04] <= 1;	                           								 @(posedge clk);
																									repeat(100)		 @(posedge clk);
	turn <= 1;										 																 @(posedge clk);
	turn <= 0;	                            																 @(posedge clk);
	turn <= 1;																										 @(posedge clk);
	turn <= 0;	                            																 @(posedge clk);
	turn <= 1;										 																 @(posedge clk);
	turn <= 0;	                            																 @(posedge clk);
	turn <= 1;										 																 @(posedge clk);
	 
		$stop;
	end
endmodule