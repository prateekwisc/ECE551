
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module name: Signed 16-bit radix-4 modified booth's multiplier.
// Group Members: Prateek Gupta, Karan Maini, Amitesh Narayan, snehal Mhatre 
// 
// Create Date:    12:44:20 11/08/2013 
// Design Name:    mod_booth_multiplier
// 
// Project Name: 
//  
// Description: It is a signed 16-bit radix-4 modified booth multiplier. This program
// shows how the area and timing efficient multiplication can be achieved using the   
// modified booth algorithm for signed numbers.
//
// x = multiplicand, y = multiplier
//////////////////////////////////////////////////////////////////////////////////

module mod_booth_multiplier (product, x, y);

//parameter declarations
parameter width= 16;
parameter N = 8;

//input port declaration
input[width-1:0]x, y;

//output port declaration
output[width-1:0]product;

//Port Data Types
reg [2:0] count[N-1:0];
reg [width:0] partial[N-1:0];
reg [width+width-1:0] signedpartial[N-1:0];
reg [width+width-1:0] result;
wire [width:0] inv_x;

//local variables of integer type
integer i,j;

//generate two's complement of mutiplicand X(M)
assign inv_x = {~x[width-1],~x}+1;
always @ (x or y or inv_x)
begin
count[0] = {y[1],y[0],1'b0};
for(j=1;j<N;j=j+1)
count[j] = {y[2*j+1],y[2*j],y[2*j-1]};

for(j=0;j<N;j=j+1)
begin
case(count[j])  //recoding cases of radix-4 booth multiplier
//computing booth recoded bits
3'b001 , 3'b010 : partial[j] = {x[width-1],x}; // 1 X Multiplicand
3'b011 : partial[j] = {x,1'b0};                // 2 X Multiplicand
3'b100 : partial[j] = {inv_x[width-1:0],1'b0}; // -2 X Multiplicand
3'b101 , 3'b110 : partial[j] = inv_x;          // -1 X Multiplicand
default : partial[j] = 0;                      // Zero
endcase
signedpartial[j] = $signed(partial[j]);
for(i=0;i<j;i=i+1)
signedpartial[j] = {signedpartial[j],2'b00}; //multiply by 2 to the power x or shifting operation
end
result = signedpartial[0];
for(j=1;j<N;j=j+1)
result = result + signedpartial[j];
end
assign product = result ;
endmodule

//module for rounding up

module mult_resbooth(Y,A,B);
  input [15:0] A,B;
  output [15:0] Y;
  wire [31:0] m_res;
  mod_booth_multiplier m1(m_res,A,B);
  assign Y = m_res[30:15] + m_res[14];
 endmodule


// Automated test bench


module t_multiplier;
 integer file;
 initial
 file = $fopen("multiplier_result.txt");


wire [15:0] outp;

reg [15:0] test_inpA, test_inpB;
reg [15:0] expected_output;


integer i,j;

mod_booth_multiplier#(16) DUT0(outp, test_inpA, test_inpB);

initial 
  begin
    
initialize_inputs;

  if(outp != expected_output)
    err(expected_output, outp, test_inpA, test_inpB);
    

 
 for(i = 0; i != 32767; i = i+1) begin
 
  test_inpA = test_inpA + 1;
  for(j = 1; j != 32767; j = j+1) begin

    test_inpB = test_inpB + 1;
    expected_output = test_inpA * test_inpB;
    
    // mod_booth_multiplier#(16) DUT(outp, test_inpA, test_inpB);
    
    if(outp != expected_output)
      err(expected_output, outp, test_inpA, test_inpB);
  end
  
 end


$fwrite(file, "----\t");
$display("----\t");
$fclose(file);
$finish;
end


task initialize_inputs;
begin
 test_inpA = 0;
 test_inpB = 0;
 expected_output = 0;
end
endtask


task err;
input expected;
input actual;
input inputA;
input inputB;

begin
 if(expected != actual)begin
 $fwrite(file, "ERROR has occured. Expected out is %b and got %b with inputs A as %b, B as %b \t", expected, actual, inputA, inputB);
 $display("ERROR\t");
 $fclose(file);
 $finish;
 end
end
endtask


endmodule
