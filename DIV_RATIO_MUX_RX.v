module DIV_RATIO_MUX_RX #(parameter PRESCALER_WIDTH= 5)
(
input      [PRESCALER_WIDTH-1:0] prescale,
output reg [3:0]                 DIV_RATIO_RX
);


always@(*)begin
	case(prescale)
	'd32:DIV_RATIO_RX='d1;
	'd16:DIV_RATIO_RX='d2;
	'd8:DIV_RATIO_RX='d4;
	'd4:DIV_RATIO_RX='d8;
	endcase
end

endmodule