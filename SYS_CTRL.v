module SYS_CTRL #(parameter DATA_WIDTH=8 , ADDR_WIDTH=4, FUN_WIDTH=4)
( /*inputs from RX*/
  input                           CLK,
  input                           RST,
  input        [DATA_WIDTH-1:0]   RX_P_DATA,
  input                           RX_D_VLD,
 /*inputs from REG_FILE*/
  input        [DATA_WIDTH-1:0]   RD_DATA_REGF,
  input                           RD_D_VLD_REGF,
 /*inputs from ALU*/
  input        [2*DATA_WIDTH-1:0] ALU_OUT,
  input                           ALU_OUT_VLD,
 /*inputs from FIFO*/
  input                           FIFO_FULL,
 /*outputs for REG_FILE*/
  output reg                      WR_EN_REGF,
  output reg                      RD_EN_REGF,
  output reg   [ADDR_WIDTH-1:0]   ADDR_REGF,
  output reg   [DATA_WIDTH-1:0]   WR_DATA_REGF,
 /*outputs for ALU*/
 output  reg   [FUN_WIDTH-1:0]    ALU_FUN,
 output  reg                      ALU_EN,
 // output reg   [DATA_WIDTH-1:0] reg_received_bits_togoto_FIFO_REG,
 // output reg   [2*DATA_WIDTH-1:0] reg_received_bits_togoto_FIFO_ALU
 /*outputs for FIFO*/
 output  reg   [DATA_WIDTH-1:0]   WR_DATA_FIFO,
 output  reg                      WR_INC_FIFO,
 /*outputs for CLK_gating*/
 output  reg                      Gate_EN,
 /*outputs for CLK_DIV*/
 output  reg                      CLK_DIV_EN
); 



//Commands
localparam REGF_WR_CMD='hAA;
localparam REGF_RD_CMD='hBB;
localparam ALU_OPER_W_OP_CMD='hCC;
localparam ALU_OPER_W_NOP_CMD='hDD;


reg [3:0] curr_state;
reg [3:0] nxt_state;



/*

//register to store the data coming from REG_FILE  in.
reg [DATA_WIDTH-1:0] reg_received_bits_togoto_FIFO_REG;
reg [DATA_WIDTH-1:0] comb_received_bits_togoto_FIFO_REG;


//register to store the data coming from ALU in.
reg [2*DATA_WIDTH-1:0] reg_received_bits_togoto_FIFO_ALU;
reg [2*DATA_WIDTH-1:0] comb_received_bits_togoto_FIFO_ALU;


/*register the input to the FIFO from REG FILE*/

/*
always @(posedge CLK or negedge RST) begin
    if (!RST)
       begin
            reg_received_bits_togoto_FIFO_REG<=0;
       end
    else
       begin
            reg_received_bits_togoto_FIFO_REG<=comb_received_bits_togoto_FIFO_REG;
       end
end

*/

/*register the input to the FIFO from alu*/ /*
always @(posedge CLK or negedge RST) begin
    if (!RST)
       begin
            reg_received_bits_togoto_FIFO_ALU<=0;
       end
    else
       begin
            reg_received_bits_togoto_FIFO_ALU<=comb_received_bits_togoto_FIFO_ALU;
       end
end
*/



// Refisters to store in
reg [ADDR_WIDTH-1:0] ADDR_STORE;
reg [DATA_WIDTH-1:0] RD_DATA_STORE_REG;
reg [2*DATA_WIDTH-1:0] ALU_DATA_STORE;


//Enables to be able to store the data on parallel bus
reg       ADDR_STORE_EN;
reg       RD_DATA_STORE_EN;
reg       ALU_DATA_STORE_EN;    





//Frames : States :_s 
localparam [3:0] IDLE_s='d0;
localparam [3:0] REGF_WR_ADDR_s='d1;
localparam [3:0] REGF_WR_DATA_s='d2;
localparam [3:0] REGF_RD_ADDR_s='d3;
localparam [3:0] OPERAND_A_s='d4;
localparam [3:0] OPERAND_B_s='d5;
localparam [3:0] ALU_FUNC_W_OP_s='d6;
localparam [3:0] ALU_FUNC_W_NOP_s='d7;

