module pipeb1(q3,d,clk);
output [7:0]q3;
input clk;
input [7:0]d;
reg [7:0]q1, q2, q3;
always@(posedge clk)q1 = d;
always@(posedge clk)q2 = q1;
always@(posedge clk)q3 = q2;
 
endmodule