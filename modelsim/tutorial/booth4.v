module booth_mul(M,Q,Cout);
                 
input [3:0] M,Q;
output [7:0] Cout;
reg[7:0] Cout,rM;
reg[2:0] n;
reg[3:0] rQ;
reg C;

always @(M or Q)
   begin
       {rQ,C}={Q,1'b0};
        rM={4'b0000,M};
        Cout=8'b0;
        
  for(n=0;n<3'b101;n=n+1)
       begin
          case({rQ[0],C})
              2'b10: Cout=Cout-rM;
              2'b01: Cout=Cout+rM;
              default: Cout=Cout;
      endcase
            {rQ,C}={rQ,C}>>1;
            rM=rM<<1;
        end
    end
endmodule

module tb_mul;
wire [3:0]a,b;
reg clk;
wire [7:0]z;
reg[23:0] data;
reg [3:0] j;

assign a=data[23:20];
assign b=data[19:16];
 
initial
begin
clk=0;
#5 data=24'b 1001_1110_0110_1001_0011_1111;
end
always #50 clk=~clk;
always @ (posedge clk)
          begin 
            for(j=0;j<4'b1000;j=j+1)
               data={data[22:0],data[23]};
           end
       
booth_mul m(.Q(a),.M(b),.Cout(z));
endmodule