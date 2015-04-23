library verilog;
use verilog.vl_types.all;
entity CLA_16bit is
    port(
        Carry_out       : out    vl_logic;
        X               : out    vl_logic_vector(19 downto 0);
        A_old           : in     vl_logic_vector(19 downto 0);
        B_old           : in     vl_logic_vector(19 downto 0)
    );
end CLA_16bit;
