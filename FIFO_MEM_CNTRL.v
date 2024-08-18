module FIFO_MEM_CNTRL # (parameter FIFO_WIDTH=8, PTR_WIDTH=4, FIFO_DEPTH=8)
(
input                   wclk,   // write clk
input                   wrst_n, // write asynchronous reset
input                   rclk,
input                   r_rst_n,
input                   winc,   //Enable condition   
input                   wfull,  //of the FIFO
input                   rinc,
input                   rempty,
input  [FIFO_WIDTH-1:0] wdata,  // write data bus
input  [PTR_WIDTH-2:0]  waddr,  // write address      //  the minus 2 because size of addr less than ptr size by 1
input  [PTR_WIDTH-2:0]  raddr,  // read address
output [FIFO_WIDTH-1:0] rdata	// read data bus 
);


// FIFO_MEMORY
reg [FIFO_WIDTH-1:0] FIFO_MEM [FIFO_DEPTH-1:0] ;

// counter to loop on FIFO_DEPTH to reset it
reg [FIFO_DEPTH-1:0] counter;


// reseting and write operation
always @(posedge wclk or negedge wrst_n)
 begin
 	if (!wrst_n)
 	      begin
               for(counter=0;counter<FIFO_DEPTH;counter=counter+1)
                   begin
                   	    FIFO_MEM[counter]<='b0;
                   end
 	      end
 	else if (winc&&!wfull)  // enable of the FIFO 
 	      begin
 		                FIFO_MEM[waddr]<=wdata; // this address is before the ptr increments
 	      end

    /*else if (rinc&&!rempty)  // enable of the FIFO 
          begin
                        rdata<=FIFO_MEM[raddr]; // this address is before the ptr increments
          end   */       
 end 


 assign rdata=FIFO_MEM[raddr];



/*
always @(posedge rclk or negedge r_rst_n )
 begin
      if(!r_rst_n)
         begin
              rdata<=0;
         end
      else if (rinc&&!rempty)  // enable of the FIFO 
         begin
              rdata<=FIFO_MEM[raddr]; // this address is before the ptr increments
         end          
 end 
*/


 /*reading from memory : not related to the clk once there is a data in the
 read address we can read it but on condition that the empty flag is low*/


 endmodule

