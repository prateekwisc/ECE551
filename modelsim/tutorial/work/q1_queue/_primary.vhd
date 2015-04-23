library verilog;
use verilog.vl_types.all;
entity q1_queue is
    generic(
        WIDTH           : integer := 8;
        LENGTH          : integer := 16
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        data_in         : in     vl_logic_vector;
        wr              : in     vl_logic;
        rd              : in     vl_logic;
        data_out        : out    vl_logic_vector;
        full            : out    vl_logic;
        empty           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of LENGTH : constant is 1;
end q1_queue;
