library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCTYPES.all;

entity CONTROL is
        port (
                Clk,               -- CPU Clock
                Reset              -- Reset to the cpu core
                        : in std_logic;

                Crnt_Instrn        -- Current instruction under execution;
                                   -- from Instruction Latch
                        : in std_logic_vector (31 downto 0);

		Current_State
			: in State_Type;

		Neg_Flag,
		Carry_Flag,
		Zro_Flag
			: in std_logic;

                Latch_Instr,       -- Enable for latching current instruction
                Rd_Oprnd_A,        -- Latch operand A into reg at i/p of ALU
                Rd_Oprnd_B,        -- Latch operand B into reg at i/p of ALU
                Latch_Flags,       -- Enable for storing flags, only occurs
                                   -- for ALU type instructions in Execute Clock 
                Latch_Result,      -- Enable for latching o/p of ALU into latch 
                Write_RegC,        -- Write for operand C (in execute cycle)

                UseData_Imm_Or_RegB, 
                                   -- Select for mux between RegFile portB data
                                   -- and Imm data (8-bit)

                UseData_Imm_Or_ALU,-- Select for mux between ALU o/p and
                                   -- and Imm data to load to Register File
                Reset_AluRegs,    
                                   -- Used to reset alu i/ps on every 
                                   -- FETCH_INSTRN state
                EndOfInstrn,       -- Used to dump PSW and RegFile contents into files at
                                   -- end of every WRITE_BACK cycle
                PushEnbl,
                PopEnbl,
                OUT_VALID          -- to indicate that execution of DATA OUT 
                        : out std_logic := '0'

              );
end CONTROL;

architecture RTL of CONTROL is

    signal Data_Imm_Or_ALU,Data_Imm_Or_RegB : std_logic;
    signal Take_Branch : std_logic;

begin

   process (Crnt_Instrn, Neg_Flag, Carry_Flag, Zro_Flag)

  	variable Neg, Carry, Zro, Jmp : std_logic;

   begin 

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

        if (Crnt_Instrn(23 downto 16) = "00000000") then
		Take_Branch <= Neg;
	elsif (Crnt_Instrn(23 downto 16) = "00000001") then
		Take_Branch <= Zro;
  	elsif (Crnt_Instrn(23 downto 16) = "00111111") then
		Take_Branch <= Jmp;
	else Take_Branch <= '0';
	end if;

   end process;

    process (Reset, Current_State, Crnt_Instrn, Take_Branch)
    begin
        OUT_VALID <= '0';
        case Current_State is

            when RESET_STATE =>
                PushEnbl         <= '0';
                PopEnbl          <= '0';
                Latch_Flags      <= '0';
                Latch_Result     <= '0';
                Rd_Oprnd_A       <= '0';
                Rd_Oprnd_B       <= '0';
                Data_Imm_Or_RegB <= '0';
                Data_Imm_Or_ALU  <= '0';
                Latch_Instr      <= '0';
                Reset_AluRegs    <= '0';
                Write_RegC       <= '0';

            when FETCH_INSTR =>
                Data_Imm_Or_RegB  <= '0';
                Data_Imm_Or_ALU   <= '0';
                Latch_Instr       <= '1';
                Reset_AluRegs     <= '1';
                Write_RegC        <= '0';
                PushEnbl          <= '0';
                PopEnbl           <= '0';
                Latch_Flags       <= '0';
                Latch_Result      <= '0';
                Rd_Oprnd_A        <= '0';
                Rd_Oprnd_B        <= '0';

            when READ_OPS =>
                Latch_Instr       <= '0';
                Reset_AluRegs     <= '0';
                PushEnbl          <= '0';
                PopEnbl           <= '0';
                Latch_Flags       <= '0';
                Latch_Result      <= '0';
                Write_RegC        <= '0';

            -- Generation of mux selects for data path and operand read signals
            -- Asserting them in this state gives sufficient time for setup

                case Crnt_Instrn(31 downto 30) is 
                    when "00" =>     --    (Type 0 instruction)
                        -- These 2 can actually be don't cares for Type 0
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';
                        Rd_Oprnd_A <= '0';
                        Rd_Oprnd_B <= '0';

                    when "01" =>     --    (Type 1 instruction)
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';
                        Rd_Oprnd_A <= '1';
                        Rd_Oprnd_B <= '1';

                    when "10" =>     --    (Type 2 instruction)
                        Data_Imm_Or_RegB <= '1';
                        Data_Imm_Or_ALU <= '0';
                        Rd_Oprnd_A <= '1';
                        Rd_Oprnd_B <= '1';

                    when "11" =>     --    (Type 3 instruction)
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '1';
                        Rd_Oprnd_A <= '0';
                        Rd_Oprnd_B <= '1';

                    when others =>
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';
                        Rd_Oprnd_A <= '0';
                        Rd_Oprnd_B <= '0';
                end case;
              
