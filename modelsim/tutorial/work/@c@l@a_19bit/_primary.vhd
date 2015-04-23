library verilog;
use verilog.vl_types.all;
entity CLA_19bit is
    port(
        Carry_out       : out    vl_logic;
        X               : out    vl_logic_vector(18 downto 0);
        A               : in     vl_logic_vector(17 downto 0);
        B               : in     vl_logic_vector(17 downto 0)
    );
end CLA_19bit;
