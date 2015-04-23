module multi(product,x,y); 
 
input  [15:0] x,y; 
output [31:0] product; 
 
wire [31:0] prod1,prod2,prod3,prod4; 
reg [1:0]path; 
  
assign prod1=x[14:0]*y[14:0]; 
assign prod2={{2{x[15]}},{{15{x[15]}}&(~y[14:0])},{15{1'b0}}}; 
assign prod3={{2{y[15]}},{{15{y[15]}}&(~x[14:0])},{15{1'b0}}}; 
assign prod4={1'b0,{x[15]&y[15]},{13{1'b0}},path,{15{1'b0}}}; 
assign product=(prod1+prod2)+(prod3+prod4); 
 
always@(x[15] or y[15])begin 
case({x[15],y[15]}) 
2'b00:path=2'b00; 
2'b01:path=2'b01; 
2'b10:path=2'b01; 
2'b11:path=2'b10; 
endcase 
end 
 
endmodule


module multi_tb;

	// Inputs
	reg [15:0] x;
	reg [15:0] mb;

	// Outputs
	wire [31:0] product;


	// Instantiate the Unit Under Test (UUT)
	multi uut (
		.ma(ma), 
		.mb(mb), 
		.product(product)	
	);

	initial begin
		// Initialize Inputs
		ma = 0;
		mb = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#100 ma=16'b0011010100100100;mb=16'b0101111010000001;
		#100 ma=16'b1111000101110110;mb=16'b1100110100111101;
		#100 ma=16'b1111011111100101;mb=16'b0111001001110111;
		#100 $finish;
		
	end
      
endmodule