localparam [3:0] wait_data_valid_REGF_s='d8;
localparam [3:0] wait_data_valid_ALU_s='d9;
localparam [3:0] write_in_FIFO_from_REG_s='d10;
localparam [3:0] write_in_FIFO_from_ALU_first_byte_s='d11;
localparam [3:0] write_in_FIFO_from_ALU_second_byte_s='d12;




/*Current State Block*/
always @(posedge CLK or negedge RST) begin
    if (!RST)
       begin
            curr_state<=IDLE_s;
       end
    else
       begin
            curr_state<=nxt_state;
       end
end




/*State Transition and Output Logic*/
always@(*)
begin
                                                   //initial:
                                                    WR_EN_REGF=1'b0;
                                                    RD_EN_REGF=1'b0;
                                                    ADDR_REGF='b0;
                                                    WR_DATA_REGF='b0;
                                                    ALU_FUN='b0;
                                                    ALU_EN=1'b0;
                                                    WR_DATA_FIFO='b0;
                                                    WR_INC_FIFO=1'b0;
                                                    Gate_EN=1'b0;
                                                    CLK_DIV_EN=1'b1; // always on
                                                    ADDR_STORE_EN=1'b0;
                                                    RD_DATA_STORE_EN=1'b0;
                                                    ALU_DATA_STORE_EN=1'b0;



    case(curr_state)

        IDLE_s:
            begin
                                                    //outputs:
                                                    WR_EN_REGF=1'b0;
                                                    RD_EN_REGF=1'b0;
                                                   // ADDR_REGF='b0;
                                                   // WR_DATA_REGF='b0;
                                                    ALU_FUN='b0;
                                                    ALU_EN=1'b0;
                                                    WR_DATA_FIFO='b0;
                                                    WR_INC_FIFO=1'b0;
                                                    Gate_EN=1'b0;
                                                    CLK_DIV_EN=1'b1; // always on
                 if(RX_D_VLD)
                        begin
      /*Case statment to choose which command will be excuted ...the transition happens when RX_D_VLD comes which means the command 
      frame is ready on the RX_P_DATA */                
                            case(RX_P_DATA)
                                 REGF_WR_CMD:       nxt_state=REGF_WR_ADDR_s; // write command....write in REG FILE
                                 REGF_RD_CMD:       nxt_state=REGF_RD_ADDR_s; // read command.....read from REG FILE
                                 ALU_OPER_W_OP_CMD: nxt_state=OPERAND_A_s;    // jump to frame OPERAND A to perform ALU operation
                                 ALU_OPER_W_NOP_CMD:nxt_state=ALU_FUNC_W_NOP_s; // // jump to frame alu_func with no operands to perform ALU operation
                                 default:           nxt_state=IDLE_s;
                            endcase
                        end

                  else 
                        begin
                                                    nxt_state=IDLE_s;
                        end  
            end
        
/*...............................................REG FILE COMMANDS............................................................................*/

        REGF_WR_ADDR_s:
            begin
                                                    //outputs: 
                                                    CLK_DIV_EN=1'b1; // always on                                                               
                                                   // WR_EN_REGF=1'b1; // REG FILE write enable
/*now you proccessed the address and waiting for another frame which is the data to write this data in tha address you took
and of course you make write enable of REG_FILE high and the frame came which is the address is output as address to REG_FILE*/                                                     

                 if(RX_D_VLD)
                       begin                         //ADDR_REGF=RX_P_DATA;
                                                    ADDR_STORE_EN=1;
                                                    nxt_state=REGF_WR_DATA_s;     // go to DATA frame                           
                       end   
                 else 
                       begin
                                                    ADDR_STORE_EN=0;

                                                    nxt_state=REGF_WR_ADDR_s;       // remain in same state                     
                       end                                   
            end



        REGF_WR_DATA_s:
            begin
                                                    //outputs: 
                                                    CLK_DIV_EN=1'b1; // always on                                                               
                                                    WR_EN_REGF=1'b1;
