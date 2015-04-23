library IEEE;
use IEEE.std_logic_1164.all;
use WORK.RISCTYPES.all;

entity PRGRM_DECODE is
        port (
                Zro_Flag,          -- "Zero" Flag from DATA_PATH
                Carry_Flag,        -- "Carry" Flag from DATA_PATH
                Neg_Flag           -- "Negative" Flag from DATA_PATH
                        : in std_logic;

	        CurrentState	   -- CurrentState from FSM
		        : in State_Type;  	

                Crnt_Instrn        -- Current instruction under execution
                                   -- from Instruction Latch
                        : in std_logic_vector (31 downto 0);

                Incrmnt_PC,        -- Increments PC (in WRITEBACK cycle)
                Ld_Brnch_Addr,     -- Load Immediate add from Instrn Latch 
                                   -- into PC (in WRITEBACK cycle)
                Ld_Rtn_Addr        -- Load Return addr from Stack into PC (in WRITEBACK cycle)
                        : out std_logic 
              );
end PRGRM_DECODE;

architecture RTL of PRGRM_DECODE is

	signal Brnch_Addr, Rtn_Addr, Take_Branch : std_logic;	

begin

    process (Take_Branch, CurrentState, Crnt_Instrn, Zro_Flag, Carry_Flag, Neg_Flag, Brnch_Addr, Rtn_Addr)
    	variable Neg, Carry, Zro, Jmp : std_logic;
    begin

	Brnch_Addr <= '0';
	Rtn_Addr <= '0';

 --  Determine if Jmp on False or Jmp on True
	 if (Crnt_Instrn(25)) = '1' then
	     Neg := not Neg_Flag;
	     Carry := not Carry_Flag;
	     Zro := not Zro_Flag;
             Jmp := '0';
	 else
	     Neg := Neg_Flag;
	     Carry := Carry_Flag;
	     Zro := Zro_Flag;
	     Jmp := '1';
	 end if;		

  --  Determines which of the CONDITIONs needs to be checked and whether to jmp
         if (Crnt_Instrn(23 downto 16) = "00000000") then
             Take_Branch <= Neg;
         elsif (Crnt_Instrn(23 downto 16) = "00000001") then
             Take_Branch <= Zro;
         elsif (Crnt_Instrn(23 downto 16) = "00000010") then
	     Take_Branch <= Carry;
         elsif (Crnt_Instrn(23 downto 16) = "00111111") then
             Take_Branch <= Jmp;
	 else Take_Branch <= '0';
         end if;

        case CurrentState is
            when WRITEBACK =>
                if (Crnt_Instrn(31 downto 30) = "00") then 
				-- For Jmp/Call with condition check
                    if ((Crnt_Instrn(29) = '1' or Crnt_Instrn(28) = '1' ) and 
                         Take_Branch = '1') then 
                        Brnch_Addr <= '1';
                    end if;
		                -- For Return
                    if (Crnt_Instrn(27) = '1') then
                        Rtn_Addr <= '1';
                    end if; 
                end if; 
			        -- If not Jmping or Rtrning the increment PC
	        if (Rtn_Addr ='1' or Brnch_Addr = '1') then     
		    Incrmnt_PC <= '0';
		else
		    Incrmnt_PC <= '1';
                end if;
	    when others =>
		Incrmnt_PC <= '0';	
        end case;
    end process;

    Ld_Brnch_Addr <= Brnch_Addr;
    Ld_Rtn_Addr <= Rtn_Addr;

end RTL;

