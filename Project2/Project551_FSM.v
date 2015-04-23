module FSM_551(CE,CFG,Const,RD,WR,PU,ALE,Clk1,Clk2,out_awaited,out_ready);
  input Clk1,Clk2,CFG,PU,CE,out_awaited,out_ready;
  input [3:0] Const;
  output reg RD,WR,ALE;
  parameter S1 = 3'b000;
  parameter S2 = 3'b001;
  parameter S3 = 3'b010;
  parameter S4 = 3'b011;
  parameter S5 = 3'b100;
  parameter S6 = 3'b101;
  parameter S7 = 3'b110;
  parameter S8 = 3'b111;
  reg[2:0] curr_state;
  
  // Clk2 Logic
  always @(posedge Clk2, negedge CE) begin
    if (~CE) curr_state <= S1;
    else if (CFG == 0) begin
      case(curr_state) 
        S2:   curr_state <= S3;
        S3:   curr_state <= S3;
        S4:   curr_state <= S3;
        S5:   curr_state <= S3;
        S8:   curr_state <= S3;
      endcase
    end
    else if (PU == 1 && curr_state == S5) curr_state <= S6;
    else if (PU == 0 && curr_state == S6) curr_state <= S5;  
  end
  
  
 // Clk1 logic
 always @(posedge Clk1, negedge CE) begin
   if (~ CE) curr_state <= S1;
   else if(CFG == 1 && curr_state == S2) begin curr_state <= S4; ALE <= 1; end
   else if(curr_state == S4) begin curr_state <= S5; ALE <= 0; RD <= 1; end  
   else if(curr_state == S5) begin 
    if(~out_awaited) curr_state <= S4; 
    else begin
      if(out_ready) begin RD <= 0; WR <= 1; curr_state <= S8; end
      else begin RD <= 1; WR <= 0; curr_state <= S7; end
    end
   end
   else if(curr_state == S7) begin
     if(out_ready) begin RD <= 0; WR <= 1; curr_state <= S8; end 
     else begin RD <= 1; WR <= 0; curr_state <= S7; end   //correction WR <= 0
   end
   else if(curr_state <= S8) begin ALE <= 1; WR <= 0; RD <= 0; end
 end    
endmodule
  
// Out_awaited and Out_ready are two signals given as input to FSM. Out_awaited is given to FSM in S5 to indicate that
// an output is to be computed. This is taken as a clk enable input by the MAC block which starts computation when 
// it receives out_awaited = 1. The MAC unit outputs out_ready = 1 when a y(u-2) is available. Else out_ready = 0.
// The FSM takes in out_ready to decide whether it should go from S7 to S8 or remain in S7.... 
// Need to generate out_awaited signal using some logic to be given as input to both FSM and MAC unit.... 
  
  