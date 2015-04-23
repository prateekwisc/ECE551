library verilog;
use verilog.vl_types.all;
entity add3_struct is
    generic(
        N               : integer := 8
    );
    port(
        Y               : out    vl_logic_vector;
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        C               : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end add3_struct;
