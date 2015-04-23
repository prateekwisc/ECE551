module my_mod(count, enable, clk, reset);
output reg [7:0]count;
input clk, enable, reset;
always@(posedge clk,posedge reset)
begin
if(reset == 1'b1)
count <= 8'b0000_0001;
else if(enable == 1'b1)
  begin
    case(count)
      8'b0000_0001:count<= 8'b0000_0010;
      8'b0000_0010:count<= 8'b0000_0100;
      8'b0000_0100:count<= 8'b0000_1000;
      8'b0000_1000:count<= 8'b0001_0000;
      8'b0001_0000:count<= 8'b0010_0000;
      8'b0010_0000:count<= 8'b0100_0000;
      8'b0100_0000:count<= 8'b1000_0000;
      8'b1000_0000:count<= 8'b0000_0001;
      default: count<= 8'bxxxx_xxxx;
    endcase
  end
end
endmodule