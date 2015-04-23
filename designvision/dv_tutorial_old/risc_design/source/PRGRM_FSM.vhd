library IEEE;
use IEEE.std_logic_1164.all;
use WORK.RISCTYPES.all;

entity PRGRM_FSM is
        port (
                Clk,               -- CPU Clock
                Reset             -- CPU Reset
			:  in std_logic;
                CurrentState      -- Current State of FSM
			:  out State_Type
              );
end PRGRM_FSM;

architecture RTL of PRGRM_FSM is

--    type State_Type is (RESET_STATE, FETCH_INSTR, READ_OPS, EXECUTE, WRITEBACK);
    signal Current_State, Next_State        : State_Type;

begin

    process (Reset, Current_State)
    begin
        case Current_State is
            when RESET_STATE =>
                Next_State <= FETCH_INSTR;
            when FETCH_INSTR =>
                Next_State  <= READ_OPS;
            when READ_OPS =>
                Next_State <= EXECUTE;
            when EXECUTE =>
                Next_State <= WRITEBACK;
            when WRITEBACK =>
                Next_State <= FETCH_INSTR;
        end case;
    end process;

    process
    begin
        wait until Clk'event and Clk = '1';
        if (Reset = '1') then
            Current_State       <= RESET_STATE ;
        else
            Current_State       <= Next_State ;
        end if;
    end process;

    CurrentState <= Current_State;

end RTL;

