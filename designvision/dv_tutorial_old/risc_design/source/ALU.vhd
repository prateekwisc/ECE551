library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.RISCTYPES.all;

entity  ALU is 
    port (
	     Reset, Clk
		      : in std_logic;	
             Oprnd_A,            -- Operand A, from RegFile
             Oprnd_B             -- Operand B, from RegFile or current inst
                      : in std_logic_vector (15 downto 0); 


             ALU_OP              -- Code from OP field of Instruction
                      : in std_logic_vector (5 downto 0);

             Latch_Result,
	     Latch_Flags	
		      : in std_logic;	
             Lachd_Result           -- Result of performing OP on operands 
                      : out std_logic_vector (15 downto 0);

             Zro_Flag,            -- Zero flag
             Neg_Flag,            -- Negative result flag 
             Carry_Flag           -- Carry out flag
                      : out std_logic

         );
end ALU;

architecture RTL of ALU is

  signal Op_Result : std_logic_vector (15 downto 0);
  signal ALU_Zro, ALU_Carry, ALU_Neg : std_logic;

begin

      process 
       begin
	wait until Clk'event and Clk = '1';

            if (Latch_Result = '1') then
		Lachd_Result <= Op_Result;
            end if;

            if (Reset = '1') then
		Zro_Flag <= '0';
		Neg_Flag <= '0';
		Carry_Flag <= '0';
	    elsif (Latch_Flags = '1') then
		Zro_Flag <= ALU_Zro;
		Neg_Flag <= ALU_Neg;
		Carry_Flag <= ALU_Carry;
	    end if;

       end process;
	
-- ALU Operations
      process (Oprnd_A, Oprnd_B, ALU_OP)
          variable Result  : std_logic_vector(15 downto 0);
          variable I,count : integer;
	  variable carry   : std_logic;
      begin
	carry := '0';
	count := 0;

        case ALU_OP is

            when OP_ADD =>
                        Result := unsigned(Oprnd_A) + unsigned(Oprnd_B);

            when OP_ADD_PLUS_ONE =>
                        Result := unsigned(Oprnd_A) + (unsigned(Oprnd_B) + '1');

            when OP_A | OP_Ap | OP_App =>
                        Result := Oprnd_A;

            when OP_A_PLUS_ONE =>
                        Result := unsigned(Oprnd_A) + '1';

            when OP_SUB =>
                        Result := unsigned(Oprnd_A) - unsigned(Oprnd_B);

            when OP_SUB_MINUS_ONE =>
                        Result := unsigned(Oprnd_A) - (unsigned(Oprnd_B) + '1');

            when OP_A_MINUS_ONE =>
                        Result := unsigned(Oprnd_A) - '1';

            when OP_ALL_ZEROS =>
                        Result := "0000000000000000";

            when OP_A_AND_B =>
                        Result := Oprnd_A and Oprnd_B;

            when OP_notA_AND_B =>
                        Result := not Oprnd_A and Oprnd_B;

            when OP_B =>
                        Result := Oprnd_B;

            when OP_notA_AND_notB =>
                        Result := not Oprnd_A and not Oprnd_B;

            when OP_A_XNOR_B =>
                        Result := not (Oprnd_A xor Oprnd_B);

            when OP_notA =>
                        Result := not Oprnd_A;

            when OP_notA_OR_B =>
                        Result := not Oprnd_A or Oprnd_B;

            when OP_A_AND_notB =>
                        Result := Oprnd_A and not Oprnd_B;

            when OP_A_XOR_B =>
                        Result := Oprnd_A xor Oprnd_B;

            when OP_A_OR_B =>
                        Result := Oprnd_A or Oprnd_B;

            when OP_notB =>
                        Result := not Oprnd_B;

            when OP_A_OR_notB =>
                        Result := Oprnd_A or not Oprnd_B;

            when OP_A_NAND_B =>
                        Result := not (Oprnd_A and Oprnd_B);

            when OP_ALL_ONES =>
                        Result := "1111111111111111";

            -- When non-ALU ops don't generate errors
            when others =>
       			Result := "0000000000000000";
        end case;

       if (Result = 0) then
            ALU_Zro <= '1';
        else
            ALU_Zro <= '0';
        end if;

        if (Result < 0) then
            ALU_Neg <= '1';
        else
            ALU_Neg <= '0';
        end if;

        ALU_Carry <= '0';

        Op_Result <= Result;

      end process;
end RTL;


