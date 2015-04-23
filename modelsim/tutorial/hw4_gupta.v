module add3_FA(y,cout,a,b,c);
  output y;
  input a,b,c;
  
  wire cout,c1,c2;
  xor x1 (y,a,b,c);
  xor x2 (c1,a,b);
  and a1 (c2,a,b);
  and a2 (c3,c1,c);
  or(cout,c1,c3);
endmodule

module add3_struct(y,a,b,c);
parameter N = 8;
output [N-1:0]y;
input [N-1:0]a,b,c;
wire [N-1:1]ci;
wire cout;
reg cin;

add3_FA fa1[N-1:0](y,{cout,ci[N-1:1]},a,b,{ci[N-1:1],1'b0});
endmodule





/*module add3_case(y,a,b,c);
  
parameter N = 8;
output [N-1:0]y;
input [N-1:0]a,b,c;
wire [(N/2)-1:1]ci1,ci2;
wire tmp[N-1:0]
wire cout1,cout2;
reg cin;

generate
begin 
 if(N % 2 == 0)
     2bit_FA fa0[(N/2)-1:0](tmp[N-2:0],{cout1,ci1[N/2-1:0]},a[N-2:0],b[N-2:0],{ci1[N/2-1:1],1'b0});
     2bit_FA fa1[(N/2)-1:0](y[N-2:0],{cout2,ci2[(N/2)-1:0]},tmp[N-2:0],c[N-2:0],{ci2[(N/2)-1:1],1'b0});
     2bit_FA fa2(tmp[N-1],,a[N-1],b[N-1],cout1);
     2bit_FA fa3(y[N-1],,tmp[N-1],c[N-1],cout2);
 else begin
      2bit_FA fa0[(N/2)-1:0](tmp,{cout1,ci1[(N/2)-1:1]},a,b,{ci1[(N/2)-1:1],1'b0});
      2bit_FA fa1[(N/2)-1:0](y,{cout2,ci2[(N/2)-1:1]},temp,c,{carry2[(N/2)-1:1],1'b0});
    end
    endgenerate     
 endmodule */
 
 
module add3_case(y,a,b,c);
  
parameter N = 8;
output [N-1:0]y;
input [N-1:0]a,b,c;
wire [(N/2)-1:0]ci1,ci2;
wire [N/2:0]ci3,ci4;
wire [N-1:0]tmp1;
wire [N:0]tmp2;
wire y0;
wire cout1,cout2;
wire tmp;
reg cin;

//LV_pragma translate_off
generate
 
 if(N % 2 == 0) begin
     bit2_FA fa0[(N/2)-1:0](tmp1,{cout1,ci1[N/2-1:1]},a,b,ci1);
     bit2_FA fa1[(N/2)-1:0](y,{cout2,ci2[(N/2)-1:1]},tmp1,c,ci2);
   end
     else begin
      bit2_FA fa2[(N/2):0](tmp2,{cout1,ci3[(N/2):1]},{1'b0,a},{1'b0,b},ci3);
      bit2_FA fa3[(N/2):0]({tmp,y},{cout2,ci4[(N/2):1]},tmp2,{1'b0,c},ci4);
    end
    
    endgenerate
//LV_pragram translate_on    
 endmodule

module bit2_FA(y,a,b,c);
  output reg[1:0] y;
  input [1:0]a,b;
  input c;
  reg cout;
  
  
   always@(a,b,c)
  begin 
  
  //case({a[1],a[0],b[1],b[0],c})
  case({a,b,c})  
    5'b00001:
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end 
    
    5'b00010:
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end 
     
     5'b00011:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b00100:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b00101:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00110:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00111:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01000:
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end
     
     5'b01001:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b01010:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b01011:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01100:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01101:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01110:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01111:
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10000:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b10001:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10010:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10011:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b10100:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b10101:
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10110:  //22
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10111:  //23
    begin
     y <= 2'b10; 
     cout <= 1'b1;
     end
     
     5'b11000: //24
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b11001:  //25
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b11010:  //26
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b11011:  //27
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b11100: //28
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b11101:  //29
    begin
     y <= 2'b10; 
     cout <= 1'b1;
     end
     
     5'b11110:  //30
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b11111:  //31
    begin
     y <= 2'b11; 
     cout <= 1'b1;
     end
     
     5'b00000:  //0
    begin
     y <= 2'b00; 
     cout <= 1'b0;
     end
 endcase
 end
endmodule


module add3_parcase(y,a,b,c);
  
  output reg[1:0] y;
  input [1:0]a,b;
  input c;
  reg cout;
  
  always @(a,b,c)
  begin 
   //case (a[1],a[0],b[1],b[0],c)
   
   case({a,b,c}) // synopsys parallel_case
    5'b00001:
    begin
    y <= 2'b01; 
     cout <= 1'b0;
     end 
    
    5'b00010:
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end 
     
     5'b00011:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b00100:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b00101:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00110:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00111:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01000:
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end
     
     5'b01001:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b01010:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b01011:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01100:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01101:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01110:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01111:
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10000:
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b10001:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10010:
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10011:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b10100:
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b10101:
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10110:  //22
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10111:  //23
    begin
     y <= 2'b10; 
     cout <= 1'b1;
     end
     
     5'b11000: //24
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b11001:  //25
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b11010:  //26
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b11011:  //27
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b11100: //28
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b11101:  //29
    begin
     y <= 2'b10; 
     cout <= 1'b1;
     end
     
     5'b11110:  //30
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b11111:  //31
    begin
     y <= 2'b11; 
     cout <= 1'b1;
     end
     
     5'b00000:  //0
    begin
     y <= 2'b00; 
     cout <= 1'b0;
     end
 endcase
 end
 endmodule

module add3_operator(y,a,b,c);
  
parameter N = 8;
output [N-1:0]y;
input [N-1:0]a,b,c;

assign y = (a+b)+c;

endmodule