/*Now once you came to this state you received the frame of the data of the write command...so we put the data on the write data
bus of the REG FILE while raisng the write enable.....if another frame comes discard it and go back to idle as you finished the command*/                                                   

                 if(RX_D_VLD)
                       begin
                                                    WR_EN_REGF=1'b1;                       
                                                    ADDR_REGF =ADDR_STORE;  // put the address you stored in the previos state on the address bus
                                                    WR_DATA_REGF=RX_P_DATA;
                                                    nxt_state=IDLE_s;                               
                       end   
                 else 
                       begin
                                                    WR_EN_REGF=1'b0;                                              
                                                    ADDR_REGF =ADDR_STORE;  // put the address you stored in the previos state on the address bus
                                                    //WR_DATA_REGF=RX_P_DATA;                                                    
                                                    nxt_state=REGF_WR_DATA_s;              // remain in same state                  
                       end                                   
            end



         REGF_RD_ADDR_s:
            begin
                                                    //outputs:      
                                                    CLK_DIV_EN=1'b1; // always on                                                          
                                                    WR_EN_REGF=1'b0;
                                                    //RD_EN_REGF=1'b1;
/*now you want to read data from certain address in the REG FILE....so we raise the read enable and put the required address which is my frame now
on the RX_P_DATA on the address bus of the REG FILE....and the next state is waiting for the reg file to inform me that the data is ready
in this address to be able to store it in my register : reg_received_bits_togoto_FIFO ........ */                                                  
                 if(RX_D_VLD)
                       begin
                                                     //ADDR_REGF=RX_P_DATA;
                                                    ADDR_STORE_EN=1; // put the address you stored in the previos state on the address bus
                                                    nxt_state=wait_data_valid_REGF_s;   // go to a state to receive data from REG FILE                          
                       end   
                 else 
                       begin
                                                     ADDR_STORE_EN=0;                       
                                                     nxt_state=REGF_RD_ADDR_s;            // remain in same state                   
                       end                                   
            end



         wait_data_valid_REGF_s:
            begin
                                                     //outputs: 
                                                     WR_EN_REGF=1'b0;
                                                     CLK_DIV_EN=1'b1; // always on                                                             
                                                     RD_EN_REGF=1'b1;
                                                     ADDR_REGF=ADDR_STORE;
/*now you came to this state where you do nothing except waiting for the valid signal from the REG FILE to be able to store the
data in an internal register until you send it to the fifo...once you received this valid store the data and now the read operation
is finished so you must return back to idle state in case another command comes....if valid didnot come you are still waiting
for it in then same state */                            

                 if(RD_D_VLD_REGF)
                       begin
                                                    RD_DATA_STORE_EN=1;                       
                                                    nxt_state=write_in_FIFO_from_REG_s; // write data in FIFO                          
                       end   
                 else 
                       begin
                                                    RD_DATA_STORE_EN=0;                                              
                                                    nxt_state=wait_data_valid_REGF_s;             // remain in same state                 
                       end                                   
            end            
           

/*...............................................ALU COMMANDS............................................................................*/


/*remember:which state makes you come here? nothing from the previous states but IDLE state where you come here when the
data on RX is ALU_OPER_W_OP_CMD : 0xCC ...alu  func with operands*/

/*BUT REMEBERRRRRRRR that you for writing operands A,B you perform same as writing data command....writing in REG FILE....but
you write in special addresses address 0 and address 1....not the data comes on the bus is taken as address....but you take the
P_DATA as the operand A itself to be written..........so you enable the write enable and write in the REG file and go to operand B next state*/


         OPERAND_A_s:
            begin
                                                   //outputs:          
                                                    CLK_DIV_EN=1'b1; // always on                                                     
                                                    RD_EN_REGF=1'b0;
                                                    ADDR_REGF='h0000; // address 0
                                                    Gate_EN=1'b0;
