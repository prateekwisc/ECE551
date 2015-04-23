// It is a radix-4 booth's multiplier
module booth_mult (p, x, y);
parameter width= 16;
parameter N = 8;
input[width-1:0]x, y;
output[width+width-1:0]p;
reg [2:0] cc[N-1:0];
reg [width:0] pp[N-1:0];
reg [width+width-1:0] spp[N-1:0];
reg [width+width-1:0] prod;
wire [width:0] inv_x;

integer i,j;
//generate two's complement of mutiplicand X(M)
assign inv_x = {~x[width-1],~x}+1;

always @ (x or y or inv_x)
begin
cc[0] = {y[1],y[0],1'b0}; //generate Ck for each k, for k is not zero
for(j=1;j<N;j=j+1)
cc[j] = {y[2*j+1],y[2*j],y[2*j-1]};

for(j=0;j<N;j=j+1)
begin
case(cc[j])
3'b001 , 3'b010 : pp[j] = {x[width-1],x};
3'b011 : pp[j] = {x,1'b0};
3'b100 : pp[j] = {inv_x[width-1:0],1'b0};
3'b101 , 3'b110 : pp[j] = inv_x;
default : pp[j] = 0;
endcase

spp[j] = $signed(pp[j]);
for(i=0;i<j;i=i+1)
spp[j] = {spp[j],2'b00}; //multiply by 2 to the power x or shifting operation
end //'for(j=0;j<N;j=j+1)'
prod = spp[0];
for(j=1;j<N;j=j+1)
prod = prod + spp[j];
end
assign p = prod;
endmodule
