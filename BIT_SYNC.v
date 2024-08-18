// Parametrized BIT_Synchronizer
//Valid for any number of Fliflops used in the synchronizer and valid for any no. of bits on the data bus
// More Generic


module BIT_SYNC # (parameter NUM_STAGES = 5 , BUS_WIDTH = 5)
(
input                      CLK,
input                      RST,
input      [BUS_WIDTH-1:0] ASYNC,
output reg [BUS_WIDTH-1:0] SYNC
);


integer bit_no_in_bus; // counter to count no of bits put on the ASYNC input bus
integer ff_no_aka_stage_no; // counter to count no of ff. (no of stages) for each bit 


reg [NUM_STAGES-1:0] Q [BUS_WIDTH-1:0]; // The whole synchronizer acts like a memory its width is the no of stages and its depth 
                                    // is the no of bits in the bus



// Reseting all the registers to zero
always @(posedge CLK or negedge RST) 
begin
	if (!RST) 
	       begin
                for(bit_no_in_bus=0;bit_no_in_bus<BUS_WIDTH;bit_no_in_bus=bit_no_in_bus+1)
                   begin
                   	    Q[bit_no_in_bus]<='d0;
                   end
	       end

	else 
	       begin 
/*This for loop is to give the input bus to the first stage in the flip flop ....according to the number of bits is the bus */	          
                for(bit_no_in_bus=0;bit_no_in_bus<BUS_WIDTH;bit_no_in_bus=bit_no_in_bus+1)
                   begin
                   	    Q[bit_no_in_bus][0]<=ASYNC[bit_no_in_bus];
                   end


/*Here it is a nested loop where i loop on each stage and shift all  the bits by looping on them in the inner loop
to shift the bits to the next stage...and so on*/
                for(ff_no_aka_stage_no=1;ff_no_aka_stage_no<NUM_STAGES;ff_no_aka_stage_no=ff_no_aka_stage_no+1)
                   begin

			                for(bit_no_in_bus=0;bit_no_in_bus<BUS_WIDTH;bit_no_in_bus=bit_no_in_bus+1)
			                   begin
			                   	    Q[bit_no_in_bus][ff_no_aka_stage_no]<=Q[bit_no_in_bus][ff_no_aka_stage_no - 1];
			                   end

                   end

	       end
end



// Now assigning the L.S.B stage for each bit to be the synchronized outputs SYNC
always@(*)
begin
                for(bit_no_in_bus=0;bit_no_in_bus<BUS_WIDTH;bit_no_in_bus=bit_no_in_bus+1)
                   begin
                   	    SYNC[bit_no_in_bus]<=Q[bit_no_in_bus][ff_no_aka_stage_no - 1];
                   end	
end

endmodule