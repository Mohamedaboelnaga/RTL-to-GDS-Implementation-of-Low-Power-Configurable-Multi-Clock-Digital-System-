

module UART_TOP #(parameter PRESCALER_WIDTH= 5)
(
    input                             RST,   
    input                             CLK_TX, 
    input                             CLK_RX, 
    input                             RX_IN, 
    input                             Data_Valid_TX, 
    input                             PAR_EN,
    input                             PAR_TYP,
    input  [7:0]                      P_DATA_TX, 
    input  [PRESCALER_WIDTH-1:0]      Prescale, 
    output                            Data_valid_RX, 
    output                            TX_OUT, 
    output                            busy,
    output [7:0]                      P_DATA_RX,
    output                            STP_ERR,  // added both signals to output port
    output                            PAR_ERR
);




  //instantiate modules
  UART_TX_TOP my_UART_TX_TOP (
      .P_DATA(P_DATA_TX),
      .DATA_VALID(Data_Valid_TX),
      .PAR_TYP(PAR_TYP),
      .PAR_EN(PAR_EN),
      .CLK(CLK_TX),
      .RST(RST),
      .BUSY(busy),
      .TX_OUT(TX_OUT)
  );



  RX_TOP #(.PRESCALER_WIDTH(PRESCALER_WIDTH)) my_UART_RX_TOP (
      .CLK(CLK_RX),
      .RST(RST),
      .PAR_TYP(PAR_TYP),
      .PAR_EN(PAR_EN),
      .Prescale(Prescale),
      .RX_IN(RX_IN),
      .DATA_VALID(Data_valid_RX),
      .P_DATA(P_DATA_RX),
      .STP_ERR(STP_ERR),
      .PAR_ERR(PAR_ERR)
  );




endmodule
