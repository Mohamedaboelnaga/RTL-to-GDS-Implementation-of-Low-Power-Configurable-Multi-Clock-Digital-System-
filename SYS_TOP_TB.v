
`timescale 1ns/1ps

module SYS_TOP_TB ();

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter DATA_WIDTH_TB  = 8  ;
parameter ADDR_WIDTH_TB  = 4  ;   
parameter REF_CLK_PER = 10 ;         // 100 MHz
parameter UART_CLK_PER = 271.267 ;   // 3.6864 MHz (115.2 * 32)
parameter WR_CMD  = 8'hAA ;   
parameter RD_CMD  = 8'hBB ;   
parameter ALU_WOP_CMD  = 8'hCC ;   
parameter ALU_WNOP_CMD = 8'hDD ;   

/////////////////////////////////////////////////////////
//////////////////// my_trial_system_TOP Signals ////////////////////////
/////////////////////////////////////////////////////////

reg                                RST_N;
reg                                UART_CLK;
reg                                REF_CLK;
reg                                UART_RX_IN;
wire                               UART_TX_O;
wire                               parity_error;
wire                               framing_error;

////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial
 begin

 // Initialization
 initialize() ;

 // Reset
 reset() ; 
 
/*
 //////////////// Default Configuration //////////////////
 ////////////////   PRESCALE : 32       //////////////////
 ////////////////   Parity   : Enabled  //////////////////
 ////////////////   TYPE     : EVEN     //////////////////

 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
  CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  CHECK_ALU(8'd0) ;

 ///////////////////////////////////////////////////////// 
 ////////////////   Configuration 2     //////////////////
 ////////////////   PRESCALE : 32       //////////////////
 ////////////////   Parity   : Enabled  //////////////////
 ////////////////   TYPE     : ODD      ////////////////// 
 /////////////////////////////////////////////////////////

 SEND_WR_CMD(8'h02,8'h83) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 

 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
  CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  CHECK_ALU(8'd0) ;  

 ///////////////////////////////////////////////////////// 
 ////////////////   Configuration 3     //////////////////
 ////////////////   PRESCALE : 32       //////////////////
 ////////////////   Parity   : DISABLED //////////////////
 /////////////////////////////////////////////////////////

 SEND_WR_CMD(8'h02,8'h80) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 

 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
  CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  CHECK_ALU(8'd0) ;  

*/
 ////////////////   Configuration 4     //////////////////
 ////////////////   PRESCALE : 16       //////////////////
 ////////////////   Parity   : Enabled  //////////////////
 ////////////////   TYPE     : EVEN     //////////////////
 
  SEND_WR_CMD(8'h02,8'h41) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 
 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  SEND_ALU_WOP_CMD(8'd80,8'd50,8'd1) ;
 
  // Check ALU Command
  CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

   //Send ALU WNOP Command (FUNC = Addition)
  SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  CHECK_ALU(8'd0) ;

 ///////////////////////////////////////////////////////// 
 ////////////////   Configuration 5     //////////////////
 ////////////////   PRESCALE : 16       //////////////////
 ////////////////   Parity   : Enabled  //////////////////
 ////////////////   TYPE     : ODD      ////////////////// 
 /////////////////////////////////////////////////////////

// SEND_WR_CMD(8'h02,8'h43) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 

 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  //SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  //CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  //SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  //CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  //SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
  //CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  //SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  //CHECK_ALU(8'd0) ;  

 ///////////////////////////////////////////////////////// 
 ////////////////   Configuration 6     //////////////////
 ////////////////   PRESCALE : 16       //////////////////
 ////////////////   Parity   : DISABLED //////////////////
 /////////////////////////////////////////////////////////

 //SEND_WR_CMD(8'h02,8'h40) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 

 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  //SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  //CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  //SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  //CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  //SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
 // CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  //SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  //CHECK_ALU(8'd0) ;  


/*
 ////////////////   Configuration 7     //////////////////
 ////////////////   PRESCALE : 8       //////////////////
 ////////////////   Parity   : Enabled  //////////////////
 ////////////////   TYPE     : EVEN     //////////////////
 
 SEND_WR_CMD(8'h02,8'h21) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 
 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
  CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  CHECK_ALU(8'd0) ;

 ///////////////////////////////////////////////////////// 
 ////////////////   Configuration 8     //////////////////
 ////////////////   PRESCALE : 8       //////////////////
 ////////////////   Parity   : Enabled  //////////////////
 ////////////////   TYPE     : ODD      ////////////////// 
 /////////////////////////////////////////////////////////

  SEND_WR_CMD(8'h02,8'h23) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 

 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
  CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  CHECK_ALU(8'd0) ;  

 ///////////////////////////////////////////////////////// 
 ////////////////   Configuration 9     //////////////////
 ////////////////   PRESCALE : 8       //////////////////
 ////////////////   Parity   : DISABLED //////////////////
 /////////////////////////////////////////////////////////

  SEND_WR_CMD(8'h02,8'h20) ;

 /////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////// 

 /////////////////////  WRITE CMD  ///////////////////////

  //Send Write Command (Address:8'h06 & Data: 8'hA5)
  SEND_WR_CMD(8'h06,8'hA5) ;
 
  //Check Write Operation
  CHECK_WR(8'h06,8'hA5) ;

 /////////////////////  READ CMD   ///////////////////////

  // Send Read Command (Address:8'h02)
  SEND_RD_CMD(8'h02) ;
 
  // Check Read Operation
  CHECK_RD(8'h02) ;

 ////////////////////  ALU_WOP CMD   ////////////////////

  // Send ALU WOP Command (OP_A = 100 & OP_B = 50 & FUNC = Subtraction)
  SEND_ALU_WOP_CMD(8'd100,8'd50,8'd1) ;
 
  // Check ALU Command
  CHECK_ALU(8'd1) ;

 //////////////////// ALU_WNOP CMD //////////////////////

  // Send ALU WNOP Command (FUNC = Addition)
  SEND_ALU_WNOP_CMD(8'd0) ;
 
  // Check ALU Command
  CHECK_ALU(8'd0) ;  

*/
  
  
#4000

$stop ;

end


////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
  begin
	UART_CLK          = 1'b0   ;
	REF_CLK           = 1'b0   ;
	RST_N             = 1'b1   ;    // rst is deactivated
	UART_RX_IN        = 1'b1   ;
  end
endtask

///////////////////////// RESET /////////////////////////
task reset ;
  begin
	#(REF_CLK_PER)
	RST_N  = 'b0;           // rst is activated
	#(REF_CLK_PER)
	RST_N  = 'b1;
	#(REF_CLK_PER) ;
  end
endtask

/////////////////////// Load Frame /////////////////////////
task LD_FRAME ;
 input  [DATA_WIDTH_TB-1:0]  FRAME_DATA ;
 
 integer   i  ;
 
 begin
	
	//@ (posedge my_trial_system_TOP.MY_UART.CLK_TX) 
	UART_RX_IN <= 1'b0 ;                    // start_bit

	for(i=0; i<8; i=i+1)
		begin
		//@(posedge my_trial_system_TOP.MY_UART.CLK_TX) 
    #(32*UART_CLK_PER);		
		UART_RX_IN <= FRAME_DATA[i] ;       // frame data bits
		end 

	if(my_trial_system_TOP.my_REG_FILE.REG2[0])
		begin
			//@ (posedge my_trial_system_TOP.MY_UART.CLK_TX) 
          #(32*UART_CLK_PER);    
			case(my_trial_system_TOP.my_REG_FILE.REG2[1])
			1'b0 : UART_RX_IN <= ^FRAME_DATA  ;     // Even Parity
			1'b1 : UART_RX_IN <= ~^FRAME_DATA ;     // Odd Parity
			endcase	
		end
	
	//@ (posedge my_trial_system_TOP.MY_UART.CLK_TX)
      #(32*UART_CLK_PER);     
	   UART_RX_IN <= 1'b1 ;              // stop_bit
	  #(32*UART_CLK_PER);    

 end
endtask 

/////////////////////// WRITE CMD /////////////////////////
task SEND_WR_CMD ;
 input  [DATA_WIDTH_TB-1:0]  ADDR ;
 input  [DATA_WIDTH_TB-1:0]  DATA ;
 
 begin
	LD_FRAME(WR_CMD) ;   // Load Write Command
	LD_FRAME(ADDR)   ;   // Load Write Address
	LD_FRAME(DATA)	 ;   // Load Write Data
 end
endtask 

/////////////////////// Read CMD /////////////////////////
task SEND_RD_CMD ;
 input  [DATA_WIDTH_TB-1:0]  ADDR ;
 
 begin
	LD_FRAME(RD_CMD) ;  // Load Read Command
	LD_FRAME(ADDR)   ;  // Load Read Address
 end
endtask 

///////////////////// ALU_WOP CMD ///////////////////////
task SEND_ALU_WOP_CMD ;
 input  [DATA_WIDTH_TB-1:0]  OP_A ;
 input  [DATA_WIDTH_TB-1:0]  OP_B ;
 input  [DATA_WIDTH_TB-1:0]  FUNC ;
 
 begin
	LD_FRAME(ALU_WOP_CMD) ;	   // Load ALU_WOP Command
	LD_FRAME(OP_A)        ;    // Load Operand A 
	LD_FRAME(OP_B)	      ;    // Load Operand B 
	LD_FRAME(FUNC)        ;    // Load ALU Function
 end
endtask 

///////////////////// ALU_WOP CMD ///////////////////////
task SEND_ALU_WNOP_CMD ;
 input  [DATA_WIDTH_TB-1:0]  FUNC ;
 
 begin
	LD_FRAME(ALU_WNOP_CMD)	 ;    // Load ALU_WOP Command
	LD_FRAME(FUNC)           ;    // Load ALU Function
 end
endtask 

//////////////// Check Write Operation /////////////////
task CHECK_WR ;
 input  [DATA_WIDTH_TB-1:0]  ADDR ;
 input  [DATA_WIDTH_TB-1:0]  DATA ;
 
 begin
	wait(my_trial_system_TOP.my_REG_FILE.WrEn)
	repeat(2) @(posedge REF_CLK); 
	if(my_trial_system_TOP.my_REG_FILE.REG[ADDR[ADDR_WIDTH_TB-1:0]] == DATA)
		begin
			$display("Write Operation is succeeded with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",my_trial_system_TOP.my_REG_FILE.REG2[0],my_trial_system_TOP.my_REG_FILE.REG2[1],my_trial_system_TOP.my_REG_FILE.REG2[7:2]);
		end
	else
		begin
			$display("Write Operation is failed with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",my_trial_system_TOP.my_REG_FILE.REG2[0],my_trial_system_TOP.my_REG_FILE.REG2[1],my_trial_system_TOP.my_REG_FILE.REG2[7:2]);
		end	
 end
endtask 

//////////////// Check Read Operation /////////////////
task CHECK_RD ;
 input  [DATA_WIDTH_TB-1:0]  	ADDR     ;
 
 reg    [10:0]  gener_out ,expec_out;     //longest frame = 11 bits (1-start,1-stop,8-data,1-parity)
 reg            parity_bit;
 
 integer   i  ;

 begin

	//generated frame
	@(negedge my_trial_system_TOP.MY_UART.TX_OUT)
	for(i=0; i<11; i=i+1)
		begin
		@(negedge my_trial_system_TOP.MY_UART.CLK_TX) gener_out[i] = UART_TX_O ;
		end
	
	//calculate expected parity bit 	
    if(my_trial_system_TOP.my_REG_FILE.REG2[0])
		if(my_trial_system_TOP.my_REG_FILE.REG2[1])
			parity_bit = ~^my_trial_system_TOP.my_REG_FILE.REG[ADDR[ADDR_WIDTH_TB-1:0]] ;
		else
			parity_bit = ^my_trial_system_TOP.my_REG_FILE.REG[ADDR[ADDR_WIDTH_TB-1:0]] ;
	else
			parity_bit = 1'b1 ;	
	
	//expected frame
    if(my_trial_system_TOP.my_REG_FILE.REG2[0])
		expec_out = {1'b1,parity_bit,my_trial_system_TOP.my_REG_FILE.REG[ADDR[ADDR_WIDTH_TB-1:0]],1'b0} ;
	else
		expec_out = {1'b1,1'b1,my_trial_system_TOP.my_REG_FILE.REG[ADDR[ADDR_WIDTH_TB-1:0]],1'b0} ;
			
	if(gener_out == expec_out) 
		begin
			$display("Read Operation is succeeded with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",my_trial_system_TOP.my_REG_FILE.REG2[0],my_trial_system_TOP.my_REG_FILE.REG2[1],my_trial_system_TOP.my_REG_FILE.REG2[7:2]);
		end
	else
		begin
			$display("Read Operation is failed with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",my_trial_system_TOP.my_REG_FILE.REG2[0],my_trial_system_TOP.my_REG_FILE.REG2[1],my_trial_system_TOP.my_REG_FILE.REG2[7:2]);
		end
 end
endtask

//////////////// Check ALU Operation /////////////////
task CHECK_ALU ;
 input  [DATA_WIDTH_TB-1:0]  	FUNCTION ;

 //longest frame = 11 bits (1-start,1-stop,8-data,1-parity)
 
 reg    [10:0]  gener_byte0  , gener_byte1 ;     
 reg    [10:0]  expec_byte0  , expec_byte1  ;                        

 reg            parity_bit0 , parity_bit1 ;

 
 reg    [2*DATA_WIDTH_TB-1:0] ALU_OUT_RESULT ;

 
 integer   i  ;

 begin

	//generated byte0 frame
	@(negedge my_trial_system_TOP.MY_UART.TX_OUT)
	for(i=0; i<11; i=i+1)
		begin
		@(negedge my_trial_system_TOP.MY_UART.CLK_TX) gener_byte0[i] = UART_TX_O ;
		end
		
	//generated byte1 frame
	@(negedge my_trial_system_TOP.MY_UART.TX_OUT)
	for(i=0; i<11; i=i+1)
		begin
		@(negedge my_trial_system_TOP.MY_UART.CLK_TX) gener_byte1[i] = UART_TX_O ;
		end
		
	//calculate ALU Output  	
	case (FUNCTION) 
     4'b0000: begin
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0] + my_trial_system_TOP.my_REG_FILE.REG[1];
              end
     4'b0001: begin
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0] - my_trial_system_TOP.my_REG_FILE.REG[1];
              end
     4'b0010: begin
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0] * my_trial_system_TOP.my_REG_FILE.REG[1];
              end
     4'b0011: begin
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0] / my_trial_system_TOP.my_REG_FILE.REG[1];
              end
     4'b0100: begin
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0] & my_trial_system_TOP.my_REG_FILE.REG[1];
              end
     4'b0101: begin
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0] | my_trial_system_TOP.my_REG_FILE.REG[1];
              end
     4'b0110: begin
               ALU_OUT_RESULT = ~ (my_trial_system_TOP.my_REG_FILE.REG[0] & my_trial_system_TOP.my_REG_FILE.REG[1]);
              end
     4'b0111: begin
               ALU_OUT_RESULT = ~ (my_trial_system_TOP.my_REG_FILE.REG[0] | my_trial_system_TOP.my_REG_FILE.REG[1]);
              end     
     4'b1000: begin
               ALU_OUT_RESULT =  (my_trial_system_TOP.my_REG_FILE.REG[0] ^ my_trial_system_TOP.my_REG_FILE.REG[1]);
              end
     4'b1001: begin
               ALU_OUT_RESULT = ~ (my_trial_system_TOP.my_REG_FILE.REG[0] ^ my_trial_system_TOP.my_REG_FILE.REG[1]);
              end           
     4'b1010: begin
              if (my_trial_system_TOP.my_REG_FILE.REG[0] == my_trial_system_TOP.my_REG_FILE.REG[1])
                 ALU_OUT_RESULT = 'b1;
              else
                 ALU_OUT_RESULT = 'b0;
              end
     4'b1011: begin
               if (my_trial_system_TOP.my_REG_FILE.REG[0] > my_trial_system_TOP.my_REG_FILE.REG[1])
                 ALU_OUT_RESULT = 'b10;
               else
                 ALU_OUT_RESULT = 'b0;
              end 
     4'b1100: begin
               if (my_trial_system_TOP.my_REG_FILE.REG[0] < my_trial_system_TOP.my_REG_FILE.REG[1])
                 ALU_OUT_RESULT = 'b11;
               else
                 ALU_OUT_RESULT = 'b0;
              end     
     4'b1101: begin
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0]>>1;
              end
     4'b1110: begin 
               ALU_OUT_RESULT = my_trial_system_TOP.my_REG_FILE.REG[0]<<1;
              end
     4'b1111: begin
               ALU_OUT_RESULT = 'b0;
              end
     endcase

	
	//calculate expected parity bit for ALU byte0 data  	
    if(my_trial_system_TOP.my_REG_FILE.REG2[0])
		if(my_trial_system_TOP.my_REG_FILE.REG2[1])
			parity_bit0 = ~^ALU_OUT_RESULT[DATA_WIDTH_TB-1:0] ;
		else
			parity_bit0 = ^ALU_OUT_RESULT[DATA_WIDTH_TB-1:0] ;
	else
			parity_bit0 = 1'b1 ;	

	//calculate expected parity bit for ALU byte1 data  	
    if(my_trial_system_TOP.my_REG_FILE.REG2[0])
		if(my_trial_system_TOP.my_REG_FILE.REG2[1])
			parity_bit1 = ~^ALU_OUT_RESULT[2*DATA_WIDTH_TB-1:DATA_WIDTH_TB] ;
		else
			parity_bit1 = ^ALU_OUT_RESULT[2*DATA_WIDTH_TB-1:DATA_WIDTH_TB] ;
	else
			parity_bit1 = 1'b1 ;	


	//expected byte0 frame 
    if(my_trial_system_TOP.my_REG_FILE.REG2[0])
		expec_byte0 = {1'b1,parity_bit0,ALU_OUT_RESULT[DATA_WIDTH_TB-1:0],1'b0} ;
	else
		expec_byte0 = {1'b1,1'b1,ALU_OUT_RESULT[DATA_WIDTH_TB-1:0],1'b0} ;

	//expected byte1 frame 
    if(my_trial_system_TOP.my_REG_FILE.REG2[0])
		expec_byte1 = {1'b1,parity_bit1,ALU_OUT_RESULT[2*DATA_WIDTH_TB-1:DATA_WIDTH_TB],1'b0} ;
	else
		expec_byte1 = {1'b1,1'b1,ALU_OUT_RESULT[2*DATA_WIDTH_TB-1:DATA_WIDTH_TB],1'b0} ;

		
	if(gener_byte0 == expec_byte0 && gener_byte1 == expec_byte1) 
		begin
			$display("ALU Operation is succeeded with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",my_trial_system_TOP.my_REG_FILE.REG2[0],my_trial_system_TOP.my_REG_FILE.REG2[1],my_trial_system_TOP.my_REG_FILE.REG2[7:2]);
		end
	else
		begin
			$display("ALU Operation is failed with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",my_trial_system_TOP.my_REG_FILE.REG2[0],my_trial_system_TOP.my_REG_FILE.REG2[1],my_trial_system_TOP.my_REG_FILE.REG2[7:2]);
		end

	end
endtask

//////////////////////////////////////////////////////// 
///////////////////// Clock Generator //////////////////
////////////////////////////////////////////////////////
 
// REF Clock Generator
always #(REF_CLK_PER/2) REF_CLK = ~REF_CLK ;

// UART RX Clock Generator
always #(UART_CLK_PER/2) UART_CLK = ~UART_CLK ;


//////////////////////////////////////////////////////// 
///////////////// Design Instaniation //////////////////
////////////////////////////////////////////////////////

SYSTEM_TOP # (.DATA_WIDTH(DATA_WIDTH_TB) ,  .ADDR_WIDTH(ADDR_WIDTH_TB) , .PRESCALER_WIDTH(6)) my_trial_system_TOP (
.UART_CLK(UART_CLK),
.REF_CLK(REF_CLK),
.RST(RST_N),
.RX_IN(UART_RX_IN),
.TX_OUT(UART_TX_O),
.PAR_ERR(parity_error),
.STP_ERR(framing_error)
);


endmodule