module my_mod1(data_out, data_in, load, clk, reset);
output reg [3:0] data_out;
input clk, load, reset;
input[3:0] data_in;

always@(posedge clk, posedge reset)
begin
if(reset == 1'b1)
data_out <= 4'b0;
else if(load == 1'b1)
data_out<=data_in;
else data_out<= {data_out[2:0], data_out[3]};
end
endmodule
