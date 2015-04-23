module mult_test1 (output reg [31:0]out, input [31:0] a,b,c,d);

always @ (*)
begin
out = ((a*b)*c)*d;
end
endmodule