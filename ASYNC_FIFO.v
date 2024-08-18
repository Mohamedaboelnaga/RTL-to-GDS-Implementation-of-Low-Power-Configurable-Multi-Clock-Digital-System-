//Top Module 

module ASYNC_FIFO # (parameter FIFO_WIDTH=8, PTR_WIDTH=4, FIFO_DEPTH=8)
(
input                    W_CLK,
input                    W_RST,
input                    W_INC,
input                    R_CLK,
input                    R_RST,
input                    R_INC,
input  [FIFO_WIDTH-1:0]  WR_DATA,
output [FIFO_WIDTH-1:0]  RD_DATA, 
output                   FULL,
output                   EMPTY
);


//Syhcnronizer signals
wire [PTR_WIDTH-1:0] wptr_grey_not_synced;
wire [PTR_WIDTH-1:0] Wr_to_Rd_grey_sync_ptr;
wire [PTR_WIDTH-1:0] rptr_grey_not_synced;
wire [PTR_WIDTH-1:0] Rd_to_Wr_grey_sync_ptr;

//read and write addresses outputs of read and write blocks and input to the FIFO_MEM
wire [PTR_WIDTH-2:0] read_address;
wire [PTR_WIDTH-2:0] write_address;



//Instance of Double ff Synchronizer and number of bits equal to the pointer width
//This is a sync 2 ff to then read domain so must click and reset of read domain
BIT_SYNC #( .NUM_STAGES(2) , .BUS_WIDTH(PTR_WIDTH) ) Wr_to_Rd_sync
(
.CLK(R_CLK),
.RST(R_RST),
.ASYNC(wptr_grey_not_synced),
.SYNC(Wr_to_Rd_grey_sync_ptr)	
);



//Instance of Double ff Synchronizer and number of bits equal to the pointer width
//This is a sync 2 ff to then write domain so must click and reset of write domain
BIT_SYNC #( .NUM_STAGES(2) , .BUS_WIDTH(PTR_WIDTH) ) Rd_to_Wr_sync
(
.CLK(W_CLK),
.RST(W_RST),
.ASYNC(rptr_grey_not_synced),
.SYNC(Rd_to_Wr_grey_sync_ptr)	
);


//Instance of FIFO MEMORY
FIFO_MEM_CNTRL #( .FIFO_WIDTH(FIFO_WIDTH) , .PTR_WIDTH(PTR_WIDTH) , .FIFO_DEPTH(FIFO_DEPTH) ) My_FIFO_MEM 
(
.wclk(W_CLK),
.wrst_n(W_RST),
//.rclk(R_CLK),
//.r_rst_n(R_RST),
.winc(W_INC),
.wfull(FULL),
.rinc(R_INC),
.rempty(EMPTY),
.wdata(WR_DATA),
.waddr(write_address),
.raddr(read_address),
.rdata(RD_DATA)
);


//Instance of FIFO_READ block
FIFO_RD # (.PTR_WIDTH(PTR_WIDTH)) MY_FIFO_RD
(
.rclk(R_CLK),
.rrst_n(R_RST),
.rinc(R_INC),
.winc(W_INC),
.synced_wr_ptr(Wr_to_Rd_grey_sync_ptr),
.rptr_grey(rptr_grey_not_synced),
.raddr(read_address),
.rempty(EMPTY)
);


//Instance of FIFO_WRITE block
FIFO_WR # (.PTR_WIDTH(PTR_WIDTH)) MY_FIFO_WR
(
.wclk(W_CLK),
.wrst_n(W_RST),
.winc(W_INC),
.rinc(R_INC),
.synced_rd_ptr(Rd_to_Wr_grey_sync_ptr),
.wptr_grey(wptr_grey_not_synced),
.waddr(write_address),
.wfull(FULL)
);

endmodule

