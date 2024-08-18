module Stop_Check(
input              CLK,
input              RST,	
input              stp_chk_en,
input              sampled_bit,
output 	 reg       stp_err
);


always @(posedge CLK or negedge RST) 
begin
	if (!RST) 
	       begin
                 stp_err<=1'b0;
	       end
	else if(stp_chk_en)
	       begin 
     // If sampled bit =1 then no error so stp_err = 0 , and if sampled bit=0 then error so stp_error=1	       
		         stp_err<= ~sampled_bit;
	       end
end

endmodule