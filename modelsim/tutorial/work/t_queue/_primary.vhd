library verilog;
use verilog.vl_types.all;
entity t_queue is
    generic(
        B               : integer := 8
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of B : constant is 1;
end t_queue;
