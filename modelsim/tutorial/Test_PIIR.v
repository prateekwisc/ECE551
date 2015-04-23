module t_PIIR;
  wire [15:0] AD;
  wire  ALE, RD, WR;
  reg  CE, PU, Clk1, Clk2, CFG;
  reg  [3:0] Const;

// Internal Variables
  integer count, count1;
  reg result;

 PIIR piir (AD, ALE, RD, WR, CE, PU, Clk1, Clk2, Const, CFG);
 
 assign AD = ($time == 1) ? 16'b0000_0000_0000_0000: ($time == 19) ? 16'b0100_0000_0000_0000 : ($time == 29) ? 16'b0100_0000_0000_0000 : ($time == 39) ? 16'b0100_0000_0000_0000 :  
 ($time == 49) ? 16'b0100_0000_0000_0000 : ($time == 59) ? 16'b0100_0000_0000_0000 : ($time == 69) ? 16'b0100_0000_0000_0000 : ($time == 79) ? 16'b0100_0000_0000_0000 : 
 ($time == 89) ? 16'b0100_0000_0000_0000 : ($time == 99) ? 16'b1100_0000_0000_0000 : ($time == 109) ? 16'b0100_0000_0000_0000 : ($time == 119) ? 16'b1111_0000_1111_0000 : 
 (ALE && (AD == 16'b 1111_0000_1111_0000)) ? 16'b 0000_0000_0000_0000 : 16'bZ ;
 
 // Initialization
 initial
  begin
    #1
    Clk1=0; Clk2 = 0; 
    CE = 0; PU= 0; CFG = 1; Const = 0; // AD = 0;
  end
  
  always
    begin
      #10
      Clk1= ~Clk1;
    end
    
  always
    begin
      #8
      Clk2= ~Clk2;
    end
  
  initial
    begin
      
      #1 ;
      #6  CE = 1;
      #12 CFG = 0; 
          Const = 1;  // AD = 16'b 0100_0000_0000_0000;  // a1
      #10 Const = 2;  // AD = 16'b 0100_0000_0000_0000;  // a2
      #10 Const = 5;  // AD = 16'b 0100_0000_0000_0000;  // y1
      #10 Const = 6;  // AD = 16'b 0100_0000_0000_0000;  // y2
      #10 Const = 8;  // AD = 16'b 0100_0000_0000_0000;  // b0
      #10 Const = 9;  // AD = 16'b 0100_0000_0000_0000;  // b1
      #10 Const = 10; // AD = 16'b 0100_0000_0000_0000;  // b2
      #10 Const = 12; // AD = 16'b 0100_0000_0000_0000;  // x0
      #10 Const = 13; // AD = 16'b 1100_0000_0000_0000;  // x1
      #10 Const = 14; // AD = 16'b 0100_0000_0000_0000;  // x2
      #10 Const = 15; // AD = 16'b 1111_0000_1111_0000;  // Addr
      
      #3 CFG =1; count = 10;
      
      while(count!=0)  
      begin
      #1 if(ALE && (AD == 16'b 1111_0000_1111_0000))
            begin
              count = 0;
              // AD = 16'b 0000_0000_0000_0000;   // New X(0)
            end
            
          else  
            begin
              count = count - 1;
            end
      end
      
      #8 count1 = 10;
      
      while(count!=0)  
      begin
      #1 if(WR)
            begin
              count1 = 0;
              result = AD;   // Y(0)
            end
            
         else
            count1 = count1 - 1;
      end
      
    end
    
    
    initial
      begin
        $monitor("At t=$time  Ce=%b  Pu=%b  Cfg=%b  clk1=%b  clk2=%b  const=%d  ale=%b  rd=%b  wr=%b  ad=%b  ", CE, PU, CFG, Clk1, Clk2, Const, ALE, RD, WR, AD);
      end
      
    initial
      begin
        $stop(200);
      end
       
  endmodule
      