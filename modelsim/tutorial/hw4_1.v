module add3_struct #(parameter WIDTH=8)(Y,A,B,C);
  input [WIDTH-1:0] A,B,C;
  output [WIDTH-1:0] Y;
  wire cout1,cout2;
  wire [WIDTH-1:1] carry1,carry2;
  wire [WIDTH-1:0] temp;
  
  fulladder_1bit U1[WIDTH-1:0](temp,{cout1,carry1[WIDTH-1:1]},A,B,{carry1[WIDTH-1:1],1'b0});
  fulladder_1bit U2[WIDTH-1:0](Y,{cout2,carry2[WIDTH-1:1]},temp,C,{carry2[WIDTH-1:1],1'b0});
endmodule

module fulladder_1bit(s,cout,a,b,cin);
  input a,b,cin;
  output s,cout;
  wire t0,t1,t2;
  
  xor xor0(s,a,b,cin);
  and and0(t0,a,b);
  and and1(t1,a,cin);
  and and2(t2,b,cin);
  xor xor1(cout,t0,t1,t2);
endmodule

module add3_case #(parameter WIDTH=8)(Y,A,B,C);
  input [WIDTH-1:0] A,B,C;
  output [WIDTH-1:0] Y;
  wire cout1,cout2;
  wire [(WIDTH/2)-1:1] carry1,carry2;
  wire [WIDTH-1:0] temp;
  generate 
    if(WIDTH%2)begin
      fulladder_2bit_case U1[(WIDTH/2)-1:0](temp[WIDTH-2:0],{cout1,carry1[(WIDTH/2)-1:1]},A[WIDTH-2:0],B[WIDTH-2:0],{carry1[(WIDTH/2)-1:1],1'b0});
      fulladder_2bit_case U2[(WIDTH/2)-1:0](Y[WIDTH-2:0],{cout2,carry2[(WIDTH/2)-1:1]},temp[WIDTH-2:0],C[WIDTH-2:0],{carry2[(WIDTH/2)-1:1],1'b0});
      fulladder_1bit U3(temp[WIDTH-1],,A[WIDTH-1],B[WIDTH-1],cout1);
      fulladder_1bit U4(Y[WIDTH-1],,temp[WIDTH-1],C[WIDTH-1],cout2);
    end
    else begin
      fulladder_2bit_case U1[(WIDTH/2)-1:0](temp,{cout1,carry1[(WIDTH/2)-1:1]},A,B,{carry1[(WIDTH/2)-1:1],1'b0});
      fulladder_2bit_case U2[(WIDTH/2)-1:0](Y,{cout2,carry2[(WIDTH/2)-1:1]},temp,C,{carry2[(WIDTH/2)-1:1],1'b0});
    end
  endgenerate
endmodule

module add3_parcase #(parameter WIDTH=8)(Y,A,B,C);
  input [WIDTH-1:0] A,B,C;
  output [WIDTH-1:0] Y;
  wire cout1,cout2;
  wire [(WIDTH/2)-1:1] carry1,carry2;
  wire [WIDTH-1:0] temp;
  
    generate 
    if(WIDTH%2)begin
      fulladder_2bit_case U1[(WIDTH/2)-1:0](temp[WIDTH-2:0],{cout1,carry1[(WIDTH/2)-1:1]},A[WIDTH-2:0],B[WIDTH-2:0],{carry1[(WIDTH/2)-1:1],1'b0});
      fulladder_2bit_case U2[(WIDTH/2)-1:0](Y[WIDTH-2:0],{cout2,carry2[(WIDTH/2)-1:1]},temp[WIDTH-2:0],C[WIDTH-2:0],{carry2[(WIDTH/2)-1:1],1'b0});
      fulladder_1bit U3(temp[WIDTH-1],,A[WIDTH-1],B[WIDTH-1],cout1);
      fulladder_1bit U4(Y[WIDTH-1],,temp[WIDTH-1],C[WIDTH-1],cout2);
    end
    else begin
      fulladder_2bit_case U1[(WIDTH/2)-1:0](temp,{cout1,carry1[(WIDTH/2)-1:1]},A,B,{carry1[(WIDTH/2)-1:1],1'b0});
      fulladder_2bit_case U2[(WIDTH/2)-1:0](Y,{cout2,carry2[(WIDTH/2)-1:1]},temp,C,{carry2[(WIDTH/2)-1:1],1'b0});
    end
  endgenerate
endmodule

module fulladder_2bit_case(s,cout,a,b,cin);
  input [1:0] a,b;
  input cin;
  output reg [1:0] s;
  output reg cout;
  
  always@(a,b,cin)begin
    case({a,b,cin})
      0:{cout,s}=3'b000;
      1:{cout,s}=3'b001;
      2:{cout,s}=3'b001;
      3:{cout,s}=3'b010;
      4:{cout,s}=3'b010;
      5:{cout,s}=3'b011;
      6:{cout,s}=3'b011;
      7:{cout,s}=3'b100;
      8:{cout,s}=3'b001;
      9:{cout,s}=3'b010;
      10:{cout,s}=3'b010;
      11:{cout,s}=3'b011;
      12:{cout,s}=3'b011;
      13:{cout,s}=3'b100;
      14:{cout,s}=3'b100;
      15:{cout,s}=3'b101;
      16:{cout,s}=3'b010;
      17:{cout,s}=3'b011;
      18:{cout,s}=3'b011;
      19:{cout,s}=3'b100;
      20:{cout,s}=3'b100;
      21:{cout,s}=3'b101;
      22:{cout,s}=3'b101;
      23:{cout,s}=3'b110;
      24:{cout,s}=3'b011;
      25:{cout,s}=3'b100;
      26:{cout,s}=3'b100;
      27:{cout,s}=3'b101;
      28:{cout,s}=3'b101;
      29:{cout,s}=3'b110;
      30:{cout,s}=3'b110;
      31:{cout,s}=3'b111;
      default:{cout,s}=3'bx;
    endcase
  end
endmodule

module fulladder_2bit_parcase(s,cout,a,b,cin);
  input [1:0] a,b;
  input cin;
  output reg [1:0] s;
  output reg cout;
  
  always@(a,b,cin)begin
    case({a,b,cin}) //synopsys parallel_case
      0:{cout,s}=3'b000;
      1:{cout,s}=3'b001;
      2:{cout,s}=3'b001;
      3:{cout,s}=3'b010;
      4:{cout,s}=3'b010;
      5:{cout,s}=3'b011;
      6:{cout,s}=3'b011;
      7:{cout,s}=3'b100;
      8:{cout,s}=3'b001;
      9:{cout,s}=3'b010;
      10:{cout,s}=3'b010;
      11:{cout,s}=3'b011;
      12:{cout,s}=3'b011;
      13:{cout,s}=3'b100;
      14:{cout,s}=3'b100;
      15:{cout,s}=3'b101;
      16:{cout,s}=3'b010;
      17:{cout,s}=3'b011;
      18:{cout,s}=3'b011;
      19:{cout,s}=3'b100;
      20:{cout,s}=3'b100;
      21:{cout,s}=3'b101;
      22:{cout,s}=3'b101;
      23:{cout,s}=3'b110;
      24:{cout,s}=3'b011;
      25:{cout,s}=3'b100;
      26:{cout,s}=3'b100;
      27:{cout,s}=3'b101;
      28:{cout,s}=3'b101;
      29:{cout,s}=3'b110;
      30:{cout,s}=3'b110;
      31:{cout,s}=3'b111;
      default:{cout,s}=3'bx;
    endcase
  end
endmodule

module add3_operator #(parameter WIDTH=8)(Y,A,B,C);
  input [WIDTH-1:0] A,B,C;
  output [WIDTH-1:0] Y;
  
  assign Y=A+(B+C);
endmodule

module t_add3();
  parameter width=7;
  reg [width-1:0] a,b,c;
  wire [width-1:0] s1,s2,s3,s4;
  add3_struct #(width)U1(s1,a,b,c);
  add3_case #(width)U2(s2,a,b,c);
  add3_parcase #(width)U3(s3,a,b,c);
  add3_operator #(width)U4(s4,a,b,c);
  initial begin
    repeat(1000) begin
      #5;
      a=$random;
      b=$random;
      c=$random;
      $strobe("%h+%h+%h=%h,%h",a,b,c,s3,s4);
      error(s3,s4);
    end
  end
    
  task error;
    input a1;
    input a2;
    if(a1==~a2)begin
      $display("Error");
      $stop;
    end
  endtask
endmodule