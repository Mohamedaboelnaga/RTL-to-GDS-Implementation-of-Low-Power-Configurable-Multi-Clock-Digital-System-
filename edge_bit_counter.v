module edge_bit_counter #(parameter PRESCALER_WIDTH= 5)
(
input                       CLK,
input                       RST,
input                       enable,
//input                       par_exist, // a signal from the FSM to determine wheather i have parity or not to detemine the length of  the bit_cnt
input [PRESCALER_WIDTH-1:0] prescaler,
output reg [3:0]            edge_cnt,
output reg [3:0]            bit_cnt
);

wire edge_cnt_done;


// increment the bit_cnt each time this  value is raeched
assign  edge_cnt_done = (edge_cnt==(prescaler-1));




// edge counter...let us begin with presaclar 16...so edge counts from 0 t0 16...16 cycle
always @(posedge CLK or negedge RST)
 begin
	if (!RST) 
	        begin
	                     edge_cnt<='b0;
	        end
	else if (enable)
	         begin
		           if(edge_cnt_done)
		              begin
		              	  edge_cnt=0;
		              end
		           else
		              begin
		              	  edge_cnt=edge_cnt + 1'b1;
		              end  
	         end
	else 
	         begin        // if no enable then counter is 0
	                  	  edge_cnt='b0;
	         end         
end




/* bit counter.....each time the edge_cnt raeches max this bit_cnt is incremented to count the bits in the frame*/
   
always @(posedge CLK or negedge RST)
 begin
	if (!RST) 
	        begin
	                      bit_cnt<='b1;
	        end
	else if (enable)
	         begin
		           if(edge_cnt_done)
		              begin
		              	   bit_cnt=bit_cnt + 1'b1;
		              end              

	         end
	else 
	         begin        // if no enable then counter is 0
	                      bit_cnt<='b1;

	         end         
end

endmodule