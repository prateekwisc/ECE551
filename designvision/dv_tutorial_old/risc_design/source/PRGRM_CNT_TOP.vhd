library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCTYPES.all;

entity PRGRM_CNT_TOP is
        port (
               Clk            : in std_logic;
               Reset          : in std_logic;
               Crnt_Instrn    : in std_logic_vector (31 downto 0); -- Current Executing Inst
	       Zro_Flag,				-- Flags from ALU or Stack
	       Carry_Flag,
	       Neg_Flag	      : in std_logic;
	       Return_Addr    : in std_logic_vector (7 downto 0);
	       Current_State  : out State_Type;		-- CurrentState from Control FSM	               
	       PC	      : out std_logic_vector (7 downto 0)     -- Program Count
             );
end PRGRM_CNT_TOP;


architecture STRUCT of PRGRM_CNT_TOP is

    component PRGRM_FSM         port (
               Clk            : in std_logic;
               Reset          : in std_logic;
	       CurrentState   : out State_Type
             );
    end component;

    component PRGRM_DECODE	port (
	       Zro_Flag	      : in std_logic;
	       Carry_Flag     : in std_logic;
	       Neg_Flag       : in std_logic;
	       CurrentState   : in State_Type;
	       Crnt_Instrn    : in std_logic_vector (31 downto 0);
	       Incrmnt_PC     : out std_logic;
	       Ld_Brnch_Addr  : out std_logic;
	       Ld_Rtn_Addr    : out std_logic
	     );
    end component;				

    component PRGRM_CNT		 port (
	       Reset	      : in std_logic;
	       Clk	      : in std_logic;
	       Incrmnt_PC     : in std_logic;
    	       Ld_Brnch_Addr  : in std_logic;
	       Ld_Rtn_Addr    : in std_logic;
	       Imm_Addr	      : in std_logic_vector (7 downto 0);
	       Return_Addr    : in std_logic_vector (7 downto 0);
	       PC	      : out std_logic_vector (7 downto 0)
	     );
    end component; 

    signal Incrmnt_PC, Ld_Brnch_Addr, Ld_Rtn_Addr : std_logic;
    signal CurrentState : State_Type; 

    begin

    I_PRGRM_FSM : PRGRM_FSM port map (
	        Clk		=> Clk,
		Reset		=> Reset,
		CurrentState 	=> CurrentState
	      );

    I_PRGRM_DECODE : PRGRM_DECODE port map (
		Zro_Flag	=> Zro_Flag,
		Carry_Flag	=> Carry_Flag,
		Neg_Flag	=> Neg_Flag,
		CurrentState	=> CurrentState,
		Crnt_Instrn	=> Crnt_Instrn,
		Incrmnt_PC	=> Incrmnt_PC,
		Ld_Brnch_Addr	=> Ld_Brnch_Addr,
		Ld_Rtn_Addr	=> Ld_Rtn_Addr
	      );

    I_PRGRM_CNT : PRGRM_CNT port map (
		Reset		=> Reset,
		Clk		=> Clk,
		Incrmnt_PC	=> Incrmnt_PC,
		Ld_Brnch_Addr	=> Ld_Brnch_Addr,
		Ld_Rtn_Addr	=> Ld_Rtn_Addr,
		Imm_Addr	=> Crnt_Instrn (7 downto 0),
		Return_Addr	=> Return_Addr,
		PC		=> PC
	      );

    Current_State <= CurrentState;

end STRUCT;	
				 	
