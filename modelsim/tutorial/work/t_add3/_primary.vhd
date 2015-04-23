library verilog;
use verilog.vl_types.all;
entity t_add3 is
    generic(
        width           : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end t_add3;
