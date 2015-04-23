library verilog;
use verilog.vl_types.all;
entity mod_booth_multiplier is
    generic(
        width           : integer := 16;
        N               : integer := 8
    );
    port(
        product         : out    vl_logic_vector;
        x               : in     vl_logic_vector;
        y               : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of N : constant is 1;
end mod_booth_multiplier;
