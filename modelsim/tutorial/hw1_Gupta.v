module FAGP_1bit(C_out,S,G,P,InA,InB,C_in);
  output C_out,S,G,P;
  input C_in,InA,InB;
  wire N1,N2,N3,N4,N5,N6,N7,N8;
  xor #5 X1(N1,InA,InB);
  xor #5 X2(S,C_in,N1);
  nand #5 A1(N2,N1,C_in);
  not #5 B1(N4,N2);
  nand #5 A2(N3,InA,InB);
  not #5 B2(N5,N3);
  nor #5 O1(N6,N4,N5);
  not #5 B3(C_out,N6);
  nor #5 O2(N7,InA,InB);
  not #5 B4(P,N7);
  nand #5 A3(N8,InA,InB);
  not #5 B5(G,N8);
endmodule

  //Test bench module for FAGP 1 bit//
module t_FAGP_1bit; //module instantiation//
   reg C_in,InA,InB;
   wire C_out,S,G,P;
   FAGP_1bit FAGP_1(C_out,S,G,P,InA,InB,C_in);
   initial
   begin
     #5 InA=0;InB=0;C_in=0;
     #5 InA=1;InB=0;C_in=0;
     #5 InA=0;InB=1;C_in=0;
     #5 InA=1;InB=1;C_in=0;
     #5 InA=0;InB=0;C_in=1;
     #5 InA=1;InB=0;C_in=1;
     #5 InA=0;InB=1;C_in=1;
     #5 InA=1;InB=1;C_in=1;
     #5 $stop;
   end
 endmodule
//4-bit carry look ahead unit module//
module CLU_4bit(C_out,G,P,C_in);
  output [3:0] C_out;
  input C_in;
  input [3:0] G;
  input [3:0] P;
  wire N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,N10,N11;
  
  nand #5 A0(N0,P[0],C_in);
  not #5 B0(N4,N0);
  nor #5 c1(N8,G[0],N4);
  not #5 B4(C_out[0],N8);
  
  nand #5 A1(N1,P[1],C_out[0]);
  not #5 B1(N5,N1);
  nor #5 c2(N9,G[1],N5);
  not #5 B5(C_out[1],N9);
  
  nand #5 A2(N2,P[2],C_out[1]);
  not #5 B2(N6,N2);
  nor #5 c3(N10,G[2],N6);
  not #5 B6(C_out[2],N10);
  
  nand #5 A3(N3,P[3],C_out[2]);
  not #5 B3(N7,N3);
  nor #5 c4(N11,G[3],N7);
  not #5 B7(C_out[3],N11);
  endmodule

 //Test bench module for 4bit carry look ahead unit//
   module t_CLU_4bit; //module instantiation//
   reg C_in;
   reg [3:0] G;
   reg [3:0] P;
   wire[3:0] C_out;
   
     
 // 9 bit input combinations - Counter
 reg [8:0] input_counter;
 
 // Instantiating the module
 CLU_4bit CLU_1(C_out,G,P,C_in);
 
 initial
 begin
 
 // Initializing inputs
 C_in=0; G=4'b0000; P=4'b0000;
 
 // Initializing counter
 input_counter = 'b0;
 
 end
 
 always
 begin
 #100 input_counter = input_counter + 1;
 end
 
 always #100 G = input_counter[8:5];
 always #100 P = input_counter[4:1];
 always #100 C_in = input_counter[0];
 
 // To terminate the counter
 always #51200 $stop;
 
 //output
 initial
 begin
 
 #200;
 $monitor("C_out=%b : G=%b P=%b C_In=%b", C_out,G,P, C_in );
 
   end
 endmodule
//16 bit one level carry look ahead adder module//
module CLA_16bit(output Carry_out,input[15:0]A,input[15:0]B,output[15:0]Sum,input Carry_In);
wire [3:0] c0,c1,c2,c3;
wire [3:0] p0,p1,p2,p3,g0,g1,g2,g3;
  
FAGP_1bit FA0(,Sum[0],g0[0],p0[0],A[0],B[0],Carry_In);
FAGP_1bit FA1(,Sum[1],g0[1],p0[1],A[1],B[1],c0[0]);
FAGP_1bit FA2(,Sum[2],g0[2],p0[2],A[2],B[2],c0[1]);
FAGP_1bit FA3(,Sum[3],g0[3],p0[3],A[3],B[3],c0[2]);

CLU_4bit CLU0(c0[3:0],g0[3:0],p0[3:0],Carry_In);

FAGP_1bit FA4(,Sum[4],g1[0],p1[0],A[4],B[4],c0[3]);
FAGP_1bit FA5(,Sum[5],g1[1],p1[1],A[5],B[5],c1[0]);
FAGP_1bit FA6(,Sum[6],g1[2],p1[2],A[6],B[6],c1[1]);
FAGP_1bit FA7(,Sum[7],g1[3],p1[3],A[7],B[7],c1[2]);

CLU_4bit CLU1(c1[3:0],g1[3:0],p1[3:0],c0[3]);

FAGP_1bit FA8(,Sum[8],g2[0],p2[0],A[8],B[8],c1[3]);
FAGP_1bit FA9(,Sum[9],g2[1],p2[1],A[9],B[9],c2[0]);
FAGP_1bit FA10(,Sum[10],g2[2],p2[2],A[10],B[10],c2[1]);
FAGP_1bit FA11(,Sum[11],g2[3],p2[3],A[11],B[11],c2[2]);

CLU_4bit CLU2(c2[3:0],g2[3:0],p2[3:0],c1[3]);

FAGP_1bit FA12(,Sum[12],g3[0],p3[0],A[12],B[12],c2[3]);
FAGP_1bit FA13(,Sum[13],g3[1],p3[1],A[13],B[13],c3[0]);
FAGP_1bit FA14(,Sum[14],g3[2],p3[2],A[14],B[14],c3[1]);
FAGP_1bit FA15(,Sum[15],g3[3],p3[3],A[15],B[15],c3[2]);

CLU_4bit CLU3({Carry_out,c3[2:0]},g3[3:0],p3[3:0],c2[3]);

endmodule

  //Test bench module for 16 bit one level carry look ahead adder module//
module t_CLA_16bit; //module instantiation//
   reg Carry_In;
   reg [15:0] A;
   reg [15:0] B;
   wire[15:0] Sum;
   wire Carry_out;
   CLA_16bit CLA_1(Carry_out,A,B,Sum,Carry_In);
  initial
   begin
     repeat(4096)
     begin
       A= $random;
       B= $random;
       Carry_In= $random;
       
       #1000;
     $dispaly("A1= %b,B1= %b,Sum= %b",A,B,Sum); 
     $monitor("A1= %b,B1= %b,Carry_In= %b",A,B,Carry_In);
     
   end
   end
 endmodule
