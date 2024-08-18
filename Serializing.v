module Serializing(
input        CLK,
input        RST,	
input        ser_en,
input  [7:0] P_DATA,
input        Data_Valid,
input        accept_new,
output reg   ser_done,
output reg   ser_data
);

reg [3:0] counter;
reg [7:0] data_reg;
      


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
                   ser_data<=1'b0;
                   counter<=0;
	end
	else if (Data_Valid&&accept_new) begin
		          data_reg<=P_DATA;
                  counter<=0;
	end
	else if (ser_en) begin
		         ser_data<=data_reg[counter];
                 counter<=counter+1;
	end
end


always@(*)begin
	if(counter==8)begin
		ser_done=1;
	end
	else begin
		ser_done=0;
	end
       
end



endmodule