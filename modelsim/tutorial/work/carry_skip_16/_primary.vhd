library verilog;
use verilog.vl_types.all;
entity carry_skip_16 is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        X               : out    vl_logic_vector(15 downto 0);
        C_in            : in     vl_logic;
        C_out           : out    vl_logic
    );
end carry_skip_16;
