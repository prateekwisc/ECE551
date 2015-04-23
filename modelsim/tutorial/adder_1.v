   module carry_skip_4(A, B, X, CIN, COUT);
        input [3:0]A, B;
        input CIN;
        output [3:0]X;
        output COUT;
        
        reg [3:0]X;
        reg [2:0]base;
        reg [2:0]ifzero;
        reg [2:0]ifone;
        reg COUT;
        
        always @(A or B or CIN)
        begin
                base = A[1:0] + B[1:0] + {1'b0, CIN};
                ifzero = A[3:2] + B[3:2];
                ifone = A[3:2] + B[3:2] + 2'b01;
                
                if(base[2])
                begin
                        X = {ifone[1:0], base[1:0]};
                        COUT = ifone[2];
                end
                else
                begin
                        X = {ifzero[1:0], base[1:0]};
                        COUT = ifzero[2];
                end
        end
   endmodule
   
module carry_skip_16(A, B, X, C_in, C_out);
        input [15:0]A, B;
        input C_in;
        //assign C_in = 0;
        output reg[15:0]X;
        wire [15:0]X1;
        output C_out; 
        wire [3:0]c_out;
        //wire overflow;
        carry_skip_4 add1 [3:0](.A(A), .B(B), .X(X1), .CIN({c_out[2:0],C_in}),.COUT(c_out[3:0]));
        assign C_out = c_out[3];
        //assign overflow = A[15]|B[15];
        
        always @(*)
        begin
          if (X1[15]==0 && A[15]==1&&B[15]==1)
          X=16'hffff; 
        else if (X1[15]==1 && A[15]==0&&B[15]==0 )
          X=16'h7fff;
          else X=X1;
          end
          
         
//        always @(*)
//        begin
//        if (A[15]==1&&B[15]==1&&X1[15]==1&&C_out==1)
//        assign X=16'hffff; 
//      else if (A[15]==0&&B[15]==0&&C_out==1)
//        assign X=16'h7fff;
//      else assign X=X1;
//     end 
      endmodule
   
  module t_carry_skip;
  reg [15:0]A,B;
  wire [15:0]X;
  reg C_in;
  wire C_out;
  carry_skip_16 DUT(.A(A), .B(B), .X(X), .C_in(C_in),.C_out(C_out));
  initial begin
   
    repeat(200) begin
      #10;
      A = $random;
      B = $random;
      C_in = 0;
//      A = 16'h7ffe;
//      B = 16'h7ffe;
//      C_in = 0;
    end
  end
  initial begin
    $monitor("A = %b, B= %b, P=%b",A,B,X);
  end
endmodule
