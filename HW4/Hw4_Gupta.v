
//Using Struct Case

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


//Using Case module
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
   
     bit2_FA fa0[(N/2)-1:0](tmp1,{cout1,ci1[N/2-1:1]},a,b,{ci1[N/2-1:1],1'b0});
     bit2_FA fa1[(N/2)-1:0](y,{cout2,ci2[(N/2)-1:1]},tmp1,c,{ci2[N/2-1:1],1'b0});
   end
     else begin
      bit2_FA fa2[(N/2):0](tmp2,{cout1,ci3[(N/2):1]},{1'b0,a},{1'b0,b},{ci3[N/2:1],1'b0});
      bit2_FA fa3[(N/2):0]({tmp,y},{cout2,ci4[(N/2):1]},tmp2,{1'b0,c},{ci4[N/2:1],1'b0});
    end
    
    endgenerate
//LV_pragram translate_on    
 endmodule

module bit2_FA(y,cout,a,b,c);
  output reg[1:0] y;
  input [1:0]a,b;
  input c;
  output reg cout;
  
  
   always@(a,b,c)
  begin 
  
  //case({a[1],a[0],b[1],b[0],c})
  case({a,b,c})  
    5'b00001:    //1
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end 
    
    5'b00010:    //2
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end 
     
     5'b00011:   //3
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b00100:    //4
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b00101:   //5
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00110:    //6
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00111:    //7
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01000:    //8
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end
     
     5'b01001:   //9
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b01010:   //10
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b01011:   //11
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01100:   //12
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01101:   //13
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01110:   //14
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01111:  //15
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10000:   //16
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b10001:  //17
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10010:  //18
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10011:  //19
    begin
     y <= 2'b00;  
     cout <= 1'b1;
     end
     
     5'b10100:  //20
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b10101: //21
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


//Using parcase


module add3_parcase(y,a,b,c);
  
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
 
 if(N % 2 == 0) begin : even
   
     bit2_FA fa0[(N/2)-1:0](tmp1,{cout1,ci1[N/2-1:1]},a,b,{ci1[N/2-1:1],1'b0});
     bit2_FA fa1[(N/2)-1:0](y,{cout2,ci2[(N/2)-1:1]},tmp1,c,{ci2[N/2-1:1],1'b0});
   end
     else begin : odd
      bit2_FA fa2[(N/2):0](tmp2,{cout1,ci3[(N/2):1]},{1'b0,a},{1'b0,b},{ci3[N/2:1],1'b0});
      bit2_FA fa3[(N/2):0]({tmp,y},{cout2,ci4[(N/2):1]},tmp2,{1'b0,c},{ci4[N/2:1],1'b0});
    end
    
    endgenerate
//LV_pragram translate_on    
 endmodule

module bit2_FA(y,cout,a,b,c);
  output reg[1:0] y;
  input [1:0]a,b;
  input c;
  output reg cout;
  
  
   always@(a,b,c)
  begin 
  
  //case({a[1],a[0],b[1],b[0],c})
  case({a,b,c})  // synopsys parallel_case
    5'b00001:    //1
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end 
    
    5'b00010:    //2
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end 
     
     5'b00011:   //3
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b00100:   //4
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b00101:  //5
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00110:  //6
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b00111:   //7
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01000:   //8
    begin
     y <= 2'b01; 
     cout <= 1'b0;
     end
     
     5'b01001:   //9
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b01010:   //10
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end 
     
     5'b01011:  //11
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01100:  //12
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b01101:  //13
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01110: //14
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b01111:  //15
    begin
     y <= 2'b01; 
     cout <= 1'b1;
     end
     
     5'b10000:  //16
    begin
     y <= 2'b10; 
     cout <= 1'b0;
     end
     
     5'b10001:   //17
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10010:   //18
    begin
     y <= 2'b11; 
     cout <= 1'b0;
     end
     
     5'b10011:   //19
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b10100:   //20
    begin
     y <= 2'b00; 
     cout <= 1'b1;
     end
     
     5'b10101:   //21
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

//Using Operator module

module add3_operator(y,a,b,c);
  
parameter N = 8;
output [N-1:0]y;
input [N-1:0]a,b,c;

assign y = (a+b)+c;

endmodule
