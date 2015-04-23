library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.RISCTYPES.all;

entity RISC_CORE is
        port (
               Clk            	: in std_logic;
               Reset          	: in std_logic;
               Instrn         	: in std_logic_vector (31 downto 0);
               Xecutng_Instrn 	: out std_logic_vector (31 downto 0);
               EndOfInstrn    	: out std_logic;
               PSW            	: out std_logic_vector (10 downto 0);
               Rd_Instr       	: out std_logic;
               RESULT_DATA    	: out std_logic_vector (15 downto 0);
               OUT_VALID      	: out std_logic;
               STACK_FULL     	: out std_logic
             );

end RISC_CORE;

architecture STRUCT of RISC_CORE is

    signal Oprnd_A, Oprnd_B, Op_Result, RegPort_A, RegPort_B, RegPort_C
             			: std_logic_vector (15 downto 0);

    signal Addr_A, Addr_B, Addr_C 	: std_logic_vector(6 downto 0);

    signal ALU_OP 		: std_logic_vector (5 downto 0);

    signal ALU_Zro, ALU_Neg, ALU_Carry, Zro_Flag, Neg_Flag, Carry_Flag,
           PSW_Zro, PushEnbl, PopEnbl, PSW_Neg, PSW_Carry, 
           Write_RegC, Rd_Oprnd_A, Rd_Oprnd_B, Latch_Instr, Latch_Flags,
           Latch_Result, UseData_Imm_Or_RegB, UseData_Imm_Or_ALU, 
           Reset_AluRegs 
				: std_logic;
    signal Current_State	: State_Type;
    signal Crnt_Instrn_1, Crnt_Instrn_2
		 		: std_logic_vector (31 downto 0);
    signal PushDataIn, PopDataOut	: std_logic_vector (11 downto 0);
    signal Return_Addr, Imm_Addr 	: std_logic_vector (7 downto 0);
    signal PC			: std_logic_vector (7 downto 0);

    component ALU
         port (
	      Reset, Clk	: in std_logic;	
              Oprnd_A, 
	      Oprnd_B 		: in std_logic_vector (15 downto 0);
              ALU_OP  		: in std_logic_vector (5 downto 0);
	      Latch_Result,
	      Latch_Flags	: in std_logic;
              Lachd_Result 	: out std_logic_vector (15 downto 0);
              Zro_Flag, Neg_Flag, 
	      Carry_Flag 	: out std_logic
              );
    end component;

    component CONTROL 
         port (
              Clk, Reset	: in std_logic; 
              Crnt_Instrn  	: in std_logic_vector (31 downto 0);
	      Current_State	: in State_Type;
	      Neg_Flag		: in std_logic;
	      Carry_Flag	: in std_logic;
	      Zro_Flag		: in std_logic;	
              Latch_Instr, 
	      Rd_Oprnd_A, Rd_Oprnd_B, 
	      Latch_Flags, Latch_Result, 
	      Write_RegC, 
	      UseData_Imm_Or_RegB, UseData_Imm_Or_ALU,
              Reset_AluRegs, EndOfInstrn, 
	      PushEnbl, PopEnbl,
              OUT_VALID     	: out std_logic
              );
    end component;

    component DATA_PATH 
         port (
              Clk, Reset, 
	      Reset_AluRegs, 
	      Rd_Oprnd_A, Rd_Oprnd_B,
              UseData_Imm_Or_RegB, UseData_Imm_Or_ALU, 
	      Latch_Flags, 
	      ALU_Zro, ALU_Neg, ALU_Carry,
              PSW_Zro, PSW_Neg, PSW_Carry 
				: in std_logic;
              Crnt_Instrn 	: in std_logic_vector (31 downto 0);
              RegPort_A, RegPort_B, Op_Result
                          	: in std_logic_vector (15 downto 0);
              Zro_Flag, Neg_Flag, Carry_Flag 
				: buffer std_logic;
              Addr_A 		: out std_logic_vector(6 downto 0);
              Oprnd_A, Oprnd_B, RegPort_C 
				: out std_logic_vector (15 downto 0)
              );
    end component;

    component INSTRN_LAT 
         port (
              Clk 		: in std_logic;
              Instrn 		: in std_logic_vector (31 downto 0);
              Latch_Instr 	: in std_logic;
              Crnt_Instrn_1 	: out std_logic_vector(31 downto 0);
	      Crnt_Instrn_2	: out std_logic_vector(31 downto 0)
              );
    end component;

    component PRGRM_CNT_TOP 
         port ( 
              Clk, Reset	: in std_logic;
	      Crnt_Instrn	: in std_logic_vector (31 downto 0);	
	      Zro_Flag		: in std_logic;
	      Carry_Flag	: in std_logic;
	      Neg_Flag		: in std_logic;
	      Return_Addr	: in std_logic_vector (7 downto 0);
	      Current_State	: out State_Type;
              PC 		: out std_logic_vector (7 downto 0)
              );
    end component;

    component REG_FILE 
         port (
              Reset, Clk 	: in std_logic;
              Addr_A, Addr_B, Addr_C 
				: in std_logic_vector (6 downto 0);
              RegPort_C 	: in std_logic_vector (15 downto 0);
              Write_RegC 	: in std_logic;
              RegPort_A, RegPort_B 
				: out std_logic_vector ( 15 downto 0)
              );
    end component;

    component STACK_TOP
         port ( 
              Reset, Clk 	: in std_logic;
	      PushEnbl, PopEnbl : in std_logic;
              PushDataIn 	: in std_logic_vector (11 downto 0);
              PopDataOut 	: out std_logic_vector (11 downto 0);
              STACK_FULL 	: out std_logic
              );
    end component;

