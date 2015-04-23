library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity  STACK_FSM is 
    port ( 
            Reset,           -- Reset
            Clk,             -- Clock
            PushEnbl,        -- Push cmd for stack
            PopEnbl          -- Pop cmd for stack
                     : in std_logic;
            TOS      : out std_logic_vector (0 to 2);  -- Stack address
            STACK_FULL       -- Stack is full
                     : out std_logic 
       );
end STACK_FSM;

architecture RTL of STACK_FSM is

    type Stack_State is (EMPTY,NORMAL,FULL,ERROR);
    signal Crnt_Stack,Next_Stack : Stack_State;
    signal Next_TOS,TOS_int : std_logic_vector (0 to 2);

begin
    process (Crnt_Stack, TOS_int, PushEnbl, PopEnbl)
    begin
            if (PushEnbl = '1' and PopEnbl = '1') then  
                 Next_Stack <= ERROR ;
                 Next_TOS <= "000" ;
            else
               case Crnt_Stack is
                  when EMPTY  =>
                                 if (PushEnbl = '1') then  
                                     Next_Stack <= NORMAL;
                                     Next_TOS <= "001";
                                 elsif (PopEnbl = '1') then
                                     Next_Stack <= ERROR;
                                     Next_TOS <= "000";
                                 else
                                     Next_Stack <= EMPTY ;
                                     Next_TOS <= "000";
                                 end if; 
                  when NORMAL =>
                                 if (PushEnbl = '1') then
                                    if (TOS_int = "111") then
                                        Next_Stack <= FULL;
                                        Next_TOS <= "111";
                                    else
                                        Next_Stack <= NORMAL;
                                        Next_TOS <= TOS_int + '1';
                                    end if; 
                                 elsif (PopEnbl = '1') then
                                     if (TOS_int = "001") then
                                         Next_Stack <= EMPTY;
                                         Next_TOS <= "000";
                                     else
                                         Next_Stack <= NORMAL;
                                         Next_TOS <= TOS_int - '1';
                                     end if;
                                 else
                                     Next_Stack <= NORMAL ;
                                     Next_TOS <= TOS_int;
                                 end if;

                  when FULL   =>
                                 if (PushEnbl = '1') then
                                     Next_Stack <= ERROR ;
                                     Next_TOS <= "111";
                                 elsif (PopEnbl = '1') then
                                     Next_Stack <= NORMAL;
                                     Next_TOS <= "111";
                                 else
                                     Next_Stack <= FULL ;
                                     Next_TOS <= "111";
                                 end if; 

                  when ERROR => 
                                     Next_Stack <= ERROR ;
                                     Next_TOS <= "111";
               end case;
           end if;
    end process;

    process
    begin
        wait until Clk'event and Clk = '1';
        if (Reset = '1') then
            Crnt_Stack <= EMPTY;
            TOS_int <= "000";
        else
            Crnt_Stack <= Next_Stack;
            TOS_int <= Next_TOS;
            if (Crnt_Stack = FULL and TOS_int = "111") then
               STACK_FULL <= '1';
            else
               STACK_FULL <= '0'; 
            end if;
        end if;
    end process;

    TOS <= TOS_int;

end RTL;
