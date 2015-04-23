library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity REG_FILE is 
    port (
           Reset,             -- Reset for initialising registers
           Clk                -- CPU Clock
                   : in std_logic;
           Addr_A,            -- Address for port A
           Addr_B,            -- Address for port B
           Addr_C             -- Address for port C
                   : in std_logic_vector (6 downto 0);

           RegPort_C          -- Wr Data for port C
                   : in std_logic_vector (15 downto 0);

           Write_RegC
		   : in std_logic;

           RegPort_A,         -- Data Out of port A
           RegPort_B          -- Data Out of port A
                   : out std_logic_vector ( 15 downto 0)
          );
end REG_FILE;
architecture RTL of REG_FILE is

    type regfile_type is array (0 to 3) of std_logic_vector(15 downto 0);
    signal Reg_Array : regfile_type; 

begin

-- REG_FILE write
    process 
    begin
        wait until Clk'event and Clk = '1';
           if (Reset = '1') then
           for i in 0 to 3 loop
               Reg_Array(i) <= "0000000000000000";
           end loop;
           end if;

        if (Write_RegC = '1') then
            Reg_Array(conv_integer(unsigned(Addr_C(1 downto 0)))) <= RegPort_C;
        end if;
    end process;

-- REG_FILE reads
    process (Addr_A, Reg_Array)
    begin
        RegPort_A <= Reg_Array(conv_integer(unsigned(Addr_A(1 downto 0))));
    end process;

    process (Addr_B, Reg_Array)
    begin
        RegPort_B <= Reg_Array(conv_integer(unsigned(Addr_B(1 downto 0))));
    end process;
   
end RTL;
