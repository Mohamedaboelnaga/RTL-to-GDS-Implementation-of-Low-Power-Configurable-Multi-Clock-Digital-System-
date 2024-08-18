module Parity_Calc(
input       CLK,
input       RST,
input       PAR_EN,	
input [7:0] P_DATA,
input       Data_Valid,
input       enble_parity_block,
input       PAR_TYP,
output reg  par_bit
);

//reg       parity_ready; // to register the parity_bit
reg [7:0] data_ready; // to store the parallel incoming data

/*
//Parity bit is being registered and reseted
always @(posedge CLK or negedge RST) begin
	if (!RST) 
	   begin
         par_bit<=1'b0;
	   end
	else
	   begin
		 par_bit<=parity_ready;
	   end
end   
*/

//Data is being registered and the operation is only if Data_Valid is high
always @(posedge CLK or negedge RST) begin
	if (!RST) 
	   begin
         data_ready<='b0;
	   end
	else if(Data_Valid)
	   begin
		  data_ready<=P_DATA;
	   end
end 



//If PAR_TYP is 0  means even parity
//even parity can be calculated by xoring all the parallel data using reduction operator...the output is the correct parity bit
//If PAR_TYP is 1  means odd parity
//odd parity can be calculated by xnoring all the parallel data using reduction operator...the output is the correct parity bit


/*
// Parity Operation
always @(*) 
  begin
     if(PAR_EN)
        begin
            if(PAR_TYP==0)
               begin
                 par_bit= ^data_ready;  // even parity
               end

            else if(PAR_TYP)
               begin
                  par_bit= ~^data_ready; // odd parity
               end  
        end

      else 
        begin
                  parity_ready=par_bit;      // don't forget that this is a combinatonal always you must put this else to avoid latch 	
         end  

  end
*/


always @(posedge CLK or negedge RST) begin
   if (!RST) begin
         par_bit<=0;
   end

   else
     begin

   if (enble_parity_block)
    begin
    if(PAR_EN)
              begin
                  if(PAR_TYP==0)
                        begin
                          par_bit= ^data_ready;  // even parity
                        end

                     else if(PAR_TYP)
                        begin
                           par_bit= ~^data_ready; // odd parity
                        end  
                 end
      end
      end
end
     
   
end
  endmodule