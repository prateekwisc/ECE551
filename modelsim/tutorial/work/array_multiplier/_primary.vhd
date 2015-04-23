library verilog;
use verilog.vl_types.all;
entity array_multiplier is
    generic(
        width           : integer := 8
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        y               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end array_multiplier;