/*here you must enable the clk gating as you will perform alu function after 2 clk cycles so the clk must be ready before that*/                                                    

                 if(RX_D_VLD)
                       begin
                                                    WR_EN_REGF=1'b1;                       
                                                    WR_DATA_REGF=RX_P_DATA; //operand A is put on data bus of REG file                                                  
                                                    nxt_state=OPERAND_B_s;                          
                       end   
                 else 
                       begin

                                                    WR_EN_REGF=1'b0;                       
                                                    nxt_state=OPERAND_A_s;    // remain in same state                                                                
                                                    //WR_DATA_REGF=RX_P_DATA; //operand A is put on data bus of REG file                                                  
                         
                       end                                   
            end  


          OPERAND_B_s:
            begin
                                                   //outputs:         
                                                    CLK_DIV_EN=1'b1; // always on                                                      
                                                    WR_EN_REGF=1'b1;
                                                    RD_EN_REGF=1'b0;
                                                    ADDR_REGF='h0001; // address 1
                                                    Gate_EN=1'b1;                                                    
                                                    //ALU_EN=1'b1;

                 if(RX_D_VLD)
                       begin
                                                    WR_EN_REGF=1'b1;                       
                                                    WR_DATA_REGF=RX_P_DATA; //operand A is put on data bus of REG file                                                  
                                                    nxt_state= ALU_FUNC_W_OP_s;       // alu func                   
                       end   
                 else 
                       begin
                                                    WR_EN_REGF=1'b0;                       
                                                   // WR_DATA_REGF=RX_P_DATA; //operand A is put on data bus of REG fi                       
                                                    nxt_state=OPERAND_B_s;           // remain in same state                   
                       end                                   
            end 


          ALU_FUNC_W_OP_s:
            begin
                                                   //outputs:    
                                                    CLK_DIV_EN=1'b1; // always on                                                           
                                                    WR_EN_REGF=1'b0;
                                                    //RD_EN_REGF=1'b1;
                                                    Gate_EN=1'b1;                                                    

                 if(RX_D_VLD)
                       begin
                                                    ALU_EN=1'b1;                                                                          
                                                    ALU_FUN=RX_P_DATA; // put the frame you got onto the alu func bus of alu...neglect difference in width                                                                        
                                                    nxt_state=wait_data_valid_ALU_s; //command finished....go to wait for alu result from alu out                  
                       end   
                 else 
                       begin
                                                    //ALU_FUN=RX_P_DATA; // put the frame you got onto the alu func bus of alu...neglect difference in width                                                                                            
                                                    ALU_EN=1'b0;                                                                          
                                                    nxt_state=ALU_FUNC_W_OP_s;           // remain in same state                   
                       end                                   
            end   


/*remember:which state makes you come here? nothing from the previous states but IDLE state where you come here when the
data on RX is ALU_OPER_W_OP_CMD : 0xDD ...alu  func without operands*/
          ALU_FUNC_W_NOP_s:
            begin
                                                   //outputs: 
                                                    CLK_DIV_EN=1'b1; // always on                                                              
                                                    Gate_EN=1'b1;                                                    
                 if(RX_D_VLD)
                       begin
                                                    ALU_EN=1'b1;                                                                          
                                                    ALU_FUN=RX_P_DATA; // put the frame you got onto the alu func bus of alu...neglect difference in width                                                                        
                                                    nxt_state=wait_data_valid_ALU_s; //command finished....go to wait for alu result from alu out                  
                       end   
                 else 
                       begin
                                                    ALU_EN=1'b0; 
                                                    //ALU_FUN=RX_P_DATA; // put the frame you got onto the alu func bus of alu...neglect difference in width                                                                                                                                                                                                     
                                                    nxt_state=ALU_FUNC_W_NOP_s;           // remain in same state                   
                       end                                   
            end   