begin

-- Connectivity definition of components
	PushDataIn (11 downto 0) 	<=  '0' & Zro_Flag & Neg_Flag & Carry_Flag & PC;
        Return_Addr 	<=  PopDataOut (7 downto 0);
        PSW_Zro 	<=  PopDataOut(10);
        PSW_Neg 	<=  PopDataOut(9);
        PSW_Carry 	<=  PopDataOut(8);
        ALU_OP 		<=  Crnt_Instrn_1 (29 downto 24);
        Addr_B 		<=  Crnt_Instrn_1 ( 6 downto 0);
        Addr_C 		<=  Crnt_Instrn_1 (22 downto 16);
        PSW 		<=  PC & Zro_Flag & Neg_Flag & Carry_Flag;
        Rd_Instr 	<=  Latch_Instr;
        Xecutng_Instrn 	<=  Crnt_Instrn_1;
        RESULT_DATA 	<=  RegPort_A; 
           
-- Entity instantiations

    I_ALU : ALU port map (
	          Reset		=> Reset,
		  Clk		=> Clk,
		  Oprnd_A 	=> Oprnd_A,
                  Oprnd_B 	=> Oprnd_B,
                  ALU_OP  	=> ALU_OP,
		  Latch_Result  => Latch_Result,
		  Latch_Flags	=> Latch_Flags,
                  Lachd_Result 	=> Op_Result,
                  Zro_Flag   	=> ALU_Zro,
                  Neg_Flag   	=> ALU_Neg,
                  Carry_Flag 	=> ALU_Carry  
		);

    I_CONTROL : CONTROL port map (
                  Clk 		=> Clk,
                  Reset 	=> Reset,
                  Crnt_Instrn 	=> Crnt_Instrn_2,
		  Current_State => Current_State,
		  Neg_Flag	=> Neg_Flag,
		  Carry_Flag	=> Carry_Flag,
		  Zro_Flag	=> Zro_Flag,
                  Latch_Instr 	=> Latch_Instr,
                  Rd_Oprnd_A 	=> Rd_Oprnd_A,
                  Rd_Oprnd_B 	=> Rd_Oprnd_B,
                  Latch_Flags 	=> Latch_Flags, 
                  Latch_Result 	=> Latch_Result,
                  Write_RegC 	=> Write_RegC,
                  UseData_Imm_Or_RegB 	=> UseData_Imm_Or_RegB,
                  UseData_Imm_Or_ALU 	=> UseData_Imm_Or_ALU,
                  Reset_AluRegs => Reset_AluRegs,
                  EndOfInstrn 	=> EndOfInstrn,
                  PushEnbl 	=> PushEnbl,
                  PopEnbl 	=> PopEnbl,
                  OUT_VALID 	=> OUT_VALID
                );

    I_DATA_PATH  : DATA_PATH port map (
                   Clk 		=> Clk,
                   Reset 	=> Reset,
                   Reset_AluRegs 	=> Reset_AluRegs,
                   Rd_Oprnd_A 	=> Rd_Oprnd_A,
                   Rd_Oprnd_B 	=> Rd_Oprnd_B,
                   UseData_Imm_Or_RegB 	=> UseData_Imm_Or_RegB,
                   UseData_Imm_Or_ALU 	=> UseData_Imm_Or_ALU,
                   Latch_Flags 	=> Latch_Flags,
                   ALU_Zro 	=> ALU_Zro,
                   ALU_Neg 	=> ALU_Neg,
                   ALU_Carry 	=> ALU_Carry,
                   PSW_Zro 	=> PSW_Zro,
                   PSW_Neg 	=> PSW_Neg,
                   PSW_Carry 	=> PSW_Carry,
                   Crnt_Instrn 	=> Crnt_Instrn_2,
                   RegPort_A 	=> RegPort_A,
                   RegPort_B 	=> RegPort_B,
                   Op_Result 	=> Op_Result,
                   Zro_Flag 	=> Zro_Flag,
                   Neg_Flag 	=> Neg_Flag,
                   Carry_Flag 	=> Carry_Flag,
                   Addr_A 	=> Addr_A,
                   Oprnd_A 	=> Oprnd_A,
                   Oprnd_B 	=> Oprnd_B,
                   RegPort_C 	=> RegPort_C
                 );

    I_INSTRN_LAT : INSTRN_LAT port map (
                   Clk 		=> Clk,
                   Instrn 	=> Instrn,
                   Latch_Instr 	=> Latch_Instr,
                   Crnt_Instrn_1 => Crnt_Instrn_1,
		   Crnt_Instrn_2 => Crnt_Instrn_2
                  );

    I_PRGRM_CNT_TOP : PRGRM_CNT_TOP port map (
                   Clk 		=> Clk,
                   Reset 	=> Reset,
		   Crnt_Instrn	=> Crnt_Instrn_2,
		   Zro_Flag	=> Zro_Flag,
	    	   Carry_Flag	=> Carry_Flag,
		   Neg_Flag	=> Neg_Flag,
                   Return_Addr 	=> Return_Addr,
		   Current_State	=> Current_State,
                   PC 		=> PC
                  );

    I_REG_FILE : REG_FILE port map (
                   Reset 	=> Reset,
                   Clk 		=> Clk,
                   Addr_A 	=> Addr_A,
                   Addr_B 	=> Addr_B,
                   Addr_C 	=> Addr_C,
                   RegPort_C 	=> RegPort_C, 
                   Write_RegC 	=> Write_RegC,
                   RegPort_A 	=> RegPort_A,
                   RegPort_B 	=> RegPort_B
                 );

    I_STACK_TOP : STACK_TOP port map (
                   Reset 	=> Reset,
                   Clk 		=> Clk,
                   PushEnbl 	=> PushEnbl,
                   PopEnbl 	=> PopEnbl,
                   PushDataIn 	=> PushDataIn,
                   PopDataOut 	=> PopDataOut,
                   STACK_FULL 	=> STACK_FULL
                   );
end STRUCT;


