// The MAC unit takes 16bit X,b0,b1,b2,a1,a2 as input, works on CLk1, out_awaited as clk-enable for doing calculations.
// Assuming combinational multiplier for now.. If pipelined used, will give clk as an input to multiplier and multiplier will output an
// internal signal to indicate that multiplier output is ready now... That out_mult_ready will be ANDed with out_awaited to indicate
// that if any of them is 0, then the clk_en to shift register will be 0 and it will not do the shifting part... 

module MAC(X_0,X_1,X_2,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);
  input [15:0]X_0,X_1,X_2,b0,b1,b2,a1,a2,Y_1,Y_2;
  input out_awaited,Clk1;
  output reg out_ready;
  output  [15:0]Y;
  wire [15:0] a1_n,a2_n,xb0,xb1,xb2;
  wire[15:0]  ya1,ya2;
  wire [19:0]xbo1,yao,yao_new; 
  wire [19:0]Y_old;
  wire [19:0]xbo2;
  //assign a1_n = ~(a1) + 1;
//  assign a2_n = ~(a2) + 1;


  mult_resbooth mult1(xb0,X_0,b0);
  mult_resbooth mult2(xb1,X_1,b1);
  mult_resbooth mult3(xb2,X_2,b2);
  mult_resbooth mult5(ya1,Y_1,a1);
  mult_resbooth mult6(ya2,Y_2,a2);
  CLA_16bit add1(.X(xbo1),.A({xb1[15],xb1[15],xb1[15],xb1[15],xb1}),.B({xb2[15],xb2[15],xb2[15],xb2[15],xb2}));
  CLA_16bit add2(.X(xbo2),.A(xbo1),.B({xb0[15],xb0[15],xb0[15],xb0[15],xb0}));
  CLA_16bit add3(.X(yao),.A({ya1[15],ya1[15],ya1[15],ya1[15],ya1}),.B({ya2[15],ya2[15],ya2[15],ya2[15],ya2}));
  assign yao_new= ~(yao)+1;
  CLA_16bit add4(.X(Y_old),.A(xbo2),.B(yao_new));
  assign Y = Y_old[15:0];
  //always @(*)
