module add3_FA(y,cout,a,b,c);
  output y,cout;
  input a,b,c;
  wire c3,c1,c2;
  
  xor x1 (c1,a,b);
  xor x2 (y,c1,c);
  
  and a1 (c2,a,b);
  and a2 (c3,c1,c);
  or o1 (cout,c2,c3);
  
endmodule

module add3_struct(Y,A,B,C);
parameter N = 8;
output [N-1:0]Y;
input [N-1:0]A,B,C;
wire [N-1:1]ci1,ci2;
wire [N-1:0]carry;
wire cout1,cout2;


add3_FA fa0[N-1:0](carry,{cout1,ci1[N-1:1]},A,B,{ci1[N-1:1],1'b0});
add3_FA fa1[N-1:0](Y,{cout2,ci2[N-1:1]},carry,C,{ci2[N-1:1],1'b0});
endmodule
