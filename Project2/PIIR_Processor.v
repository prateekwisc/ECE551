module PIIR(AD, ALE, RD, WR, CE, PU, Clk1, Clk2, Const, CFG);

//  Top Level Variables
inout [15:0] AD;
output ALE, RD, WR;
input CE, PU, Clk1, Clk2, CFG;
input [3:0] Const;

// Registered Outputs
reg ALE, RD, WR;

// Internal Variables - Control Signals
reg [2:0] state, next_state;
reg recalculate; wire ready;   // Recalculate if re-configured, ready = When output from MAC has arrived
reg [3:0] new_input;      // Counter
reg configure, pause;
reg ad_wren;  // AD Write Enable


// Internal Variables - Storing Constants
reg [15:0] Addr;
reg [15:0] b0, b1, b2, a1, a2;
reg [15:0] x0, x1, x2, y1, y2;    // x1=X(-T), x2=X(-2T), y1=Y(-T), y2=Y(-2T)
wire [15:0] Y; // Output from the MAC unit

//  Parameterized States
  parameter S0 = 2'b00;  // PIIR Inactive, No-Operation, Configuration State
  parameter S1 = 2'b01;  // Address Given Out
  parameter S2 = 2'b10;  // Read State, Calculation State
  parameter S3 = 2'b11;  // Write State
  
//  Calculation Module Instantiation
// MAC(X_0,X_1,X_2,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);
  MAC mac(x0, x1, x2, 1'b1, ready, Y, Clk1, b0, b1, b2, a1, a2, y1, y2);
  
// Writing the output on AD 
assign AD = ad_wren ? (ready ? Y : Addr): 16'bZ;

//  State Machine
always@(posedge Clk1, negedge CE)
begin
  if (~CE) 
    state <= S0;
  else
    state <= next_state;
end
  
// Clk2 Logic
  always @(posedge Clk2, negedge CE) 
  begin
    
    if (~CE) begin
      configure <= 0; pause <= 0; recalculate <= 0; ad_wren <= 0;
    end
    else 
      begin
        
        if (CFG == 0) 
        begin
           
           configure <= 1;
           case(Const)
             4'b0001: begin
              a1 <= AD; recalculate<=1;
             end
             4'b0010: begin
              a2 <= AD;  recalculate<=1;
             end
             4'b0101: begin
              y1 <= AD;  recalculate<=1;
             end
             4'b0110: begin
              y2 <= AD;  recalculate<=1;
             end
             4'b1000: begin
              b0 <= AD;  recalculate<=1;
             end
             4'b1001: begin
              b1 <= AD;  recalculate<=1;
             end
             4'b1010: begin
              b2 <= AD;  recalculate<=1;
             end
             4'b1100: begin
              x0 <= AD;  recalculate<=1;
             end
             4'b1101: begin
              x1 <= AD;  recalculate<=1;
             end
             4'b1110: begin
              x2 <= AD;  recalculate<=1;
             end
             4'b1111: begin
              Addr <= AD;  recalculate<=0;
             end
             default: recalculate<=0;  // No-Operation
          endcase              
        end
        
        else if(PU==1) 
        begin
          pause <= 1;
        end
        
        else
        begin
          configure <= 0; pause <= 0;
        end
      
  end
 end
  
  
 // Clk1 logic - Next State and Output Logic
 always @(posedge Clk1, negedge CE) 
 begin
   
   if (~CE) 
      next_state <= S0;
    else 
      begin
        
        if(configure)
          begin
              ALE <= 0; RD <= 1; WR <= 0; next_state <= S0; ad_wren <= 0;
          end
        else
          begin
            
            case(state)
              S0: begin
                ALE <= 1; RD <=0; WR <=0; next_state <= S1; ad_wren <= 1; // AD <= Addr;
              end
              
              S1: begin
                
                ALE <= 0; RD <=1; WR <=0; ad_wren <= 0;
                if(pause)
                begin
                   next_state <= S1;
                end
                
                else if(recalculate)
                begin
                  next_state <= S2;
                  // Flush the pipeline and redo the calculations. (Give a call to unit here with new values)
                  recalculate <= 0;
                end
                
                else
                begin
                  
                  if(ready)
                    begin
                      y2 <= y1;  y1 <= Y;  x2 <= x1;  x1 <= x0;  x0 <= AD;    
                      next_state <= S2; new_input <= new_input + 1;
                    end
                    
                  else
                    begin
                      // Store new value in temp memory if pipelining and ready not high in 1 cycle.
                      y2 <= y1;  y1 <= Y;  x2 <= x1;  x1 <= x0;  x0 <= AD;  // This would then get commented out
                      next_state <= S2; new_input <= new_input + 1;
                    end
                  
                  
                end
                
              end
              
              S2: begin
                
                RD<=0;
                if(ready)
                  begin
                    next_state <= S3; ALE <= 0; WR <= 1; new_input <= new_input - 1; ad_wren <= 1; // AD <= Y; 
                  end
                else if(new_input!=0)
                  begin
                    next_state <= S2; ALE <= 0; WR <=0; ad_wren <= 0; // Read Delay Write-- Waiting for Ready to happen (Can go for all Read cycle as well)
                  end
                else
                  begin
                     ALE <= 1; WR <=0; next_state <= S1; ad_wren <= 1; // AD <= Addr; // Back to starting of new cycle (This becomes Basic Read cycle)
                  end
              end
              
              S3: begin
                ALE <= 1; RD <= 0; WR <= 0; next_state <= S1; ad_wren <= 1; // AD <= Addr;
                // Reset ready for pipelining, Can insert NoOp here
              end
            endcase
          end
      end     
  end

endmodule

  // MAC(X_0,X_1,X_2,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);
  
  // module MAC(Y, out_ready, out_awaited, Clk1, X_0, X_1, X_2, Y_1, Y-2, b0, b1, b2, a1, a2);
  // module MAC(X,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);
  //input [15:0]X,b0,b1,b2,a1,a2,Y_1,Y_2;
  //input out_awaited,Clk1;
  //output reg out_ready;
  //output reg[15:0]Y;
  
  