// This block is responsible for reading from the fifo and generating the rdPtr and rdaddr and generating the empty flag 
//and converting the rd_ptr into grey coded one to go to the write block

module FIFO_WR #(parameter PTR_WIDTH=4)
(
 input                      wclk,        // write clk
 input                      wrst_n,      // write asynchronous reset
 input                      winc,        // to increment the write pointer
 input                      rinc,        // special case to not make full high during reading 
 input      [PTR_WIDTH-1:0] synced_rd_ptr, // read ptr coming from the synchronizer that is already gray coded from the read block 
 output reg [PTR_WIDTH-1:0] wptr_grey,   // write ptr gray_coded going out to the write block
 output     [PTR_WIDTH-2:0] waddr,       // write address which is  part of WrPtr
 output                     wfull        // full flag to know when the FIFO is full
);

//wire wfull;

// this is the Write pointer that will be incremented on the FIFO
reg [PTR_WIDTH-1:0] Wr_ptr;



//Normal operation : incrementing the WrPtr once winc comes and full is low
always @(posedge wclk or negedge wrst_n)
begin
	if (!wrst_n) 
	    begin
             Wr_ptr<='b0;
	    end
	else if (!wfull && winc) 
	    begin
		     Wr_ptr<=Wr_ptr + 1'b1;
	    end
end 


//OUTPUTS


//Converting the write pointer into grey coded form to go to the read block
always @(*)
begin
	    begin
             case(Wr_ptr)
                 4'b0000:wptr_grey<=4'b0000;
                 4'b0001:wptr_grey<=4'b0001;
                 4'b0010:wptr_grey<=4'b0011;
                 4'b0011:wptr_grey<=4'b0010;
                 4'b0100:wptr_grey<=4'b0110;
                 4'b0101:wptr_grey<=4'b0111;
                 4'b0110:wptr_grey<=4'b0101;
                 4'b0111:wptr_grey<=4'b0100;
                 4'b1000:wptr_grey<=4'b1100;
                 4'b1001:wptr_grey<=4'b1101;
                 4'b1010:wptr_grey<=4'b1111;
                 4'b1011:wptr_grey<=4'b1110;
                 4'b1100:wptr_grey<=4'b1010;
                 4'b1101:wptr_grey<=4'b1011;
                 4'b1110:wptr_grey<=4'b1001;
                 4'b1111:wptr_grey<=4'b1000;
             endcase
	    end  
end 


//write address is defined as the same as WrPtr except last bit
/*we added this extra bit as we discussed in the paper to be able to diffrentiate between
empty condition and full condition*/
assign waddr = Wr_ptr[PTR_WIDTH-2:0];


//Full Conditon

/*On observing the wr_ptr after converting it to grey...it was found that the L.S.B 2 bits are the same if the ptr iterates a 
complete cycle over the FIFO,which ,means that the FIFO is full....so we will compare the gray read pointer coming
from the read block with the write grey pointer...if the least 2 bits are the same and the last 2 bits are different
then this means a complete cylce over the fifo  is done and the fifo is full */

/*always@(*)
       begin
           if(rinc) wfull=0;
           else     wfull = ( {~wptr_grey[PTR_WIDTH-1],~wptr_grey[PTR_WIDTH-2],wptr_grey[PTR_WIDTH-3:0]} == synced_rd_ptr );
       end*/
assign wfull = ( {~wptr_grey[PTR_WIDTH-1],~wptr_grey[PTR_WIDTH-2],wptr_grey[PTR_WIDTH-3:0]} == synced_rd_ptr );

//Normal operation : incrementing the WrPtr once winc comes and full is low
/*
always @(posedge wclk or negedge wrst_n)
begin
    if (!wrst_n) 
        begin
             full<='b0;
        end
    else  
        begin
             full<=wfull;
        end
end*/
endmodule