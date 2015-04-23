library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity  STACK_TOP is 
    port ( 
            Reset,           -- Reset
            Clk,             -- Clock
            PushEnbl,        -- Push cmd for stack
            PopEnbl          -- Pop cmd for stack
                     : in std_logic;

            PushDataIn       -- Data to be pushed into the stack 
                     : in std_logic_vector (11 downto 0);

            PopDataOut       -- Data popped out of the stack
                     : out std_logic_vector (11 downto 0) := "000000000000";
            STACK_FULL       -- Stack is full
                     : out std_logic 
       );
end STACK_TOP;

architecture STRUCT of STACK_TOP is

component STACK_FSM		port (
	   Reset	: in std_logic;
	   Clk		: in std_logic;
	   PushEnbl     : in std_logic;
	   PopEnbl	: in std_logic;
	   TOS	 	: out std_logic_vector (0 to 2);
	   STACK_FULL	: out std_logic
	);
end component;

component STACK_MEM		port (
	   Clk		: in std_logic;
	   PushEnbl	: in std_logic;
	   PopEnbl	: in std_logic;
	   Stack_Full	: in std_logic;
	   TOS		: in std_logic_vector (0 to 2);
	   PushDataIn	: in std_logic_vector (3 downto 0);
	   PopDataOut	: out std_logic_vector (3 downto 0)
	);
end component;	 

signal TOS : std_logic_vector (0 to 2);
signal STACK_FULL_int : std_logic;

begin

I_STACK_FSM : STACK_FSM port map (
	  Reset		=> Reset,
	  Clk		=> Clk,
	  PushEnbl	=> PushEnbl,
	  PopEnbl	=> PopEnbl,
	  TOS		=> TOS,
	  STACK_FULL	=> STACK_FULL_int
	);

I1_STACK_MEM : STACK_MEM port map (
	   Clk		=> Clk,
	   PushEnbl	=> PushEnbl,
	   PopEnbl	=> PopEnbl,
	   Stack_Full 	=> STACK_FULL_int,
	   TOS		=> TOS,
	   PushDataIn	=> PushDataIn(3 downto 0),
	   PopDataOut	=> PopDataOut(3 downto 0)
	);

I2_STACK_MEM : STACK_MEM port map (
	   Clk		=> Clk,
	   PushEnbl	=> PushEnbl,
	   PopEnbl	=> PopEnbl,
	   Stack_Full 	=> STACK_FULL_int,
	   TOS		=> TOS,
	   PushDataIn	=> PushDataIn(7 downto 4),
	   PopDataOut	=> PopDataOut(7 downto 4)
	);

I3_STACK_MEM : STACK_MEM port map (
	   Clk		=> Clk,
	   PushEnbl	=> PushEnbl,
	   PopEnbl	=> PopEnbl,
	   Stack_Full 	=> STACK_FULL_int,
	   TOS		=> TOS,
	   PushDataIn	=> PushDataIn(11 downto 8),
	   PopDataOut	=> PopDataOut(11 downto 8)
	);

STACK_FULL <= STACK_FULL_int;

end STRUCT;
