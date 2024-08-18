module data_sampling #(parameter PRESCALER_WIDTH= 5)
(
input                       CLK,
input                       RST,
input                       input_bit,
input [PRESCALER_WIDTH-1:0] prescalar,
input                       dat_samp_en,
input [3:0]                 edge_cnt,
output reg                  sampled_bit	
);

// we will work now on prescaler 16 so i want the middle 3 samples which are samples 7,8,9
wire [4:0] sample_half,sample_bef_half,sample_aft_half;

assign sample_half= (prescalar>>1 ); // 8
assign sample_bef_half= sample_half - 1;  // 7
assign sample_aft_half= sample_half + 1; // 9


// to store the samples according to the edge_cnt_value
reg [2:0] samples ;


//sampling the 3 middle bits
always @(posedge CLK or negedge RST) 
begin 
	if (!RST) 
	    begin
             samples<='b0;
	    end
    else if (dat_samp_en)
        begin
			 if(edge_cnt==sample_bef_half) 
			    begin
				     samples[0]<=input_bit;
			    end

			else if(edge_cnt==sample_half) 
			    begin
				     samples[1]<=input_bit;
			    end

			else if(edge_cnt==sample_aft_half) 
			    begin
				     samples[2]<=input_bit;
			    end
	    end	
   else
        begin
                     samples<='b0;          	
        end

end




// decision based on majority concept
always @(posedge CLK or negedge RST) 
begin
	if (!RST) 
	    begin
             sampled_bit<='b0;
	    end
	else if(dat_samp_en) 	
	    begin
	         case(samples)
	              3'b000:sampled_bit<=1'b0;
	              3'b001:sampled_bit<=1'b0;
	              3'b010:sampled_bit<=1'b0;
	              3'b011:sampled_bit<=1'b1;
	              3'b100:sampled_bit<=1'b0;
	              3'b101:sampled_bit<=1'b1;
	              3'b110:sampled_bit<=1'b1;
	              3'b111:sampled_bit<=1'b1;	              	              	              	              	              	              	              
	         endcase	
	    end 
	else 
	    begin
             sampled_bit<='b0;	           	
	    end       

end 
endmodule