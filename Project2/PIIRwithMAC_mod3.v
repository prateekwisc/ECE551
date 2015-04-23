module PIIR(AD, ALE, RD, WR, CE, PU, Clk1, Clk2, Const, CFG);

//  Top Level Variables
inout [15:0] AD;
output ALE, RD, WR;
input CE, PU, Clk1, Clk2, CFG;
input [3:0] Const;
//wire conf;

// Registered Outputs
reg ALE, RD, WR;

// Internal Variables - Control Signals
reg [2:0] state, next_state;
reg recalculate, out_awaited; wire ready;   // Recalculate if re-configured, ready = When output from MAC has arrived
reg [3:0] new_input;      // Counter
reg configure, pause;
reg ad_wren;  // AD Write Enable


// Internal Variables - Storing Constants
reg [15:0] Addr, Addr_next, curr_Y; wire[15:0] calc_Y;
reg [15:0] b0, b1, b2, a1, a2;
reg [15:0] x0, x1, x2, y1, y2;    // x1=X(-T), x2=X(-2T), y1=Y(-T), y2=Y(-2T)
reg [15:0] Y; // Output from the MAC unit
reg [15:0] b0_next, b1_next, b2_next, a1_next, a2_next;
reg [15:0] x0_next, x1_next, x2_next, y1_next, y2_next;
reg ad_wren_next;
reg [15:0] AD_reg;

//  Parameterized States
  parameter S0 = 2'b00;  // PIIR Inactive, No-Operation, Configuration State
  parameter S1 = 2'b01;  // Address Given Out
  parameter S2 = 2'b10;  // Read State, Calculation State
  parameter S3 = 2'b11;  // Write State
  
//  Calculation Module Instantiation
// MAC(X_0,X_1,X_2,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);
  MAC mac(x0, x1, x2, out_awaited, ready, calc_Y, Clk1, b0, b1, b2, a1, a2, y1, y2);  // out_awaited to be corrected

//assign conf = configure; 
// Writing the output on AD 
assign AD = ad_wren ? AD_reg : 16'bZ;


  
// Clk2 Logic
  always @(posedge Clk2) 
  begin
    
        
        if (CFG == 0) 
        begin
           
           configure <= 1;
           pause <= 0;
        end
        
        else if(PU==1) 
        begin
          pause <= 1;
          configure <= 0;
        end
        
        else
        begin
          configure <= 0; pause <= 0;
        end
      
 end
  
  
  //  State Machine
always@(posedge Clk1, negedge CE)
begin
  if (~CE)
  begin 
    state <= S0;
    
    a1 <= 16'bz;
    a2 <= 16'bz;
    y1 <= 16'bz;
    y2 <= 16'bz;
    b0 <= 16'bz;
    b1 <= 16'bz;
    b2 <= 16'bz;
    x0 <= 16'bz;
    x1 <= 16'bz;
    x2 <= 16'bz;
    //curr_Y <= 16'bz;
    
    ad_wren<=0;
  end
  
  else 
  begin
    state <= next_state;
    Addr <= Addr_next;
    a1 <= a1_next;
    a2 <= a2_next;
    y1 <= y1_next;
    y2 <= y2_next;
    b0 <= b0_next;
    b1 <= b1_next;
    b2 <= b2_next;
    x0 <= x0_next;
    x1 <= x1_next;
    x2 <= x2_next;
    
    //curr_Y <= Y;
    ad_wren<=ad_wren_next;
  end
end

//Next state logic
always @(*)
begin
case (state)
  S0: if(~CE || configure)
      next_state = S0;
      else
      next_state = S1;
      
  S1: if(configure)
      next_state = S0;
      else
      next_state = S2;
      
  S2: if(configure)
      next_state = S0;
      else if(pause)
      next_state = S2;
      else if(ready)
      next_state = S3;
      else
      next_state = S1;   //check whether to go to S2 or S1 for read only or read delay write
      
  S3: if(~CE || configure)
      next_state = S0;
      else
      next_state = S1;
  endcase
end

always@(*)
begin
  if( next_state== S1 || next_state== S3 )
    ad_wren_next = 1;
  else
    ad_wren_next = 0;
