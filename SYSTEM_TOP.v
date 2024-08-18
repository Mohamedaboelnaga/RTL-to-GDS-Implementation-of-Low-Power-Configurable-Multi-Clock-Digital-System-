module SYSTEM_TOP #(parameter PRESCALER_WIDTH= 6 , DATA_WIDTH=8 , ADDR_WIDTH=4)
(
input                                REF_CLK,
input                                UART_CLK,
input                                RST,
input                                RX_IN,
output                               TX_OUT,
output                               PAR_ERR,
output                               STP_ERR
);

//internal wires

//Clocks and Resets
wire                    RST_sync_1;
wire                    RST_sync_2;
wire                    CLK_TX;
wire                    CLK_RX;
wire                    ALU_CLK;

//Rx and data synchronizer ins and outs
wire                    data_valid_from_RX; // valid signal out from RX input to data_sync
wire [DATA_WIDTH-1:0]   P_DATA_RX;          // parallel data out from RX input to data_sync
wire [DATA_WIDTH-1:0]   synced_P_DATA;      // synced parallel data out from data_syncinput to sys_ctrl
wire                    valid_RX_SYNCED;    // synced valid pulse signal out from data_sync input to sys_ctrl


//Interface between SYS_CTRL and both ALU and REG_FILE
wire [DATA_WIDTH-1:0]   write_data_reg_file;
wire [ADDR_WIDTH-1:0]   write_addr_reg_file;
wire                    write_enable_reg_file;
wire                    read_enable_reg_file;
wire [DATA_WIDTH-1:0]   read_data_from_reg_file;
wire                    data_valid_from_reg_file;
wire [2*DATA_WIDTH-1:0] ALU_RESULT;
wire [3:0]              ALU_FUNC;
wire                    ALU_EN;
wire                    ALU_Result_Valid;

//Special Registers in REG_FILE
wire  [DATA_WIDTH-1:0]  A;     //operand A  
wire  [DATA_WIDTH-1:0]  B;     //operand B  
wire  [DATA_WIDTH-1:0]  REG2;  // uart config register    
wire  [DATA_WIDTH-1:0]  REG3;  // div_ratio value register for tx_clk_div


//Interface between FIFO and SYS_CTRL  &&  FIFO and TX and PULSE_GEN   
wire                    full_fifo;
wire                    fifo_empty;    // not this signal goes as data_valid for input on TX
wire                    write_inc_fifo;
wire  [DATA_WIDTH-1:0]  write_data_fifo;
wire  [DATA_WIDTH-1:0]  read_data_fifo; // data written in fifo goes on TX input parallel bus
wire                    rd_inc_fifo_from_pulse_gen; // output of pulse gen and goes as input to fifo acts as RD_INC
wire                    busy_out_to_pulse_gen;      // busy signal passes by pulse_gen to convert it to pulse to incremant read address only once


//CLK GATE and CLK DIV
wire                    CLK_DIV_EN;
wire                    CLK_GATE_EN;
wire [3:0]              DIV_RATIO_for_RX_clk_div;




//Instance of Modules

RST_SYNC # ( .NUM_STAGES(2))  my_rst_sync1
(
.RST(RST),
.CLK(REF_CLK),
.SYNC_RST(RST_sync_1)
);


RST_SYNC # (.NUM_STAGES(2))  my_rst_sync2
(
.RST(RST),
.CLK(UART_CLK),
.SYNC_RST(RST_sync_2)
);



DATA_SYNC #( .BUS_WIDTH(DATA_WIDTH) , .NUM_STAGES(2) ) MY_DATA_SYNC
(
.CLK(REF_CLK),
.RST(RST_sync_1),
.bus_enable(data_valid_from_RX),
.unsync_bus(P_DATA_RX),
.sync_bus(synced_P_DATA),
.enable_pulse(valid_RX_SYNCED)	
);



UART_TOP #( .PRESCALER_WIDTH(PRESCALER_WIDTH) ) MY_UART
(
.RST(RST_sync_2),
.CLK_TX(CLK_TX),
.CLK_RX(CLK_RX),
.RX_IN(RX_IN),
.Data_Valid_TX(!fifo_empty), // when empty is low...data valid TX is high...means there is valid parallel data in fifo so take iin TX
.PAR_EN(REG2[0]),
.PAR_TYP(REG2[1]),
.Prescale(REG2[7:2]), //those past 3 lines are the uart config taken from REG2 from register file 
.P_DATA_TX(read_data_fifo), // data written in fifo goes on TX input parallel bus
.Data_valid_RX(data_valid_from_RX),
.TX_OUT(TX_OUT),
.busy(busy_out_to_pulse_gen),
.P_DATA_RX(P_DATA_RX),
.STP_ERR(STP_ERR),
.PAR_ERR(PAR_ERR)  // output ports
);


