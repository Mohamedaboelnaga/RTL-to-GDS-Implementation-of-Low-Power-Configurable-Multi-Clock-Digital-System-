module DATA_SYNC #(parameter BUS_WIDTH = 8, parameter NUM_STAGES = 2)
(
 input  wire                   CLK,
 input  wire                   RST,
 input  wire                   bus_enable,
 input  wire [BUS_WIDTH-1 : 0] unsync_bus,
 output reg  [BUS_WIDTH-1 : 0] sync_bus,
 output reg                    enable_pulse	
);

wire                 bit_sync_out;
wire                 pulse_gen_out;
reg [BUS_WIDTH-1:0]  D_OF_SYNC_BUS;


//Instance of bit synchronizer and pulse_generator
BIT_SYNC #( .NUM_STAGES(NUM_STAGES) , .BUS_WIDTH(1) ) my_bit_sync // bus width =1 becaue the input
//signal to the synchronzier is an enbale signal not  a bus of bits
(
.CLK(CLK),
.RST(RST),
.ASYNC(bus_enable),
.SYNC(bit_sync_out)
);



PULSE_GEN my_pulse_gen(
.CLK(CLK),
.RST(RST),
.pulse_gen_D(bit_sync_out),
.pulse_gen(pulse_gen_out)	
);


// flip flop of enable_pulse

always @(posedge CLK or negedge RST) 
begin
	if (!RST)
	        begin
                 enable_pulse<='b0; 
	        end
	else
	        begin
		         enable_pulse<=pulse_gen_out;
	        end
end



// flip flop of sync_bus

always @(posedge CLK or negedge RST) 
begin
	if (!RST)
	        begin
                 sync_bus<='b0; 
	        end
	else
	        begin
		         sync_bus<=D_OF_SYNC_BUS;
	        end
end



// mux before the sync_bus ff

always@(*)
begin
	 if(pulse_gen_out)
	   begin
	   	    D_OF_SYNC_BUS=unsync_bus;	   	   
	   end


	 else 
	   begin
	  	    D_OF_SYNC_BUS=sync_bus;
	   end
end

endmodule