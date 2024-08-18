module strt_Check(
input              CLK,
input              RST,	
input              strt_chk_en,
input              sampled_bit,
output 	 reg       strt_glitch  // error

);


// I want to check that when iam at start state the bit sent in the frame is a real zero
// and not a glitch...glitch means it dropped to zero and then back to one
//so I want to check that this bit is zero for a complete cycle to be sure that this is a start bit
always @(posedge CLK or negedge RST) 
begin
	if (!RST) 
	       begin
                 strt_glitch<=1'b0;
	       end
	else if(strt_chk_en)
	       begin 
     // If sampled bit =0 then no error so strt_glitch = 0 ,
     // and if sampled bit=1 then error so strt_glitch=1	       
		         strt_glitch<= sampled_bit;
	       end
end

endmodule