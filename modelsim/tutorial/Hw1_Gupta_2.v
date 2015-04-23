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
  //Test bench module//
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