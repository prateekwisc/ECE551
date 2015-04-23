library IEEE;
use IEEE.std_logic_1164.all;
entity  INSTRN_LAT is 
    port (
            Clk                -- CPU Clock
                      : in std_logic;
            Instrn             -- Instrn for 
                      : in std_logic_vector (31 downto 0);

            Latch_Instr        -- Enable for latching instruction
                      : in std_logic;
	    Crnt_Instrn_1
		      : out std_logic_vector(31 downto 0);	
            Crnt_Instrn_2        -- Instrn under/about to be processed
                      : out std_logic_vector(31 downto 0) 
         );
end INSTRN_LAT;

architecture RTL of INSTRN_LAT is

begin
    process
    begin
        wait until Clk'event and Clk = '1';
        if (Latch_Instr = '1') then
            Crnt_Instrn_1 <= Instrn;
	    Crnt_Instrn_2 <= Instrn;
        end if;
    end process;

end RTL;
