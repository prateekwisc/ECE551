module queue(clk,reset,data_in,wr,rd,data_out,full,empty); 
 parameter WIDTH = 8;
  parameter LENGTH = 16;

   input clk;
   input reset;
   input wire [WIDTH-1:0] data_in;
   input wire wr;
   input wire rd;
   output [WIDTH-1:0] data_out;
   output wire full;
   output wire empty;

//LV_pragma translate_off
  generate
    case(LENGTH)
      0:q0_queue #(WIDTH,LENGTH)q1(clk,reset,data_in,wr,rd,data_out,full,empty);
      default:q1_queue #(WIDTH,LENGTH)q2(clk,reset,data_in,wr,rd,data_out,full,empty);
    endcase
  endgenerate
  //LV_pragram translate_on
endmodule

module q0_queue(clk,reset,data_in,wr,rd,data_out,full,empty);
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

module q1_queue(clk,reset,data_in,wr,rd,data_out,full,empty); 
 
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
   reg [ADDR_WIDTH:0] full_indicator;  //N
  
  reg [ADDR_WIDTH-1:0] wr_ptr; // N-1
  reg [ADDR_WIDTH-1:0] rd_ptr; // N-1
 
  reg[WIDTH-1:0] mem[LENGTH-1:0];
 
  assign full = (full_indicator == LENGTH);
  assign empty = (full_indicator == 8'b0);
 
  always @(posedge clk)
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
      if(wr_ptr >= LENGTH)
      wr_ptr <= 0;
      if(rd_ptr >= LENGTH)
        rd_ptr <= 0;
      
      end
endmodule

