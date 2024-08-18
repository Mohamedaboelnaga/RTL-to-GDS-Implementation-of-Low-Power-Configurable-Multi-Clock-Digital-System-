module PULSE_GEN(
input pulse_gen_D,
input CLK,
input RST,
output pulse_gen
);

reg Q1;
reg Q2;

always @(posedge CLK or negedge RST) 
begin
	if (!RST)
	        begin
                 Q1<=1'b0; 
                 Q2<=1'b0;
	        end
	else
	        begin
		         Q1<=pulse_gen_D;
		         Q2<=Q1;
	        end
end




assign pulse_gen=( (~Q2) & Q1 );

endmodule