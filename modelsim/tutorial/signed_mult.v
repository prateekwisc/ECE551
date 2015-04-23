module signed_mult (out, a, b);

	output 		[31:0]	out;
	
	input 	signed	[15:0] 	a;
	input 	signed	[15:0] 	b;

	wire 	signed	[31:0]	mult_out;

assign out = a * b;

endmodule



