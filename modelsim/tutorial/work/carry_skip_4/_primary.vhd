library verilog;
use verilog.vl_types.all;
entity carry_skip_4 is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        X               : out    vl_logic_vector(3 downto 0);
        CIN             : in     vl_logic;
        COUT            : out    vl_logic
    );
end carry_skip_4;
