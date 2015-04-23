module cond_oper(a,b,c,d,z);
parameter N = 8;
output [N-1:0]z;
input [N-1:0]a,b,c,d;
reg [N-1:0]z;
always@(a or b or c or d)
begin
  if(a+b<24)
z <=c;
else 
  z<=d;
  end
  
endmodule


