module TX_FSM(
input            CLK,
input            RST,
input            Data_Valid,
input            ser_done,
input            PAR_EN,
output reg       ser_en,
output reg       busy,
output reg [1:0] mux_sel, // 00 is start , 01 is stop,   10 is data, 11 is parity
output reg       accept_new,
output reg       enble_parity_block
);


// states
localparam Idle=3'b000;
localparam Start=3'b001;
localparam Data=3'b010;
localparam Parity=3'b011;
localparam Stop=3'b100;


reg [2:0] cs,ns; // current state and next state



//Current state Block
//If no Reset signal , state transition from current state to next state.If there is a Reset signal, return to the Idle state.
always @(posedge CLK or negedge RST) begin
	if (!RST) 
	   begin
          cs<=Idle;
	   end
	else 
	   begin               
		  cs<=ns;
	   end
end




// State Transition Block
always@(*)
begin
	   case(cs)
	        Idle:
	            begin
	                if(Data_Valid)
	                   begin
	                   		       ns=Start; //If Data_valid is HIGH then begin transmition and go to the start state
	                   	end
	                else 
	                    begin
	                               ns=Idle;  //If Data_valid is LOW then remain in the Idle state	
	                    end   		
	            end

            Start:
                 begin  /*It only sends a start bit before  the data so it does nothing except it begins the transmition */
                 	               ns=Data; 
                 end

            Data:
     /*Now you won't send the data until you receive a signal from the Serializer that the data is ready
    ,also now you may have a parity and may not depending on the parity_enable so we must check both cases */
                begin
                	if(ser_done)
                	   begin
                	   	   if(PAR_EN)
                	   	      begin
                	   	      	   ns=Parity; //next state is Parity only if parity is enabled.
                	   	      end
                	   	   else
                	   	      begin
                	   	           ns=Stop;  //else next state is the Stop state.
                	   	       end   
                	   end
                     
                   else 
                     begin
                                   ns=Data;	 //if the Serial_Done is not received,remain in the same state :Data state.
                     end

                end

            Parity:                ns=Stop;

            Stop: 
	            begin
	                if(Data_Valid)
	                   begin
	                   		       ns=Start; //If Data_valid is HIGH then you can re begin a new framw without returning to idle
	                   	end
	                else 
	                    begin
	                               ns=Idle;  //If Data_valid is LOW then return back to idle state
	                    end   		
	            end                

            default:               ns=Idle;                

	   endcase
end





// Output Logic Block

always @(*) 
begin
     case(cs)
          Idle:
              begin
                   if(Data_Valid)
                      begin
              	      busy=1'b0; //the systen is not busy now as no farme is being transmitted
              	      ser_en=1'b0;//no data transmition so serializer is not enabled by the FSM
              	      mux_sel=2'b01;//Idle state : the output is always one,ans the stop bit is already =1 
                      accept_new=1'b1;
              	      end
              	    /*else begin
              	    	   busy=1'b0; //the systen is not busy now as no farme is being transmitted
              	         ser_en=1'b0;//no data transmition so serializer is not enabled by the FSM
              	         mux_sel=2'b01;//Idle state : the output is always one,ans the stop bit is already =1
              	    end */ 
              end                //, so make the idle state the same as the stop state (in1 in mux) which is the 2nd input 

          Start:
              begin
                   enble_parity_block=1;
              	   busy=1'b1; // frame begins so busy begin to be high
              	   ser_en=1'b1;//no  data transmition so serializer is not enabled by the FSM
              	   mux_sel=2'b00;// select the 1st input of the mux which is sending a start bit which is 0
                   accept_new=1'b0;
              end

          Data:
              begin
              	   busy=1'b1; // frame begins so busy begin to be high
              	   //ser_en=1'b1;// data transmition  began so serializer is  enabled by the FSM
              	   mux_sel=2'b10;// select the 3rd input of the mux which is sending data
                   accept_new=1'b0;
                   //ser_en=1'b1;
/*Here as you know data state is many cycles,so you must check each time if the serializer finished data to disbale the serialzier*/                   
              	  if(ser_done) ser_en=1'b0;
              	  else         ser_en=1'b1;
  

              end              

          Parity:
              begin
              	    busy=1'b1; // frame begins so busy begin to be high
              	    ser_en=1'b0;//no  data transmition so serializer is not enabled by the FSM
              	    mux_sel=2'b11;// select the 4th input of the mux which is sending the parity bit but only if the PAR_EN is enabled
                    accept_new=1'b0;
              end

          Stop:
              begin
              		 busy=1'b1; // frame begins so busy begin to be high
                  if(Data_Valid)
                    begin
              	        ser_en=1'b1;//no  data transmition so serializer is not enabled by the FSM
              	        mux_sel=2'b01;// select the 2nd input which is stop bit
                        accept_new=1'b1;
                        busy=1'b0;
              	     end
                else 
                    begin
                      ser_en=1'b0;//no  data transmition so serializer is not enabled by the FSM
              	      mux_sel=2'b01;// select the 2nd input which is stop bit
                      accept_new=1'b0;
                      busy=1'b0;
                     end
                     

              end   

              default:begin
              	      busy=1'b0;
              	    ser_en=1'b0;
              	    mux_sel=2'b01;
                   enble_parity_block=0;

              end         

     endcase

end






endmodule