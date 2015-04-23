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

  //Test bench module//
module t_CLA_16bit; //module instantiation//
   reg Carry_In;
   reg [15:0] A;
   reg [15:0] B;
   wire[15:0] Sum;
   wire Carry_out;
   CLA_16bit CLA_1(Carry_out,A,B,Sum,Carry_In);
  initial
   begin
     repeat(100)
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