-- Added by Anupam For reading the REG_FILE address given in instruction on user request
                if ( Crnt_Instrn(31 downto 30) = "00" and 
                     Crnt_Instrn(24) = '1') then
                    Rd_Oprnd_A <= '1';
                    end if;
  
            when EXECUTE =>
                Rd_Oprnd_A       <= '0';
                Rd_Oprnd_B       <= '0';
                Latch_Instr      <= '0';
                Reset_AluRegs    <= '0';
                Write_RegC       <= '0';

                case Crnt_Instrn(31 downto 30) is 
                    when "00" =>     --    (Type 0 instruction)
                        -- These 2 can actually be don't cares for Type 0
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';

                    when "01" =>     --    (Type 1 instruction)
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';

                    when "10" =>     --    (Type 2 instruction)
                        Data_Imm_Or_RegB <= '1';
                        Data_Imm_Or_ALU <= '0';

                    when "11" =>     --    (Type 3 instruction)
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '1';

                    when others =>
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';
                end case;

                if ( Crnt_Instrn(31 downto 30) = "00" and Crnt_Instrn(24) = '1') then
                     OUT_VALID <= '1';
                else
                     OUT_VALID <= '0';
                end if;

-- Push PC into Stack (Call Conditional)
                if ((Crnt_Instrn (31 downto 30) = "00" and  -- Testing for Call instruction
                    Crnt_Instrn(28) = '1'
                    ) and
                    Take_Branch = '1'
                    ) then -- {
                    PushEnbl <= '1' ;
                 else
                    PushEnbl <= '0' ;
                 end if; --}

            -- Pop from Stack (Return)
                if (Crnt_Instrn(31 downto 30) = "00" and 
                    Crnt_Instrn(27) = '1'
                   ) then -- {
                    PopEnbl <= '1' ;
                else
                    PopEnbl <= '0' ;
                end if; --}
            -- Latching flags for ALU ops but not pass-thru ( ?? Can this be same as Latch_Result ??)
                if (Crnt_Instrn(31 downto 30) = "01" or 
                    Crnt_Instrn(31 downto 30) = "10"
                   ) then -- {
                   Latch_Flags <= '1';
                else
                   Latch_Flags <= '0';
                end if; --}

            -- Latching result for ALU and pass-thru
                if (Crnt_Instrn(31 downto 30) = "01" or 
                    Crnt_Instrn(31 downto 30) = "10" or
                    Crnt_Instrn(31 downto 30) = "11"
                   ) then -- {
                    Latch_Result <= '1';
                else
                    Latch_Result <= '0';
                end if; --}

            when WRITEBACK =>
                Latch_Flags    <= '0';
                Latch_Result   <= '0';
                PushEnbl       <= '0';
                PopEnbl        <= '0';
                Rd_Oprnd_A     <= '0';
                Rd_Oprnd_B     <= '0';
                Latch_Instr    <= '0';
                Reset_AluRegs  <= '0';

                -- Write result of ALU OP or the immediate data to reg_file
                if (Crnt_Instrn(31 downto 30) /= "00") then -- {
                    Write_RegC <= '1';
                else
                    Write_RegC <= '0';
                end if; --}

                case Crnt_Instrn(31 downto 30) is 
                    when "00" =>     --    (Type 0 instruction)
                        -- These 2 can actually be don't cares for Type 0
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';

                    when "01" =>     --    (Type 1 instruction)
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';

                    when "10" =>     --    (Type 2 instruction)
                        Data_Imm_Or_RegB <= '1';
                        Data_Imm_Or_ALU <= '0';

                    when "11" =>     --    (Type 3 instruction)
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '1';

                    when others =>
                        Data_Imm_Or_RegB <= '0';
                        Data_Imm_Or_ALU <= '0';
                end case;
        end case;
    end process;

    process
    begin
        wait until Clk'event and Clk = '1';
        if (Reset = '1') then
            UseData_Imm_Or_RegB <= '0';
            UseData_Imm_Or_ALU  <= '0';
        else
            UseData_Imm_Or_RegB <= Data_Imm_Or_RegB;
            UseData_Imm_Or_ALU  <= Data_Imm_Or_ALU;
        end if;
    end process;

-- Added to generate signals which control file dump
    process
    begin
      wait until Clk'event and Clk = '1';
      if(Current_State = WRITEBACK) then -- {
          EndOfInstrn <= '1';
      else
          EndOfInstrn <= '0';
      end if; --}
        
    end process;

end RTL;

