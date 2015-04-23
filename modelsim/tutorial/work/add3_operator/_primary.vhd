library verilog;
use verilog.vl_types.all;
entity add3_operator is
    generic(
        N               : integer := 8
    );
    port(
        y               : out    vl_logic_vector;
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        c               : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end add3_operator;
