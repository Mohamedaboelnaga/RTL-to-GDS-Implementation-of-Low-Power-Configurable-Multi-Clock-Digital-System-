module parity_cheker(
input       CLK,
input       RST,
input [7:0] Parallel_Data,
input       par_typ,
input       par_chk_en,
input       sampled_bit,
output reg  par_err	
);

reg parity;


// Fisrt do the same parity check here at the receiver
always@(*)
begin
	if(par_typ==0)
               begin
                 parity= ^Parallel_Data;  // even parity
               end

    else 
               begin
                  parity= ~^Parallel_Data; // odd parity
               end  
end



//now compare the parity calculated here with the parity coming in the frame from receiver
always @(posedge CLK or negedge RST)
 begin
	if (!RST) 
	         begin
                  par_err<=1'b0;
	         end
	else if (par_chk_en) 
	// I want to compare the sampled bit with the parity I generated here , if equal then 
	// no error so par_error is zero...so this is a xor operation.
	          begin
		          par_err=parity ^ sampled_bit;
	          end
end

endmodule