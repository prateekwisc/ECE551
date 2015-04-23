library IEEE;
use IEEE.std_logic_1164.all;

entity  DATA_PATH is 
    port ( 
            Clk,                  -- Clock
            Reset,                -- Reset for flags
            Reset_AluRegs,        -- Reset alu port registers
            Rd_Oprnd_A,           -- From CONTROL;Commands to read operand A & B
            Rd_Oprnd_B,           -- into regs at i/p of ALU
            UseData_Imm_Or_RegB,  -- Selects Immediate Data(8-bit) from Instrn 
                                  -- Latch or from Reg File PortB for ALU input
            UseData_Imm_Or_ALU,   -- Selects Immediate Data(16-bit) from Instrn
                                  -- Latch or from ALU Result
            Latch_Flags,          -- Enable for latching flags
            ALU_Zro,              -- ALU o/p 
            ALU_Neg,              -- ALU o/p 
            ALU_Carry,            -- ALU o/p 
            PSW_Zro,              -- Stack value of Zro flag
            PSW_Neg,              -- Stack value of Neg flag
            PSW_Carry             -- Stack value of Carry flag
                        : in std_logic;
            
            Crnt_Instrn           -- Instrn under execution from INSTRN_LAT
                        : in std_logic_vector (31 downto 0);

            RegPort_A,            -- RegFile portA data o/p;latched & fed to ALU
            RegPort_B,            -- RegFile portB data o/p;latched & fed to ALU
            Op_Result             -- ALU result; latched, then  muxed with 
                                  -- DataImmediate from INSTRN_LAT to feed 
                                  -- the RegFile as RegPort_C
                        : in std_logic_vector (15 downto 0);

            Zro_Flag,             -- Latched flag 
            Neg_Flag,             -- Latched flag
            Carry_Flag            -- Latched flag (Not implemented )
                        : out std_logic;
            Addr_A                -- to calculate address for REG_FILE port A  
                        : out std_logic_vector (6 downto 0);
            Oprnd_A,              -- Fed to ALU portA
            Oprnd_B,              -- Fed to ALU portB
            RegPort_C             -- I/p to RegFile portC
                        : out std_logic_vector (15 downto 0)
         );
end DATA_PATH;

architecture RTL of DATA_PATH is

    signal PSWL_Zro, PSWL_Carry, PSWL_Neg : std_logic;

begin
    process
    begin
	wait until Clk'event and Clk = '1';

-- Register at ALU input A
        if (Reset_AluRegs = '1') then
            Oprnd_A <= "0000000000000000";
        elsif (Rd_Oprnd_A = '1') then
            Oprnd_A <= RegPort_A;
        end if;

-- Register at ALU input B (Muxing with imm data included here)
        if (Reset_AluRegs = '1') then
            Oprnd_B <= "0000000000000000";
        elsif (Rd_Oprnd_B = '1') then
            if (UseData_Imm_Or_RegB = '1') then
                Oprnd_B <= "00000000" & Crnt_Instrn(7 downto 0);
            elsif (UseData_Imm_Or_RegB = '0') then
                Oprnd_B <= RegPort_B;
            end if;
        end if;

        if (Reset = '1') then
            PSWL_Zro <= '0';
            PSWL_Neg <= '0';
            PSWL_Carry <= '0';
        elsif (Latch_Flags = '1') then
	    PSWL_Zro <= PSW_Zro;
            PSWL_Neg <= PSW_Neg;
	    PSWL_Carry <= PSW_Carry;
        end if;
            
    end process;

-- Mux between latched ALU Result and Immediate data to be loaded into RegFile
    process (Crnt_Instrn, Op_Result, UseData_Imm_Or_ALU )
    begin
       if (UseData_Imm_Or_ALU = '1') then
           RegPort_C <= Crnt_Instrn (15 downto 0);
       else
           RegPort_C <= Op_Result;
       end if;
    end process;

-- Muxing of flags betn popped and ALU outputs - Return instrn alone requires popped flags
   process (Crnt_Instrn, PSWL_Zro, PSWL_Neg, PSWL_Carry, ALU_Zro, ALU_Neg, ALU_Carry)

    begin
        if (Crnt_Instrn(31 downto 24) = "00001000") then
            Zro_Flag   <= PSWL_Zro;
            Neg_Flag   <= PSWL_Neg;
            Carry_Flag <= PSWL_Carry;
        else
            Zro_Flag   <= ALU_Zro;
            Neg_Flag   <= ALU_Neg;
            Carry_Flag <= ALU_Carry;
        end if;
    end process;


-- Added by Anupam to calculate Address for port_A of REG_FILE

    process(Crnt_Instrn)
     begin
       if (Crnt_Instrn(31 downto 30) = "00" and Crnt_Instrn(24) = '1') then
          Addr_A <= Crnt_Instrn(6 downto 0);
       else
          Addr_A <= Crnt_Instrn(14 downto 8);
       end if;
     end process;

end RTL;