SYS_CTRL  #( .DATA_WIDTH(DATA_WIDTH) , .ADDR_WIDTH(ADDR_WIDTH) , .FUN_WIDTH(4) ) MY_SYS_CTRL
(
.CLK(REF_CLK),
.RST(RST_sync_1),
.RX_P_DATA(synced_P_DATA),
.RX_D_VLD(valid_RX_SYNCED),
.RD_DATA_REGF(read_data_from_reg_file),
.RD_D_VLD_REGF(data_valid_from_reg_file),
.ALU_OUT(ALU_RESULT),
.ALU_OUT_VLD(ALU_Result_Valid),
.WR_EN_REGF(write_enable_reg_file),
.RD_EN_REGF(read_enable_reg_file),
.ADDR_REGF(write_addr_reg_file),
.WR_DATA_REGF(write_data_reg_file),
.ALU_FUN(ALU_FUNC),
.ALU_EN(ALU_EN),
.FIFO_FULL(full_fifo),
.WR_DATA_FIFO(write_data_fifo),
.WR_INC_FIFO(write_inc_fifo),
.Gate_EN(CLK_GATE_EN),
.CLK_DIV_EN(CLK_DIV_EN)
);


 Register_File #( .ADDR_WIDTH(ADDR_WIDTH), .MEM_DEPTH(16) ,.MEM_WIDTH(DATA_WIDTH) ) my_REG_FILE
 (
.CLK(REF_CLK),
.RST(RST_sync_1),
.WrEn(write_enable_reg_file),
.RdEn(read_enable_reg_file),
.Address(write_addr_reg_file),
.WrData(write_data_reg_file),
.RdData(read_data_from_reg_file),
.RdData_Valid(data_valid_from_reg_file),
.REG0(A),
.REG1(B),
.REG2(REG2), // uart config
.REG3(REG3)
 );


 ALU_temsah #( .OPER_WIDTH(DATA_WIDTH), .OUT_WIDTH(2*DATA_WIDTH) ) my_ALU
 (
.CLK(ALU_CLK), // clk gated 
.RST(RST_sync_1),
.EN(ALU_EN),
.A(A),
.B(B),
.ALU_FUN(ALU_FUNC),
.ALU_OUT(ALU_RESULT),
.OUT_VALID(ALU_Result_Valid)
 );


ASYNC_FIFO # (.FIFO_WIDTH(DATA_WIDTH), .PTR_WIDTH(ADDR_WIDTH),  .FIFO_DEPTH(8) ) my_FIFO
(
.W_CLK(REF_CLK),
.W_RST(RST_sync_1),
.W_INC(write_inc_fifo),
.R_CLK(CLK_TX), // read with TX clock frequency
.R_RST(RST_sync_2),
.R_INC(rd_inc_fifo_from_pulse_gen),
.WR_DATA(write_data_fifo),
.RD_DATA(read_data_fifo), // data out from fifo input to parallel data on TX
.FULL(full_fifo),
.EMPTY(fifo_empty)
);



PULSE_GEN my_pulse_gen(
.pulse_gen_D(busy_out_to_pulse_gen),
.CLK(CLK_TX),
.RST(RST_sync_2),
.pulse_gen(rd_inc_fifo_from_pulse_gen)
);


//A mux to take the prescale from RX and return the DIV_RATIO for its clk divider
DIV_RATIO_MUX_RX #(.PRESCALER_WIDTH(PRESCALER_WIDTH) ) my_DIV_RATIO_MUX_RX
(
.prescale(REG2[7:2]),   //prescale value in uart config register
.DIV_RATIO_RX(DIV_RATIO_for_RX_clk_div)
);



CLK_Divider  #(.DIV_RATIO(4)) my_clk_div_RX
(
.i_ref_clk(UART_CLK),
.i_rst_n(RST_sync_2),
.i_clk_en(CLK_DIV_EN),
.i_div_ratio(DIV_RATIO_for_RX_clk_div),   // taken from the prescale       
.o_div_clk(CLK_RX)
);


CLK_Divider #(.DIV_RATIO(8))  my_clk_div_TX
(
.i_ref_clk(UART_CLK),
.i_rst_n(RST_sync_2),
.i_clk_en(CLK_DIV_EN),
.i_div_ratio(REG3),        // div_ratio value register for tx
.o_div_clk(CLK_TX)
);


CLK_GATE my_clk_gate(
.CLK_EN(CLK_GATE_EN), // from sts_crtl
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)  // to ALU
);

 endmodule