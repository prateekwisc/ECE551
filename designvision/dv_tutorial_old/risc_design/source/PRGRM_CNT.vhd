library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity  PRGRM_CNT is
    port (
             Reset,             -- Reset for the PC
             Clk,               -- CPU Clock
             Incrmnt_PC,        -- Increment PC
             Ld_Brnch_Addr,     -- Load Jmp/Call Addr from instruction
             Ld_Rtn_Addr        -- Load Return Addr
                      : in std_logic;
             Imm_Addr,          -- Immediate Addr for Jmp/Call
             Return_Addr        -- Return addr from Stack
                      : in std_logic_vector (7 downto 0);

             PC                 -- Addr of instruction to be fetched in
                                -- the next Fetch Cycle
                      : out std_logic_vector (7 downto 0)
         );

end PRGRM_CNT;

architecture RTL of PRGRM_CNT is

  signal PCint : std_logic_vector (7 downto 0);

begin

 process
 begin
       wait until clk'event and clk = '1';
       if (Reset = '1') then
           PCint <= "00000000";
       elsif (Incrmnt_PC = '1') then                 -- Occurs in WRITEBACK cycle
           PCint <= unsigned(PCint) + unsigned ' ("001");
       elsif (Ld_Rtn_Addr = '1') then                -- Occurs in WRITEBACK cycle
           PCint <= Return_Addr;
       elsif (Ld_Brnch_Addr = '1') then              -- Occurs in WRITEBACK cycle
           PCint <= Imm_Addr;
       end if;
 end process;

 PC <= PCint;

end RTL;
