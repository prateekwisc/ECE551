library verilog;
use verilog.vl_types.all;
entity mod_booth_multiplier_4 is
    port(
        product         : out    vl_logic_vector(31 downto 0);
        x               : in     vl_logic_vector(15 downto 0);
        y               : in     vl_logic_vector(15 downto 0)
    );
end mod_booth_multiplier_4;
