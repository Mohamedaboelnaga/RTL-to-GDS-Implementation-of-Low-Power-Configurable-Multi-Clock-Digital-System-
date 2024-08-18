module CLK_Divider #(parameter DIV_RATIO=4)
(
input                    i_ref_clk,
input                    i_rst_n,
input                    i_clk_en,
input  [DIV_RATIO-1:0]   i_div_ratio,
output                   o_div_clk 
);

reg  [2:0]  counter;
wire [3:0] before_toggle;
wire [3:0] before_toggle_plus1;
wire       odd;
reg        o_div;
 
// To allow the clk in the odd case to toggle in 2 different times on when counter reaches before_toggle and when reaches before_toggle_plus1
reg flag;

//You have to check I_div_ratio not equals Zero or One before 
//enable the clock divider
assign Clk_DIV_EN = i_clk_en && ( i_div_ratio != 0) && ( i_div_ratio != 1);


//The number of clk cycles should be maintained before toggling for even div_ratio
assign before_toggle=(i_div_ratio>>1);

//The number of clk cycles should be maintained before toggling for odd div_ratio
assign before_toggle_plus1=(i_div_ratio>>1)+1;


// If this bit is zero then I am even else Iam odd
assign odd=i_div_ratio[0];



// Imp Note
//counter begins from 1 because iam working sequential so beginning from 0 delays me a clock cycle because the check on the value of the counter is in clk and 
//  te counter takes its value in the next clk


// mel a5r e7na byegy el clock edge t2om el always block m3molha triggering... kol clk had5ol case mn el 3 ya2ma even ya 2ma odd ya 2ma azwd el counter
// fanta msln law d5lt el case bta3t counter = counter + 1 w 5let elcounter  2... el check 3leh hyb2a fe el clk ele b3do msh nfs el  clk fa kda bt25r cycle
// 3shan kda bd2na el clk mn 1

always @(posedge i_ref_clk or negedge i_rst_n)
 begin
	if (!i_rst_n)
	   begin
           o_div<=1'b0;
           counter<=1;
           flag=1'b1;
	   end
	else if (Clk_DIV_EN)
	   begin
	        // for even
		    if(!odd &&counter==before_toggle)
		       begin
		    	   o_div<= ~o_div;  
		    	   counter<=1;
		       end
		    // for odd  
		    else if( (counter==before_toggle  && odd&& !flag) || (counter==before_toggle_plus1 && odd&& flag) ) 
		       begin
		    	   o_div<= ~o_div;  
		    	   counter<=1;	 
		    	   flag=~flag;   	   
		       end
		    else
		        begin
                   counter<=counter+1;
		        end
	   end
	//else 
	 //   begin
	//	  o_div_clk<=i_ref_clk;
		//  counter<=1;
	   // end
end



// if this enable is low then output clk is same as input clk
assign o_div_clk = Clk_DIV_EN  ? o_div : i_ref_clk;

endmodule