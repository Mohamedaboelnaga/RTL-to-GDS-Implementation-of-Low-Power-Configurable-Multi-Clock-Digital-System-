module deserializer #(parameter PRESCALER_WIDTH= 5)
(
input                            CLK,
input                            RST,	
input                            deser_en,
input                            sampled_bit,
input      [3:0]                 edge_count,
input      [PRESCALER_WIDTH-1:0] prescaler,
output reg [7:0]                 parallel_data
);

reg [3:0] counter;


 
always @(posedge CLK or negedge RST) 
begin
	if (!RST) 
	    begin
                          counter<='b0;
                          parallel_data<='b0;
	    end

	else if(deser_en) 
	    begin
	            if(edge_count==(prescaler-1))
	               begin
					     if(counter==8)
					       begin
					                  counter<=0;

					       end
					    else 
					       begin 
					               parallel_data[counter]<=sampled_bit;
					               counter<=counter+1'b1;
					       end  
		          end 
	    end
    else 
        begin
        	              counter='b0;
        end

end

endmodule