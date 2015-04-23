library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity  STACK_MEM is 
    port ( 
            Clk,             -- Clock
            PushEnbl,        -- Push cmd for stack
            PopEnbl,          -- Pop cmd for stack
            Stack_Full	     -- Stack is full flag	
                     : in std_logic;

            TOS      : in std_logic_vector (0 to 2);

            PushDataIn       -- Data to be pushed into the stack 
                     : in std_logic_vector (3 downto 0);

            PopDataOut       -- Data popped out of the stack
                     : out std_logic_vector (3 downto 0) := "0000"
       );
end STACK_MEM;

architecture RTL of STACK_MEM is

    type Mem is array (0 to 7) of std_logic_vector (3 downto 0);
    signal Stack_Mem : Mem;
    signal Pop_Address : std_logic_vector (0 to 2);

begin
	-- Generate Correct Address for Pop
	process(Stack_Full, TOS)
	begin
	   if (Stack_Full = '1') then
		 Pop_Address <= TOS;
       else
		 Pop_Address <= TOS - '1';
       end if;
    end process;

    -- Stack Memory writes; described as a set of registers (edge sensitive)
    process
    begin
       wait until Clk'event and Clk = '1';
        if(PushEnbl = '1') then  -- {
            Stack_Mem(conv_integer(unsigned(TOS))) <= PushDataIn;
        end if; -- }
    end process; 

    -- Stack Memory reads; the output is latched every clock edge
    process
    begin
       wait until Clk'event and Clk = '1';
        if(PopEnbl = '1') then
        PopDataOut <= Stack_Mem(conv_integer(unsigned(Pop_Address)));
        end if;
    end process;

end RTL;
