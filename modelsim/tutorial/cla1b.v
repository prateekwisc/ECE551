`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module name:   Carry Look ahead adder.
// Group Members: Prateek Gupta, Karan Maini, Amitesh Narayan, Snehal Mhatre 
// 
// Create Date:    12:44:20 11/08/2013 
// Design Name:    FAGP_1bit, CLU_4bit, CLA_16bit
// 
// Project Name: 
//  
// Description: It is a signed 16-bit carry look ahead adder. This program
// shows how the area and timing efficient addittion can be achieved.   
// 
//
//
//////////////////////////////////////////////////////////////////////////////////


//1 bit Carry Look Ahead Adder
module FAGP_1bit(output C_out, output Sum, output Generate, output Propagate, input InA, input InB,input C_In);
wire G_n;
wire B;
xor x1(Propagate,InA,InB);
xor x2(Sum,Propagate,C_In);
nand n1(G_n,InA,InB);
nand n2(B,Propagate,C_In);
not not1(Generate,G_n);
nand n3(C_out,B,G_n);
endmodule


// 4Bit Carry Look Ahead Unit
module CLU_4bit(output [3:0] C_out, input [3:0] Generate, input [3:0] Propagate, input C_In);
  wire[3:0] ab;
  wire[3:0] G_n2;
  nand Nand1(ab[0],Propagate[0],C_In);
  not not2[3:0](G_n2,Generate);
  nand Nand4(C_out[0],G_n2[0],ab[0]);
  nand Nand2[2:0](ab[3:1],Propagate[3:1],C_out[2:0]);
  nand Nand3[2:0](C_out[3:1],G_n2[3:1],ab[3:1]);
endmodule


// 16 bit Carry Look Ahead adder
module CLA_16bit(output Carry_out, output reg [15:0] X, input [15:0] A, input [15:0] B);
  wire [15:0]Sum;
  wire[15:0] Generate,Propagate;
  wire[14:0] c_out;
  CLU_4bit CLU_16bit[3:0](.C_out({Carry_out,c_out[14:0]}), .Generate(Generate[15:0]), .Propagate(Propagate[15:0]), .C_In({c_out[11],c_out[7],c_out[3],1'b0}));
  FAGP_1bit full_add[15:0](.Sum(Sum[15:0]), .Generate(Generate[15:0]), .Propagate(Propagate[15:0]), .InA(A[15:0]), .InB(B[15:0]), .C_In({c_out[14:0],1'b0}));
    always @(*)
        begin
          if (Sum[15]==0 && A[15]==1&&B[15]==1)
          X=16'h8001; 
        else if (Sum[15]==1 && A[15]==0&&B[15]==0 )
          X=16'h7fff;
          else X=Sum;
          end
endmodule

    
  


