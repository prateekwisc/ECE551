library verilog;
use verilog.vl_types.all;
entity booth_mul is
    port(
        M               : in     vl_logic_vector(3 downto 0);
        Q               : in     vl_logic_vector(3 downto 0);
        Cout            : out    vl_logic_vector(7 downto 0)
    );
end booth_mul;
