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
  
  //Test bench module//
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