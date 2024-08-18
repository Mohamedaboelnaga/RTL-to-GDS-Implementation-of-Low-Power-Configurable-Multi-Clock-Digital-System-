module mux(
input [1:0] mux_sel,
input       ser_data,
input       par_bit,
output reg  Tx
);

// Start and Stop bits are constants either 1 or 0. It will not be a variable from the FSM
localparam start_bit=1'b0;
localparam stop_bit=1'b1;

// The mux_sel cases
localparam start=2'b00;
localparam stop=2'b01;
localparam data=2'b10;
localparam parity=2'b11;


// Mux Operation
always@(*)
begin
     case(mux_sel)
          start:begin
                Tx=start_bit;
                end

          stop: begin
                Tx=stop_bit;
                end

          data: begin
                Tx=ser_data;
                end

          parity:begin
                Tx=par_bit;
                end 

          default:Tx=1'b1; // Idle output for Tx is 1                                                    

     endcase
	
end

endmodule