end

  
 // Output Logic
 //always @(posedge Clk1, negedge CE) 
 always @(*)
 begin
   
   case(state)
     
   S0: begin
        Addr_next = Addr_next; // Don't remove this line at any cost  // Addr_next = 16'b0;
     // new_input=1;
    if(~CE) begin
       ALE = 1'bz;
       RD = 1'bz;
       WR = 1'bz;
       recalculate=0;
     end
     
     else if(configure)
        begin  
          
          ALE = 1'b0; RD = 1; WR = 0; 
            
            case(Const)
             4'b0001: begin
              a1_next = AD;  //recalculate = 1; 
             end
             4'b0010: begin
              a2_next = AD;  //recalculate =1;
             end
             4'b0101: begin
              y1_next = AD;  //recalculate =1;
             end
             4'b0110: begin
              y2_next = AD;  //recalculate =1;
             end
             4'b1000: begin
              b0_next = AD;  //recalculate =1;
             end
             4'b1001: begin
              b1_next = AD;  //recalculate =1;
             end
             4'b1010: begin
              b2_next = AD;  //recalculate =1;
             end
             4'b1100: begin
              x0_next = AD;  //recalculate =1;
             end
             4'b1101: begin
              x1_next = AD;  //recalculate =1;
             end
             4'b1110: begin
              x2_next = AD;  //recalculate =1;
             end
             4'b1111: begin
              Addr_next = AD;  //recalculate = recalculate;
             end
             default: ; //recalculate = recalculate; // No-Operation
          endcase
          
          end
          
        else
          begin
          Addr_next = Addr_next; //recalculate = recalculate;
          end
        end
      
      
      S1:
          begin
            
               ALE = 1; RD =0; WR =0; // AD = Addr;
               
               if(!configure)
               //if(recalculate )   // (recalculate || (new_input!= 0))
                 out_awaited = 1;
               else
                 out_awaited = 0;
                 
               AD_reg = Addr;
                 
              end
              
      S2: begin
                out_awaited = 0;   // AD_reg = 16'bz;
                ALE = 0; RD =1; WR =0; // recalculate=0;
                
                if(ready)
                    Y = calc_Y;
                else
                  Y = Y;
                
                if(~pause)
                begin
                                  
                      y2_next = y1;  y1_next = Y;  x2_next = x1;  x1_next = x0;  x0_next = AD;    
                      //new_input = new_input + 1;
                    end
                else
                  begin
                    y2_next = y2;  y1_next = y1;  x2_next = x2;  x1_next = x1;  x0_next = x0;    
                      //new_input = new_input;
                  end
                  
                  
              end
              
      S3: begin
                
               ALE = 0; WR = 1; RD = 0; // new_input = new_input - 1;  // AD = Y;
               AD_reg = Y;
               /*if(recalculate) 
                 begin
                  recalculate = 0;  
                end
                
               else
                 begin
                  recalculate = recalculate; 
                end */ 
            end
               
            endcase
          end
      

endmodule

// Output=>  calc_Y = b0*x0 + b1*x1 + b2*x2 + a1_n*y1 + a2_n*y2
module MAC (x0,x1,x2,out_awaited,out_ready,calc_Y,Clk1,b0,b1,b2,a1,a2,y1,y2);
  input [15:0] x0,x1,x2,b0,b1,b2,a1,a2,y1,y2;
  input out_awaited, Clk1;
  output reg out_ready;
  output reg [15:0] calc_Y;
  wire [19:0] final_Y;
  
  wire [15:0] a1_n,a2_n;
  assign a1_n = {~a1[15],a1[14:0]};
  assign a2_n = {~a2[15],a2[14:0]};
  
  wire [19:0] p1, p2, p3, p4, p5;
  wire [19:0] sum1, sum2, sum3;
  
  // Modules to be instantiated
  // mult_resbooth (Y,A,B);
  // CLA_16bit(output Carry_out, output reg [15:0] X, input [15:0] A_old, input [15:0] B_old);
  
  mult_resbooth m1 (p1, a1_n, y1);
  mult_resbooth m2 (p2, a2_n, y2);
  mult_resbooth m3 (p3, b0, x0);
  mult_resbooth m4 (p4, b1, x1);
  mult_resbooth m5 (p5, b2, x2);
  
  CLA_16bit adder1(, sum1, p1, p2);
  CLA_16bit adder2(, sum2, p3, p4);
  CLA_16bit adder3(, sum3, sum1, sum2);
  CLA_16bit adder4(, final_Y, sum3, p5);
  
  always@(posedge Clk1)
  begin
    
  if(out_awaited)
  begin
    calc_Y <= final_Y[19:4]; //b0*X_0 + b1*X_1 + b2*X_2 - a1*Y_1 - a2*Y_2 ;
    out_ready <= 1;
  end
  
  else
  begin
    calc_Y <= 16'bz;
    out_ready <=0;
  end
  
end
 endmodule 
 
 
 
 module mod_booth_multiplier (product, x, y);

//parameter declarations
parameter width= 16;
parameter N = 8;

//input port declaration
input[width-1:0]x, y;

//output port declaration
output[width+width-1:0]product;

//Port Data Types
reg [2:0] count[N-1:0];
reg [width:0] partial[N-1:0];
reg [width+width-1:0] signedpartial[N-1:0];
reg [width+width-1:0] result;
wire [width:0] inv_x;