/*now you came to this state where you do nothing except waiting for the valid signal from the ALU to be able to store the
data in an internal register until you send it to the fifo...once you received this valid store the data and now the ALU operation
is finished so you must return back to idle state in case another command comes....if valid didnot come you are still waiting
for it in then same state */          

         wait_data_valid_ALU_s:
            begin
                                                    CLK_DIV_EN=1'b1; // always on            
                                                    ALU_EN=1'b1;                // close alu                                   
                                                    Gate_EN=1'b1;   
                                                   // RD_EN_REGF=1'b1;

                 if(ALU_OUT_VLD)
                       begin
                                                    ALU_DATA_STORE_EN=1;  
                                                    nxt_state=write_in_FIFO_from_ALU_first_byte_s; //write data in FIFO next                         
                       end   
                 else 
                       begin
                                                    ALU_DATA_STORE_EN=0;                         
                                                    nxt_state=wait_data_valid_ALU_s;             // remain in same state                 
                       end                                   
            end    


 /*.................Now RX Path is finished.....uart Rx then synchronizer then SYS_CTRL* then writing in REG FILe and
ALU and reading from them the result and storing the results in internal registers in the SYS_CTRL.
 Next step is the TX path...SYS_CTRL to FIFO to UART TX to MASTER...................................................*/


          write_in_FIFO_from_REG_s:
            begin                           
                                                    RD_EN_REGF=1'b1;

                                                    CLK_DIV_EN=1'b1; // always on                
                 if(!FIFO_FULL)
                       begin
                                                    //outputs:             
                                                    WR_INC_FIFO=1'b1;                  
                                                    WR_DATA_FIFO=RD_DATA_STORE_REG; // store the data in the FIFO
                                                    nxt_state=IDLE_s;                          
                       end   
                 else 
                       begin
                                                    WR_INC_FIFO=1'b0;                                              
                                                    WR_DATA_FIFO='b0;  
                                                    nxt_state=write_in_FIFO_from_REG_s;             // remain in same state                 
                       end                                   
            end       

              

//write alu result on 2 bytes because alu result is double fifo width

          write_in_FIFO_from_ALU_first_byte_s:
            begin                               
                                                    CLK_DIV_EN=1'b1; // always on   
                                                    //ALU_EN=1'b1;                                                 
                                                    //Gate_EN=1'b1;                                                       
                                                    //RD_EN_REGF=1'b0;

                 if(!FIFO_FULL)
                       begin
                                                    //outputs:             
                                                    WR_INC_FIFO=1'b1;                  
                                                    WR_DATA_FIFO=ALU_DATA_STORE[DATA_WIDTH-1:0]; // store first byte in the FIFO
                                                    nxt_state=write_in_FIFO_from_ALU_second_byte_s;                          
                       end   
                 else 
                       begin
                                                    WR_INC_FIFO=1'b0;                                              
                                                    WR_DATA_FIFO='b0;  
                                                    nxt_state=write_in_FIFO_from_ALU_first_byte_s;             // remain in same state                 
                       end                                   
            end    



         write_in_FIFO_from_ALU_second_byte_s:
            begin                               
                                                    CLK_DIV_EN=1'b1; // always on   
                                                    ALU_EN=1'b1;                                                 
                                                    Gate_EN=1'b1;                                                       
                                                    //RD_EN_REGF=1'b0;

                 if(!FIFO_FULL)
                       begin
                                                    //outputs:             
                                                    WR_INC_FIFO=1'b1;                  
                                                    WR_DATA_FIFO=ALU_DATA_STORE[2*DATA_WIDTH-1:DATA_WIDTH]; // store 2nd byte in the FIFO
                                                    nxt_state=IDLE_s;                          
                       end   
                 else 
                       begin
                                                    WR_INC_FIFO=1'b0;                                              
                                                    WR_DATA_FIFO='b0;  
                                                    nxt_state=write_in_FIFO_from_ALU_second_byte_s;             // remain in same state                 
                       end                                   
            end      
         

    endcase 
end

 


//..................................Registers to save addresses and datas from REG FILE and ALU.................................



// go here in write address state when ADDR_STORE_EN is 1 to store the paralle data on the bus 
always @(posedge CLK or negedge RST) begin
    if (!RST)
       begin
            ADDR_STORE<=0;
       end
    else if(ADDR_STORE_EN)
       begin
            ADDR_STORE<=RX_P_DATA;
       end
end


// go here when RD_DATA_STORE_EN=1 to read and store  the data coming from REG FILE
always @(posedge CLK or negedge RST) begin
    if (!RST)
       begin
            RD_DATA_STORE_REG<='d0;
       end
    else if(RD_DATA_STORE_EN)
       begin
            RD_DATA_STORE_REG<=RD_DATA_REGF;
       end
end



// go here when ALU_DATA_STORE_EN and you want to store the data coming from alu
always @(posedge CLK or negedge RST) begin
    if (!RST)
       begin
            ALU_DATA_STORE<=0;
       end
    else if(ALU_DATA_STORE_EN)
       begin
            ALU_DATA_STORE<=ALU_OUT;
       end
end





endmodule