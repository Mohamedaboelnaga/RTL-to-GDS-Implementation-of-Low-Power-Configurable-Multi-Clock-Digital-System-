module Register_File #(parameter  ADDR_WIDTH = 4, parameter MEM_DEPTH =16 ,parameter MEM_WIDTH=8)
(
input                       CLK,RST,	
input                       WrEn,RdEn,
input      [ADDR_WIDTH-1:0] Address,
input      [MEM_WIDTH-1: 0] WrData,
output reg [MEM_WIDTH-1: 0] RdData,   
output reg                  RdData_Valid,
output     [MEM_WIDTH-1: 0] REG0,
output     [MEM_WIDTH-1: 0] REG1,
output     [MEM_WIDTH-1: 0] REG2,
output     [MEM_WIDTH-1: 0] REG3
);


integer i;

 //Memory
 reg [MEM_WIDTH-1:0] REG [MEM_DEPTH-1:0];        //  reg [15:0] memory [7:0]; 

                                                    // 16 registers each one is 8 bit width 

 always @(posedge CLK or negedge RST) begin
 	if (!RST)
         begin
           	 RdData_Valid<=1'b0;
             RdData='b0;

             for(i=0;i<MEM_DEPTH;i=i+1) // reset and intialize registers
                begin
                     if(i==2)      REG[i]='b010000_01; // initialization of uart confoguration ....bit 0 is par_en bit 1 is par type
                                                       // last 6 bits are prescale value....here enable =1 , eben parity=0 , prescale=16
                     else if(i==3) REG[i]='b0010_0000; //DIV_RATIO for UART_TX clk divider =32 

                     else          REG[i]='b0; // reset the registers                              
                end
 	   end

 	else if (WrEn&&!RdEn)  // write
         begin
 	      	REG[Address] <= WrData;
 	      end

 	else if(RdEn&&!WrEn)  //read
         begin
 	        RdData<=REG[Address];
           RdData_Valid=1'b1; // to make sure that the read data is valid
 	      end
   else 
         begin
            RdData_Valid=1'b0;      
         end   
 end


 // Ootputs registers to feed another blocks
 assign REG0 = REG[0]; // Operand A for ALU
 assign REG1 = REG[1]; // Operand B for ALU
 assign REG2 = REG[2]; // UART Config
 assign REG3 = REG[3]; // DIV_RATIO for UART_TX clk divider

 endmodule