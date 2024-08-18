module UART_FSM_RX  #(parameter PRESCALER_WIDTH= 5)
(
input                           CLK,
input                           RST,	
input                           RX_IN,
input                           PAR_EN,
input  [3:0]                    bit_count,
input  [3:0]                    edge_count,
input                           par_error,
input                           start_glitch,
input                           stop_error,
input  [PRESCALER_WIDTH-1:0]    prescalar,
output  reg                     counter_enable,
output  reg                     sampling_enable,
output  reg                     par_check_enable,
output  reg                     stop_check_enable,
output  reg                     strt_glitch_enable,
output  reg                     de_ser_enable,
output  reg                     Data_Valid 
);



// states in grey coding
localparam IDLE = 3'b000; // 0
localparam START = 3'b001; // 1
localparam DATA = 3'b011; // 3
localparam PARITY = 3'b010; // 2
localparam STOP = 3'b110; // 6
localparam CHECK = 3'b111; // 7
localparam valid_data = 3'b101; //5




reg [2:0] cs,ns;


// current state logic
always @(posedge CLK or negedge RST) 
begin
	if (!RST) 
	    begin
             cs<=IDLE;
	    end
	else
	    begin
		     cs<=ns;
	    end
end




//next state logic and output logic together
always@(*)
begin                           // default outputs
               	                counter_enable=0;
                                sampling_enable=0;
                                par_check_enable=0;
                                stop_check_enable=0;
                                strt_glitch_enable=0;
                                de_ser_enable=0;
                                Data_Valid=0;  
                                //par_exist=0;
	case(cs)
           IDLE:
               begin
               	    if(RX_IN==0)
               	       begin
               	            ns=START; 
               	            //outputs : enable the edge_bit_cnt and the sampling block and the start_check block
               	                counter_enable=1;
                                sampling_enable=1;
                                par_check_enable=0;
                                stop_check_enable=0;
                                strt_glitch_enable=1;
                                de_ser_enable=0;
                                Data_Valid=0;
               	       end

               	    else
               	       begin
               	            ns=IDLE; // remain in the idle state if the RX_IN did not fall ro zero
               	            //outputs
               	                counter_enable=0;
                                sampling_enable=0;
                                par_check_enable=0;
                                stop_check_enable=0;
                                strt_glitch_enable=0;
                                de_ser_enable=0;
                                Data_Valid=0;               	            	
               	       end 
               end

            
            START:
                  begin
                                //outputs: enable the edge_bit_cnt and the sampling block and the start_check block
                                counter_enable=1;
                                sampling_enable=1;
                                par_check_enable=0;
                                stop_check_enable=0;
                                strt_glitch_enable=1;
                                de_ser_enable=0;
                                Data_Valid=0;     

 /*when the start bit edges is finsihed (16 edge) then go to data but first check that start bit is real not glitch*/                                            
                       if(bit_count==1&&(edge_count==(prescalar-1)))
                         begin
                              if(!start_glitch)
                                 begin
                                      ns=DATA;
                                 end

                               else 
                                 begin
                                      ns=IDLE; // return to  the idle state if start bit was not real and was a glitch 
                                 end  
                         end

                       else 
                        begin
                                      ns=START;   
                        end  
                  end


            DATA:
                  begin
                                //outputs: enable the edge_bit_cnt and the sampling block and the de-serialzier
                                counter_enable=1;
                                sampling_enable=1;
                                par_check_enable=0;
                                stop_check_enable=0;
                                strt_glitch_enable=0;
                                de_ser_enable=1;
                                Data_Valid=0;     

 /*when the 16 edge of the 8th bit of data is finished then go to parity or stop depending on the PAR_EN*/                                            
                       if(bit_count==9&&(edge_count==(prescalar-1)))
                         begin
                              if(PAR_EN)
                                 begin
                                      ns=PARITY;
                                 end

                               else 
                                 begin
                                      ns=STOP; 
                                 end  
                         end

                       else 
                         begin
                                      ns=DATA;   
                         end  

                  end   


            PARITY:
                  begin
                                //outputs: enable the edge_bit_cnt and the sampling block and the parity_checker
                                counter_enable=1;
                                sampling_enable=1;
                                stop_check_enable=0;
                                strt_glitch_enable=0;
                                de_ser_enable=0;
                                Data_Valid=0;     

 /*when the parity_bit edges is finsihed (16 edge) then go to stop or remain as you are*/                                            
                       if(bit_count==10&&(edge_count==(prescalar-1)))
                         begin
                            ns=STOP;
 //parity_enable is activated only at the end of the bit to make sure it takes ths right sample of the par_bit                           
                            par_check_enable=1;
                         end
                       else 
                         begin
                            ns=PARITY; 
                            par_check_enable=0;
                         end  
                end

 
            STOP:
                  begin
                                //outputs: enable the edge_bit_cnt and the sampling block and the parity_checker
                                counter_enable=1;
                                sampling_enable=1;
                                par_check_enable=0;
                                strt_glitch_enable=0;
                                de_ser_enable=0;
                                Data_Valid=0;     

 /*when the stop_bit edges is finsihed (16 edge) then go to stop or remain as you are*/                                            
                       if(bit_count==11&&(edge_count==(prescalar-2)))
                         begin
                            ns=CHECK;
 //stop_enable is activated only at the end of the bit to make sure it takes ths right sample of the stop_bit                           
                            stop_check_enable=1;
                         end
                       else 
                         begin
                            ns=STOP; 
                            stop_check_enable=0;

                         end  
                end


            CHECK:
                  begin
                                counter_enable=0;
                                sampling_enable=0;
                                par_check_enable=0;
                                stop_check_enable=0;
                                strt_glitch_enable=0;
                                de_ser_enable=0;
                                Data_Valid=0;     
//This state is only to check if there any error in parity or stop bits or not...if there is error then dont accept data dont make data_valid high
 /*to return back to thr ideal state if you found an error in parity or stop*/                                            
                       if(par_error||stop_error)
                         begin
                            ns=IDLE;
                         end
                       else 
                         begin
                            ns=valid_data; 
                         end  
                  end


            valid_data:
                       begin
//This state is only to make data_valid is high and it is in a seperate state to overcome making conditions on when to make it high
//once you reached this state then there are no constraints to make it high and the data is accepted                     
                            Data_Valid=1;
                            if(RX_IN==0) ns=START; // this condition to be able to send 2 consecutive frames
                            else         ns=IDLE;
                       end


            default:
                   begin
                               ns=IDLE;                 
                               // default outputs
                                counter_enable=0;
                                sampling_enable=0;
                                par_check_enable=0;
                                stop_check_enable=0;
                                strt_glitch_enable=0;
                                de_ser_enable=0;
                                Data_Valid=0;  
                    end

	endcase
end

endmodule