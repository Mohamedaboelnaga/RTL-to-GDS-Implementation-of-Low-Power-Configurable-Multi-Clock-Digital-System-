// Parametrized Reset_Synchronizer
//Valid for any number of Fliflops used in the synchronizer

module RST_SYNC # ( parameter NUM_STAGES = 2)  // here double syncchronizer
(
 input  wire RST,
 input  wire CLK,
 output wire SYNC_RST	// because assign
);

reg [NUM_STAGES-1:0] Q;
integer count;


//This code is for active low asynchronous RESET
always @(posedge CLK or negedge RST)
 begin
	if (!RST)
	    begin
             Q<='d0;    
	    end
	else 
	    begin
		      Q[0] <= 1'b1; // let Q[0] is the most left flipflop
                for(count = 1; count < NUM_STAGES; count = count + 1)
                    begin
                        Q[count] <= Q[count-1];
                    end
	    end
end

assign SYNC_RST = Q[NUM_STAGES-1]; // most right flipflop is the output // This will enter on the RST pin of my module ff

endmodule





// another method ...shift register not for loop


/*
module RST_SYNC # ( parameter NUM_STAGES = 2)  // here double syncchronizer
(
 input  wire RST,
 input  wire CLK,
 output reg SYNC_RST	 // because in always block so reg
);

reg [NUM_STAGES-1:0] Q;
integer count;


//This code is for active low asynchronous RESET
always @(posedge CLK or negedge RST)
 begin
	if (!RST)
	    begin
             Q<='d0;    
	    end
	else 
	    begin
              Q[NUM_STAGES-1]=1'b1;  
              {Q[NUM_STAGES-2:0],SYNC_RST}=Q;    // shift right ...the output is the L.S.B which is SYNC_RST
     
	    end
end

endmodule

*/