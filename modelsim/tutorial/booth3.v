
`timescale 	 1ns/1ns

module booth(clk, reset, load, A, B, done, result);

  parameter WidthMultiplicand = 16,

                   WidthMultiplier = 16,

                   WidthCount = 5,

Comp_add = 3'b010,

Add = 3'b001;

 

  input clk, reset, load;

  input [WidthMultiplicand-1:0] A;

  input [WidthMultiplier-1:0] B;

  output [WidthMultiplicand+WidthMultiplier-1:0] result;

  output done; 

  reg done, sign, E, shift, Qn_1;

  reg [WidthMultiplicand-1:0] regA;

  reg [WidthMultiplier-1:0] regB, regQ;

  reg [WidthCount-1:0] SeqCount;

  assign result = {regA,regQ};

 

  always @(posedge clk) begin

    if(!reset) begin

      regA = 0;

      regB = 0;

      regQ = 0;

      Qn_1 = 0;

      shift = 0;

      SeqCount = WidthMultiplier;

      done = 0;

    end

    else if (load) begin

      regA = 0;

      regB = A;

      regQ = B;

      Qn_1 = 0;

      shift = 0;

      SeqCount = WidthMultiplier;

      done = 0;

    end

    else if (!done) 

      case({shift,regQ[0],Qn_1})

        Comp_add:begin

          regA = regA + ~regB + 1;

          shift = 1;

          end

        Add:begin

          regA = regA + regB;

          shift = 1;

          end

          default:begin

            {regA,regQ,Qn_1} = ({regA,regQ,Qn_1}>>1);

            regA[WidthMultiplicand-1] = regA[WidthMultiplicand-2];

            SeqCount = SeqCount - 1;

            shift = 0;

            if (SeqCount == 0)

              done = 1;

          end

      endcase    

 

  end

endmodule   


module test_booth;


reg [15:0] A;
reg [15:0] B;
reg clk;
reg reset;
reg load;


wire [31:0] result;
wire done;


booth booth(
   .clk      (clk),
   .reset    (reset),
   .load     (load),
   .A        (A),
   .B        (B),
   .done     (done),
   .result   (result)
   );



initial  
    begin
       clk = 0;
       reset=1;
    
       load = 1;
       
       A[15:0] = 16'b1111111111111101;
       B[15:0] = 16'b0000000001011010;
    end

always
#32 clk = ~clk;
always
  begin
#128 load = 0;
#4096 load = 1;

end

endmodule