//local variables of integer type
integer i,j;

//generate two's complement of mutiplicand X(M)
assign inv_x = {~x[width-1],~x}+1;
always @ (x or y or inv_x)
begin
count[0] = {y[1],y[0],1'b0};
for(j=1;j<N;j=j+1)
count[j] = {y[2*j+1],y[2*j],y[2*j-1]};

for(j=0;j<N;j=j+1)
begin
case(count[j])  //recoding cases of radix-4 booth multiplier
//computing booth recoded bits
3'b001 , 3'b010 : partial[j] = {x[width-1],x}; // 1 X Multiplicand
3'b011 : partial[j] = {x,1'b0};                // 2 X Multiplicand
3'b100 : partial[j] = {inv_x[width-1:0],1'b0}; // -2 X Multiplicand
3'b101 , 3'b110 : partial[j] = inv_x;          // -1 X Multiplicand
default : partial[j] = 0;                      // Zero
endcase
signedpartial[j] = $signed(partial[j]);
for(i=0;i<j;i=i+1)
signedpartial[j] = {signedpartial[j],2'b00}; //multiply by 2 to the power x or shifting operation
end
result = signedpartial[0];
for(j=1;j<N;j=j+1)
result = result + signedpartial[j];
end
assign product = result ;
endmodule

//module for rounding up and truncating

module mult_resbooth(Y,A,B);
  input [15:0] A,B;
  output [19:0] Y;
  wire sign;
  wire [31:0] m_res;
  mod_booth_multiplier m1(m_res,{1'b0,A[14:0]},{1'b0,B[14:0]});
  assign sign = A[15] ^ B[15];
  assign Y = {sign,m_res[29:11]};
 endmodule

//1 bit CLA Adder
module FAGP_1bit(output C_out, output S, output G, output P, input InA, input InB,input C_In);
wire G_n;
wire B;
xor x1(P,InA,InB);
xor x2(S,P,C_In);
nand n1(G_n,InA,InB);
nand n2(B,P,C_In);
not not1(G,G_n);
nand n3(C_out,B,G_n);
endmodule

// 4Bit CLA Unit
module CLU_4bit(output [3:0] C_out, input [3:0] G, input [3:0] P, input C_In);
  wire[3:0] ab;
  wire[3:0] G_n2;
  nand Nand1(ab[0],P[0],C_In);
  not not2[3:0](G_n2,G);
  nand Nand4(C_out[0],G_n2[0],ab[0]);
  nand Nand2[2:0](ab[3:1],P[3:1],C_out[2:0]);
  nand Nand3[2:0](C_out[3:1],G_n2[3:1],ab[3:1]);
endmodule




// 16 bit CLA adder
module CLA_16bit(output Carry_out, output reg [19:0] X, input [19:0] A_old, input [19:0] B_old);
  reg [19:0] A,B;
 // always @(*) begin if (A_old[15] == 1) A = {1'b0,~A_old[14:0] + 1}; else A = A_old; end
  always @(*) begin 
    case({A_old[19],B_old[19]})
      2'b00: begin A = {1'b0,A_old[18:0]}; B = {1'b0,B_old[18:0]}; end
      2'b11: begin  A = {1'b0,A_old[18:0]}; B = {1'b0,B_old[18:0]}; end
      2'b10: begin A = {1'b1,~A_old[18:0] + 1}; B = B_old; end
      2'b01: begin A = A_old; B = {1'b1,~B_old[18:0] + 1}; end
    endcase
  end 
  wire [19:0]Sum;
  wire[19:0] G,P;
  wire[18:0] c_out;
  CLU_4bit CLU_16bit[4:0](.C_out({Carry_out,c_out[18:0]}), .G(G[19:0]), .P(P[19:0]), .C_In({c_out[15],c_out[11],c_out[7],c_out[3],1'b0}));
  FAGP_1bit full_add[19:0](.S(Sum[19:0]), .G(G[19:0]), .P(P[19:0]), .InA(A[19:0]), .InB(B[19:0]), .C_In({c_out[18:0],1'b0}));
  //assign Sum[16] = Carry_out;
// assign Sum_n = {1'b1,~Sum[14:0] + 1};
 assign greater = (A_old[18:0] > B_old[18:0])?1:0;
 always @(*) begin
   case({A_old[19],B_old[19]})
     2'b00: begin if (Sum[19] == 1) X = 17'hfffff; else X = Sum; end
     2'b11: begin if (Sum[19] == 1) X = 17'h7ffff; else X = {1'b1,Sum[18:0]}; end
     2'b10: begin if (greater) X = {1'b1,~Sum[18:0]  +1}; else X = Sum; end
     2'b01: begin if (~greater) X = {1'b1,~Sum[18:0]  +1}; else X = Sum; end
     endcase
   end
   
endmodule



module t_PIIR;
  wire [15:0] AD;
  wire  ALE, RD, WR;
  reg  CE, PU, Clk1, Clk2, CFG;
  reg  [3:0] Const;
  reg [15:0] AD_reg;
  reg en, en_next;

// Internal Variables
  integer count, count1;
  reg result;

 PIIR piir (AD, ALE, RD, WR, CE, PU, Clk1, Clk2, Const, CFG);
 
 /*assign AD = ($time == 1) ? 16'b0000_0000_0000_0000: ($time == 19) ? 16'b0100_0000_0000_0000 : ($time == 29) ? 16'b0100_0000_0000_0000 : ($time == 39) ? 16'b0100_0000_0000_0000 :  
 ($time == 49) ? 16'b0100_0000_0000_0000 : ($time == 59) ? 16'b0100_0000_0000_0000 : ($time == 69) ? 16'b0100_0000_0000_0000 : ($time == 79) ? 16'b0100_0000_0000_0000 : 
 ($time == 89) ? 16'b0100_0000_0000_0000 : ($time == 99) ? 16'b1100_0000_0000_0000 : ($time == 109) ? 16'b0100_0000_0000_0000 : ($time == 119) ? 16'b1111_0000_1111_0000 : 
 (ALE && (AD == 16'b 1111_0000_1111_0000)) ? 16'b 0000_0000_0000_0000 : 16'bZ ;*/
 
 
assign AD = en ? AD_reg: 16'bz ;


 // Initialization
 initial
  begin
    #1
    Clk1=0; Clk2 = 1; 
    CE = 0; PU= 0; CFG = 1; Const = 0; AD_reg = 0;
  end
  
  always
    begin
      #7
      Clk1= ~Clk1;
    end
    
  always
    begin
      #4
      Clk2= ~Clk2;
    end
  
  always@(posedge Clk1)
  begin
    
    en<= en_next;
    
  end
  
  always@(*) begin 
    if(!CFG)
      en_next<=1;
    
    else if( ALE )  
        en_next<=1;
      else
        en_next<=0;
        
  end
      
   initial
    begin
      
      #1 ;
      #3  CE = 1;
      #7  CFG = 0;
      #5  Const = 1;  AD_reg = 16'b 0100_0000_0000_0000;  // a1
      #10 Const = 2;  AD_reg = 16'b 0100_0000_0000_0001;  // a2
      #4  Const = 5;  AD_reg = 16'b 0100_0000_0000_0010;  // y1
      #10 Const = 6;  AD_reg = 16'b 0100_0000_0000_0100;  // y2
      #10 Const = 8;  AD_reg = 16'b 0100_0000_0000_1000;  // b0
      #3  Const = 9;  AD_reg = 16'b 0100_0000_0001_0000;  // b1
      #10 Const = 10; AD_reg = 16'b 0100_0000_0010_0000;  // b2
      #10 Const = 12; AD_reg = 16'b 0100_0000_0100_0000;  // x0
      #7  Const = 13; AD_reg = 16'b 1100_0000_0000_0000;  // x1
      #10 Const = 14; AD_reg = 16'b 0100_0000_0000_0011;  // x2
      #8  Const = 15; AD_reg = 16'b 1111_0000_1111_0000;  // Addr
      #8  Const = 2;  AD_reg = 16'b 1111_0000_1001_0000;  // a2
      
      #15 CFG =1;
      
      #10;
      
      @(posedge Clk1)
      begin
        
        AD_reg <= 16'hceff; 
      
    end
    
    #10 @(posedge Clk1)
    begin
      AD_reg <= 16'habff;
    end
    
    #10 @(posedge Clk1)
    begin
      AD_reg <= 16'hcdff;
    end
      
      
      /*while(count!=0)  
      begin
      #2 if(ALE && (AD == 16'b 1111_0000_1111_0000))
            begin
              count = 0;
              AD_reg = 16'b 0000_0000_0000_0110;   // New X(0)
            end
            
          else  
            begin
              count = count - 1;
            end
      end
      #2 count1 = 15;*/
      
      while(count1!=0)  
      begin
      #2 if(WR)
            begin
              count1 = 0;
              result = AD;   // Y(0)
            end
            
         else
            count1 = count1 - 1;
      end
      
    end
    
    
    initial
      begin
        $monitor("At t=%g  Ce=%b  Pu=%b  Cfg=%b  clk1=%b  clk2=%b  const=%d  ale=%b  rd=%b  wr=%b  ad=%b  ", $time, CE, PU, CFG, Clk1, Clk2, Const, ALE, RD, WR, AD);
      end
      
    initial
      begin
        $stop(2000);
      end
       
  endmodule


  


