module queue(clk,reset,data_in,wr,rd,data_out,full,empty); 
 parameter WIDTH = 8;
  parameter LENGTH = 16;
  
function integer log2;
 input integer num;
 begin
 log2 = 0;
 for(log2=0;num>0;log2 = log2 + 1) begin
 num = num>>1;
 end
 end
endfunction

  
  localparam ADDR_WIDTH = log2(LENGTH)-1;

  
 input wire clk;
   input wire reset;
   input wire [WIDTH-1:0] data_in;
   input wire wr;
   input wire rd;
   output [WIDTH-1:0] data_out;
   output wire full;
   output wire empty;
  
  /*wire count;
   reg [ADDR_WIDTH:0] full_indicator;  //N
  
  reg [ADDR_WIDTH-1:0] wr_ptr; // N-1
  reg [ADDR_WIDTH-1:0] rd_ptr; // N-1
 
  reg[WIDTH-1:0] mem[LENGTH-1:0]; */
 
  
 generate
    if (LENGTH ==0)
     q1_queue #(WIDTH,LENGTH)q1(clk,reset,data_in,wr,rd,data_out,full,empty); 
    else
     q2_queue #(WIDTH,LENGTH)q2(clk,reset,data_in,wr,rd,data_out,full,empty);
    endgenerate
 endmodule 

module q1_queue(clk,reset,data_in,wr,rd,data_out,full,empty);
    parameter WIDTH = 8;
  parameter LENGTH = 16;
  
    
    input wire clk;
   input wire reset;
   input wire [WIDTH-1:0] data_in;
   input wire wr;
   input wire rd;
   output reg [WIDTH-1:0] data_out;
   output wire full;
   output wire empty;
  
  
   
   assign full = 1'b0;
   assign empty = 1'b0;
   assign data_in = data_out;
 endmodule
  

module q2_queue(clk,reset,data_in,wr,rd,data_out,full,empty); 
 
  parameter WIDTH = 8;
  parameter LENGTH = 16;
  
function integer log2;
 input integer num;
 begin
 log2 = 0;
 for(log2=0;num>0;log2 = log2 + 1) begin
 num = num>>1;
 end
 end
endfunction

  
  localparam ADDR_WIDTH = log2(LENGTH)-1;
  
   
   input wire clk;
   input wire reset;
   input wire [WIDTH-1:0] data_in;
   input wire wr;
   input wire rd;
   output reg [WIDTH-1:0] data_out;
   output wire full;
   output wire empty;
   wire count;
   reg [ADDR_WIDTH:0] full_indicator;  //N
  
  reg [ADDR_WIDTH-1:0] wr_ptr; // N-1
  reg [ADDR_WIDTH-1:0] rd_ptr; // N-1
 
  reg[WIDTH-1:0] mem[LENGTH-1:0];
 
  assign full = (full_indicator == LENGTH);
  assign empty = (full_indicator == 8'b0);
  
  
   
  always @(posedge clk)
  begin
//  if(count)1
 //   data_out <= data_in;
     if (reset) 
      begin
        wr_ptr <= 8'b0;
        rd_ptr <= 8'b0;
        full_indicator <= 8'b0;
      end
    else
      begin
        case ({rd, wr})
          2'b00: // nothing
            begin
              full_indicator <= full_indicator;
            end
          2'b01: // write
            begin
              if  (full_indicator < LENGTH)
                begin
                  full_indicator <= full_indicator + 1;
                  mem[wr_ptr] <= data_in;
                  wr_ptr <= wr_ptr + 1;
                end
            end
          2'b10: // read
            begin
              if (full_indicator > 0)
                begin
                  data_out <= mem[rd_ptr];
                  full_indicator <= full_indicator - 1;
                  rd_ptr <= rd_ptr + 1;
                end
            end
          2'b11: // read+write
            begin
              wr_ptr <= wr_ptr + 1;
              rd_ptr <= rd_ptr + 1;
              data_out <= mem[rd_ptr];
              mem[wr_ptr] <= data_in;
              full_indicator <= full_indicator;
            end
        endcase
/*        if (wr_ptr >= LENGTH)
          wr_ptr <= 0;
          if(rd_ptr >= LENGTH)
            rd_ptr <= 0; */
            
      end
      end
endmodule


`timescale 1ns/100ps 
module t_queue;
  parameter B= 8; // bit width
  parameter LENGTH = 16; 
  reg [20:0] i;
  reg clk;
  reg reset;
  reg rd;
  reg wr;
  reg [B-1:0] data_in;
  wire [B-1:0] data_out;
  wire full;
  wire empty;
  reg [20:0] n;
//  wire qu_full;
 // wire qu_empty;
  //integer tail;
  
  
//assign qu_full = (tail == LENGTH);
//assign qu_empty = (tail == 0);

/*task CHECK();
begin
if(qu_full == full)
tail = tail;
else if( wr=1 && rd=0)
tail = tail + 1;  
end

begin
if(qu_empty == empty)
 */

  task WRITE(input [B-1:0] value);
    begin
      clk = 1'b0;
      wr = 1;
      rd = 0;
      data_in = value;
      #5 clk = 1'b1;
      #5 clk = 1'b0;
      wr = 0;
    end
  endtask
 
  task READ();
    begin
      clk = 1'b0;
      rd = 1;
      wr = 0;
      #5 clk = 1'b1;
      #5 clk = 1'b0;
         rd  = 0;
    end
  endtask
 
  task WRITEREAD(input [B-1:0] value);
    begin
      clk = 1'b0;
      wr = 1;
      rd = 1;
      data_in = value;
      #5 clk = 1'b1;
      #5 clk = 1'b0;
         rd = 0;
         wr = 0;
    end
  endtask
 
  task IDLE();
    begin
      #5 clk = 1'b1;
      #5 clk = 1'b0;
    end
  endtask
 
  queue queue_unit(.clk(clk), .reset(reset), .rd(rd), .wr(wr), .data_in(data_in), .data_out(data_out), .full(full), .empty(empty));
 
  /* FSM1 */
  initial begin
    clk=0;
    reset=1;
    rd=0;
    wr=0;
    data_in=0;
    //r_data=0;
    $dumpfile("t_queue");
    $dumpvars;
 
    #5 clk<=1'b1;
    #5 clk<=1'b0;
       reset<=1'b0;
    #10000 $finish;
  end
 
  /* CASE 1: OVERFLOW: */
  initial begin // WRITING
    #10
    for (i=0; i<260; i=i+1)
    begin
      WRITE(i);
    end
 
    for (i=15; i<255; i=i+1)
    begin
      WRITEREAD(i);
    end
 
    for (i=32; i<64; i=i+1)
    begin
      READ();
    end
  end
endmodule