//        begin
//          if (Y_old[15]==0 && xbo2[15]==1&& yao_new[15]==1)
//          Y=16'h8001; 
//        else if (Y_old[15] && xbo2[15]==0&& yao_new[15]==0 )
//          Y=16'h7fff;
//          else Y=Y_old[15:0];
//          end
  
  
  always@(posedge Clk1) begin
    if(~out_awaited) begin
      out_ready <= 0;
    end 
    else out_ready <= 1; 
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
  output [15:0] Y;
  wire [31:0] m_res;
  mod_booth_multiplier m1(m_res,A,B);
  assign Y = m_res[30:15] + m_res[14];
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
module CLA_16bit(output Carry_out, output [19:0] X, input [19:0] A, input [19:0] B);
  wire [19:0]Sum;
  wire[19:0] G,P;
  wire[18:0] c_out;
  CLU_4bit CLU_16bit[4:0](.C_out({Carry_out,c_out[18:0]}), .G(G[19:0]), .P(P[19:0]), .C_In({c_out[15],c_out[11],c_out[7],c_out[3],1'b0}));
  FAGP_1bit full_add[19:0](.S(Sum[19:0]), .G(G[19:0]), .P(P[19:0]), .InA(A[19:0]), .InB(B[19:0]), .C_In({c_out[18:0],1'b0}));
  //assign Sum[16] = Carry_out;
 assign X = Sum;
    //always @(*)
//        begin
//          if (Sum[15]==0 && A[15]==1&&B[15]==1)
//          X=16'h8001; 
//        else if (Sum[15]==1 && A[15]==0&&B[15]==0 )
//          X=16'h7fff;
//          else X=Sum;
//          end
endmodule
//
//// 18 bit CLA adder
//module CLA_18bit(output Carry_out, output [17:0] X, input [16:0] A, input [16:0] B);
//  wire [17:0]Sum;
//  wire[15:0] G,P;
//  wire[14:0] c_out;
//  CLU_4bit CLU_16bit[3:0](.C_out({Carry_out,c_out[14:0]}), .G(G[15:0]), .P(P[15:0]), .C_In({c_out[11],c_out[7],c_out[3],1'b0}));
//  FAGP_1bit full_add[15:0](.S(Sum[15:0]), .G(G[15:0]), .P(P[15:0]), .InA(A[15:0]), .InB(B[15:0]), .C_In({c_out[14:0],1'b0}));
//  assign Sum[17] = Carry_out;
//  assign X = Sum;
//    //always @(*)
////        begin
////          if (Sum[15]==0 && A[15]==1&&B[15]==1)
////          X=16'h8001; 
////        else if (Sum[15]==1 && A[15]==0&&B[15]==0 )
////          X=16'h7fff;
////          else X=Sum;
////          end
//endmodule
//
//// 19 bit CLA adder
//module CLA_19bit(output Carry_out, output [18:0] X, input [17:0] A, input [17:0] B);
//  wire [18:0]Sum;
//  wire[15:0] G,P;
//  wire[14:0] c_out;
//  CLU_4bit CLU_16bit[3:0](.C_out({Carry_out,c_out[14:0]}), .G(G[15:0]), .P(P[15:0]), .C_In({c_out[11],c_out[7],c_out[3],1'b0}));
//  FAGP_1bit full_add[15:0](.S(Sum[15:0]), .G(G[15:0]), .P(P[15:0]), .InA(A[15:0]), .InB(B[15:0]), .C_In({c_out[14:0],1'b0}));
//  assign Sum[18] = Carry_out;
//  assign X = Sum;
//    //always @(*)
////        begin
////          if (Sum[15]==0 && A[15]==1&&B[15]==1)
////          X=16'h8001; 
////        else if (Sum[15]==1 && A[15]==0&&B[15]==0 )
////          X=16'h7fff;
////          else X=Sum;
////          end
//endmodule


module t_MAC ();
  
  reg [15:0]X_0,X_1,X_2,b0,b1,b2,a1,a2,Y_1,Y_2;
  reg out_awaited, Clk1;
  wire out_ready;
  wire [15:0]Y;
      
  MAC DUT0(X_0,X_1,X_2,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);
  always
  #10  Clk1 = ~Clk1;

  initial 
  begin
    $display($time, "Starting the simulation");
    Clk1 = 1'b0;
    out_awaited = 1'b0;
    
#20 out_awaited = 1'b1;  
  //case 0
    X_0 = 16'b 0100_0000_0000_0000; X_1 = 16'b 1100_0000_0000_0000; X_2 = 16'b 0100_0000_0000_0000;b0 = 16'b 0100_0000_0000_0000;
    b1 = 16'b 0100_0000_0000_0000;b2 = 16'b 0100_0000_0000_0000; a1 = 16'b 0100_0000_0000_0000; a2= 16'b 0100_0000_0000_0000;
    Y_1 = 16'b 0100_0000_0000_0000;Y_2 = 16'b 0100_0000_0000_0000;
    
    #10 $display("Y = %b, out_ready = %b", Y, out_ready);
    
  //case 0
#100  X_0 = 16'b 1100_0000_0000_0000; X_1 = 16'b 1100_0000_0000_0000; X_2 = 16'b 0100_0000_0000_0000;b0 = 16'b 0100_0000_0000_0000;
    b1 = 16'b 0100_0000_0000_0000;b2 = 16'b 0100_0000_0000_0000; a1 = 16'b 0100_0000_0000_0000; a2= 16'b 0100_0000_0000_0000;
    Y_1 = 16'b 0100_0000_0000_0000;Y_2 = 16'b 0100_0000_0000_0000;
    
    #10 $display("Y = %b, out_ready = %b", Y, out_ready);

#100  X_0 = 16'b 0000_0000_0000_0000; X_1 = 16'b 0000_0000_0000_0000; X_2 = 16'b 0000_0000_0000_0000;b0 = 16'b 0000_0000_0000_0000;
    b1 = 16'b 0000_0000_0000_0000;b2 = 16'b 0000_0000_0000_0000; a1 = 16'b 0000_0000_0000_0000; a2= 16'b 0000_0000_0000_0000;
    Y_1 = 16'b 0000_0000_0000_0000;Y_2 = 16'b 0000_0000_0000_0000;
    
#100  X_0 = 16'b 1000_0000_0000_0001; X_1 = 16'b 1000_0000_0000_0001; X_2 = 16'b 1000_0000_0000_0001;b0 = 16'b 1000_0000_0000_0001;
    b1 = 16'b 1000_0000_0000_0001;b2 = 16'b 1000_0000_0000_0001; a1 = 16'b 1000_0000_0000_0001; a2= 16'b 1000_0000_0000_0001;
    Y_1 = 16'b 1000_0000_0000_0001;Y_2 = 16'b 1000_0000_0000_0001; 
    
    #100  X_0 = 16'b 0111_1111_1111_1111; X_1 = 16'b 0111_1111_1111_1111; X_2 = 16'b 0111_1111_1111_1111;b0 = 16'b 1000_0000_0000_0001;
    b1 = 16'b 1000_0000_0000_0001;b2 = 16'b 1000_0000_0000_0001; a1 = 16'b 0111_1111_1111_1111; a2= 16'b 0111_1111_1111_1111;
    Y_1 = 16'b 0111_1111_1111_1111;Y_2 = 16'b 0111_1111_1111_1111;   
    
    #10 $display("Y = %b, out_ready = %b", Y, out_ready);
  #100 $stop();
  end
 
endmodule
  