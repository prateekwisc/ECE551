module MAC(X_0,X_1,X_2,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);
  input [15:0]X_0,X_1,X_2,b0,b1,b2,a1,a2,Y_1,Y_2;
  input out_awaited,Clk1;
  output reg out_ready;
  reg[1:0] count;
  output [15:0]Y;
  reg [15:0] m1,m2,m3,m4;
  wire [19:0] add_res1,m_out1,m_out2;
  reg [19:0] add_2;
  wire [19:0] add_final;
  reg [19:0] add_res2;
  wire[15:0] a1_n,a2_n;
  assign a1_n = {~a1[15],a1[14:0]};
  assign a2_n = {~a2[15],a2[14:0]};
  mult_resbooth mult1(m_out1,m1,m2);
  mult_resbooth mult2(m_out2,m3,m4);
  CLA_16bit add1(.X(add_res1),.A_old(m_out1),.B_old(m_out2));
  CLA_16bit add2(.X(add_final),.A_old(add_2),.B_old(add_res1));
  always @(posedge Clk1) begin
  if (~out_awaited)begin count <= 0; add_res2 <= 20'h00000; end
  else begin count <= count + 1; add_res2 <= add_final;end
  end
  always @(*) begin
  case(count)
    3'b00: begin  m1 = X_0; m2 = b0; m3 = X_1; m4 = b1; end
    3'b01: begin m1 = Y_2; m2 = a2_n; m3 = Y_1; m4 = a1_n; end
    3'b10: begin m1 = X_2; m2 = b2; m3 = 16'h0000; m4 = 16'h0000; end
    default: begin m1 = 16'h0000; m2 = 16'h0000; m3 = 16'h0000; m4 = 16'h0000; end 
  endcase 
end 
 always @(*) begin
   case (count) 
     2'b00: add_2 = 20'h00000;
     2'b11: add_2 = 20'h00000;
     default: add_2 = add_res2;
   endcase
 end
 
  always @(posedge Clk1) begin
    if (count == 1) out_ready <= 1;
    else out_ready <= 0;
    end
    assign Y = add_final[19:4];
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
     2'b10: begin if (greater) X = {1'b1,~Sum[18:0]+1}; else X = Sum; end
     2'b01: begin if (~greater) X = {1'b1,~Sum[18:0]+1}; else X = Sum; end
     endcase
   end
   
endmodule


module t_MACchange ();

  

  reg [15:0]X_0,X_1,X_2,b0,b1,b2,a1,a2,Y_1,Y_2;

  reg out_awaited, Clk1;

  wire out_ready;

  wire [15:0]Y;

      

  MAC DUT0(X_0,X_1,X_2,out_awaited,out_ready,Y,Clk1,b0,b1,b2,a1,a2,Y_1,Y_2);

  always

  #5  Clk1 = ~Clk1;



  initial 

  begin

    Clk1 = 1'b0;
#5 out_awaited = 1'b0;
#15    out_awaited = 1'b1;

    

    $display($time, "Starting the simulation");

    

    X_0 = 16'h d609; X_1 = 16'h 5663; X_2 = 16'h 7b0d;b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 3524;Y_2 = 16'h 5e81;



    #400 out_awaited = 1'b0;

#600 out_awaited = 1'b1;  

  //case 0

    

    X_0 = 16'h 8465; X_1 = 16'h d609; X_2 = 16'h 5663; b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 0b57; Y_2 = 16'h 3524;



    #10 $display("Y = %b, out_ready = %b", Y, out_ready);

   

 

  //case 0

#900  X_0 = 16'h 5212; X_1 = 16'h 8465; X_2 = 16'h d609; b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 8fc7; Y_2 = 16'h 0b57;

    

    #10 $display("Y = %b, out_ready = %b", Y, out_ready);

      //case 1

#1200  X_0 = 16'h e301; X_1 = 16'h 5212; X_2 = 16'h 8465;b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 0356;Y_2 = 16'h 8fc7;



    #10 $display("Y = %b, out_ready = %b", Y, out_ready);



#1500  X_0 = 16'h cd0d; X_1 = 16'h e301; X_2 = 16'h 5212;b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 14cb;Y_2 = 16'h 0356;

    

    #10 $display("Y = %b, out_ready = %b", Y, out_ready);



#1800  X_0 = 16'h f176; X_1 = 16'h cd0d; X_2 = 16'h e301;b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 8f2f;Y_2 = 16'h 14cb;

    

    #10 $display("Y = %b, out_ready = %b", Y, out_ready);

    

#2100  X_0 = 16'h cd3d; X_1 = 16'h f176; X_2 = 16'h cd0d;b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 156c;Y_2 = 16'h 8f2f;



    #10 $display("Y = %b, out_ready = %b", Y, out_ready);



#2400  X_0 = 16'h 57ed; X_1 = 16'h cd3d; X_2 = 16'h f176;b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 0087;Y_2 = 16'h 156c;



    #10 $display("Y = %b, out_ready = %b", Y, out_ready);

  



#2700  X_0 = 16'h f78c; X_1 = 16'h 57ed; X_2 = 16'h cd3d;b0 = 16'h 9000;

    b1 = 16'h 1000;b2 = 16'h 9000; a1 = 16'h 1000; a2= 16'h 9000;

    Y_1 = 16'h 83d9;Y_2 = 16'h 0087;



    #10 $display("Y = %b, out_ready = %b", Y, out_ready);

  

  

  #3000 $stop();

  end

 

endmodule




