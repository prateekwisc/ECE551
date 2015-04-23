module booth_mul(M,Q,Cout);
                 
input [15:0] M,Q;
output [31:0] Cout;
reg[31:0] Cout,rM;
reg[14:0] n;
reg[15:0] rQ;
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