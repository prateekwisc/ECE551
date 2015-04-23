module FAGP_1bit(C_out,S,G,P,InA,InB,C_in);
  output C_out,S,G,P;
  input C_in,InA,InB;
  wire N1,N2,N3,N4,N5,N6,N7,N8;
  xor X1(N1,InA,InB);
  xor X2(S,C_in,N1);
  nand A1(N2,N1,C_in);
  not B1(N4,N2);
  nand A2(N3,InA,InB);
  not B2(N5,N3);
  nor O1(N6,N4,N5);
  not B3(C_out,N6);
  nor O2(N7,InA,InB);
  not B4(P,N7);
  nand A3(N8,InA,InB);
  not B5(G,N8);
endmodule

module CLU_4bit(C_out,G,P,C_in);
  output [3:0] C_out;
  input C_in;
  input [3:0] G;
  input [3:0] P;
  wire N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,N10,N11;
  
  nand A0(N0,P[0],C_in);
  not B0(N4,N0);
  nor c1(N8,G[0],N4);
  not B4(C_out[0],N8);
  
  nand A1(N1,P[1],C_out[0]);
  not B1(N5,N1);
  nor c2(N9,G[1],N5);
  not B5(C_out[1],N9);
  
  nand A2(N2,P[2],C_out[1]);
  not B2(N6,N2);
  nor c3(N10,G[2],N6);
  not B6(C_out[2],N10);
  
  nand A3(N3,P[3],C_out[2]);
  not B3(N7,N3);
  nor c4(N11,G[3],N7);
  not B7(C_out[3],N11);
  endmodule

module CLA_4bit(Sum,C_out,P,G,A,B,C_In);
output [3:0] Sum;
output [3:0]C_out;

input [3:0] A;
input [3:0] B;
input [3:0] P;
input [3:0] G;
input C_In;
wire [3:0]p,g;
wire [3:1]c;

FAGP_1bit FAGP[3:0](.P(p),.G(g),.S(Sum),.InA(A),.InB(B),.C_in(C_in));
CLU_4bit CLU1(.G(g),.P(p),.C_in(C_in),.C_out(C_out[3:0]));

endmodule

module CLA_16bit(output Carry_out,input[15:0]A1,input[15:0]B1,output[15:0]Sum1,input Carry_In);
wire c3,p3,g3,c7,p7,g7,c11,p11,g11,p15,g15;
  
  nand D0(n0,p3,Carry_In);
  not b0(n4,n0);
  nand D1(n1,p7,n4);
  not b1(n5,n1);
  nand D2(n2,p11,n5);
  not b2(n6,n2);
  nand D3(n3,p15,n6);
  not b3(n7,n3);
  
  
  nor C1(n8,g3,n4);
  not b4(c3,n8);
  nor C2(n9,g7,n5);
  not b5(c7,n9);
  nor C3(n10,g11,n6);
  not b6(c11,n10);
  nor C4(n11,g15,n7);
  not B7(Carry_out,n11);
  
CLA_4bit CLA1(Sum1[3:0],,p3,g3,A1[3:0],B1[3:0],Carry_In);
CLA_4bit CLA2(Sum1[7:4],,p7,g7,A1[7:4],B1[7:4],);
CLA_4bit CLA3(Sum1[11:8],,p11,g11,A1[11:8],B1[11:8],);
CLA_4bit CLA4(Sum1[15:12],Carry_out,p15,g15,A1[15:12],B1[15:12],); 
endmodule

  //Test bench module//
module t_CLA_16bit; //module instantiation//
   reg Carry_In;
   reg [15:0] A1;
   reg [15:0] B1;
   wire[15:0] Sum1;
   wire Carry_out;
   CLA_16bit CLA_1(Carry_out,A1,B1,Sum1,Carry_In);
  initial
   begin
     repeat(100)
     begin
       A1= $random;
       B1= $random;
       Carry_In= $random;
       
       #1000;
     $monitor("A1= %b,B1= %b,Carry_In= %b",A1,B1,Carry_In);
   end
   end
 endmodule