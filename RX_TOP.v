module RX_TOP #(parameter PRESCALER_WIDTH= 5)
(
input                                CLK,
input                                RST,	
input                                RX_IN,
input [PRESCALER_WIDTH-1:0]          Prescale,
input                                PAR_EN,
input                                PAR_TYP,	
output                               DATA_VALID,
output  [7:0]                        P_DATA,
output                               STP_ERR,
output                               PAR_ERR
);


//Internal Wires
wire  [3:0]     bit_counter;
wire  [3:0]     edge_counter;
wire            edge_bit_counter_enable;
wire            sampling_enable;
wire            sampled_bit;
wire            deser_enable;
wire            par_error;
//wire            par_exist;
wire            par_check_enable;
wire            start_glitch;
wire            strt_glitch_enable;
wire            stop_check_enable;
wire            stop_error;


//Instance

deserializer my_deser(
.CLK(CLK),
.RST(RST),
.deser_en(deser_enable),
.sampled_bit(sampled_bit),
.edge_count(edge_counter),
.prescaler(Prescale),
.parallel_data(P_DATA)
);



Stop_Check my_stp_chk(
.CLK(CLK),
.RST(RST),
.stp_chk_en(stop_check_enable),
.sampled_bit(sampled_bit),
.stp_err(STP_ERR)
);



parity_cheker my_par_chk(
.CLK(CLK),
.RST(RST),
.par_typ(PAR_TYP),
.Parallel_Data(P_DATA),
.par_chk_en(par_check_enable),
.sampled_bit(sampled_bit),
.par_err(PAR_ERR)
);



strt_Check my_strt_chk(
.CLK(CLK),
.RST(RST),
.strt_chk_en(strt_glitch_enable),
.sampled_bit(sampled_bit),
.strt_glitch(start_glitch)
);



edge_bit_counter #(.PRESCALER_WIDTH(PRESCALER_WIDTH)) my_edge_bit_cnt(
.CLK(CLK),
.RST(RST),
.enable(edge_bit_counter_enable),
.prescaler(Prescale),
.edge_cnt(edge_counter),
.bit_cnt(bit_counter)		
);




data_sampling  #(.PRESCALER_WIDTH(PRESCALER_WIDTH)) my_dat_smpl(
.CLK(CLK),
.RST(RST),
.input_bit(RX_IN),
.prescalar(Prescale),
.dat_samp_en(sampling_enable),
.edge_cnt(edge_counter),
.sampled_bit(sampled_bit)		
);



 UART_FSM_RX  #(.PRESCALER_WIDTH(PRESCALER_WIDTH)) my_RX_FSM(
 .CLK(CLK),
 .RST(RST),
 .RX_IN(RX_IN),
 .PAR_EN(PAR_EN),
 .bit_count(bit_counter),
 .edge_count(edge_counter),
 .par_error(PAR_ERR),
 .start_glitch(start_glitch),
 .stop_error(STP_ERR),
 .prescalar(Prescale),
 .counter_enable(edge_bit_counter_enable),
 .sampling_enable(sampling_enable),
 .par_check_enable(par_check_enable),
 .stop_check_enable( stop_check_enable),
 .strt_glitch_enable(strt_glitch_enable),
 .de_ser_enable(deser_enable),
 .Data_Valid(DATA_VALID)
 //.par_exist(par_exist)
 );

 endmodule