// This block is responsible for reading from the fifo and generating the rdPtr and rdaddr and generating the empty flag 
//and converting the rd_ptr into grey coded one to go to the write block

module FIFO_RD #(parameter PTR_WIDTH=4)
(
 input                      rclk,        // read clk
 input                      rrst_n,      // read asynchronous reset
 input                      rinc,        // to increment the read pointer 
 input                      winc,        //special case to not make empty high during writing
 input      [PTR_WIDTH-1:0] synced_wr_ptr, // write ptr coming from the synchronizer that is already gray coded from the write block 
 output reg [PTR_WIDTH-1:0] rptr_grey,   // read ptr gray_coded going out to the write block
 output     [PTR_WIDTH-2:0] raddr,       // read address which is  part of rdPtr
 output                      rempty       // empty flag to know when the FIFO is empty
);


// this is the read pointer that will be incremented on the FIFO
reg [PTR_WIDTH-1:0] rd_ptr;



//Normal operation : incrementing the rdPtr once rinc comes and empty is low
always @(posedge rclk or negedge rrst_n)
begin
	if (!rrst_n) 
	    begin
             rd_ptr<='b0;
	    end
	else if (!rempty && rinc) 
	    begin
		     rd_ptr<=rd_ptr + 1'b1;
	    end
end 


//OUTPUTS


//Converting the read pointer into grey coded form to go to the write block
always @(*)
begin 
	    begin
             case(rd_ptr)
                 4'b0000:rptr_grey<=4'b0000;
                 4'b0001:rptr_grey<=4'b0001;
                 4'b0010:rptr_grey<=4'b0011;
                 4'b0011:rptr_grey<=4'b0010;
                 4'b0100:rptr_grey<=4'b0110;
                 4'b0101:rptr_grey<=4'b0111;
                 4'b0110:rptr_grey<=4'b0101;
                 4'b0111:rptr_grey<=4'b0100;
                 4'b1000:rptr_grey<=4'b1100;
                 4'b1001:rptr_grey<=4'b1101;
                 4'b1010:rptr_grey<=4'b1111;
                 4'b1011:rptr_grey<=4'b1110;
                 4'b1100:rptr_grey<=4'b1010;
                 4'b1101:rptr_grey<=4'b1011;
                 4'b1110:rptr_grey<=4'b1001;
                 4'b1111:rptr_grey<=4'b1000;
             endcase
	    end  
end 


//read address is defined as the same as rdPtr except last bit
/*we added this extra bit as we discussed in the paper to be able to diffrentiate between
empty condition and full condition*/
assign raddr = rd_ptr[PTR_WIDTH-2:0];


//Empty Conditon
//If the grey write pointer coming from the write block is equal to the grey read pointer generated
//means that the most bit did not change and all what we wrote has been read so the FIFO is EMPTY
/*always@(*)
begin
	 if(winc)  rempty=0;
	 else      rempty = (synced_wr_ptr==rptr_grey);
end*/ 

assign rempty = (synced_wr_ptr==rptr_grey);
/*always@(posedge rclk or negedge rrst_n)
begin
    if (!rrst_n) 
        begin
             rempty<='b0;
        end
else 
        begin
              if(winc)  rempty<=0;
              else      rempty <= (synced_wr_ptr==rptr_grey);
        end 
end*/
endmodule