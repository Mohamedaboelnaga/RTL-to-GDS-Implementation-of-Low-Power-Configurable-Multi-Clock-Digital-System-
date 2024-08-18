module UART_TX_TOP(
input       CLK,
input       RST,
input [7:0] P_DATA,
input       DATA_VALID,
input       PAR_EN,
input       PAR_TYP,
output      TX_OUT,
output      BUSY
);



//internal wires
wire       SER_EN;
wire       SER_DONE;
wire [1:0] MUX_SELECT;
wire       SER_DATA;
wire       PARIY_BIT;
wire       accept_new;
wire       enble_parity_block;

// FSM Intance
TX_FSM My_FSM(
.CLK(CLK),
.RST(RST),
.Data_Valid(DATA_VALID),
.PAR_EN(PAR_EN),
.busy(BUSY),
.ser_en(SER_EN),
.ser_done(SER_DONE),
.mux_sel(MUX_SELECT),
.enble_parity_block(enble_parity_block),
.accept_new(accept_new)
);



// Serializer Instance
Serializing My_Serializer(
.CLK(CLK),
.RST(RST),
.ser_en(SER_EN),
.ser_done(SER_DONE),
.ser_data(SER_DATA),
.Data_Valid(DATA_VALID),
.P_DATA(P_DATA),
.accept_new(accept_new)
);



// Parity Instance
Parity_Calc My_parity(
.CLK(CLK),
.RST(RST),
.PAR_EN(PAR_EN),
.PAR_TYP(PAR_TYP),
.enble_parity_block(enble_parity_block)
.Data_Valid(DATA_VALID),
.P_DATA(P_DATA),
.par_bit(PARIY_BIT)
);



// Mux Instance
mux My_Mux(
.mux_sel(MUX_SELECT),
.ser_data(SER_DATA),
.par_bit(PARIY_BIT),
.Tx(TX_OUT)
);

endmodule

