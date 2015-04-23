library verilog;
use verilog.vl_types.all;
entity BusInt is
    port(
        SerData         : inout  vl_logic;
        StartOp         : in     vl_logic;
        Recv_nTran      : in     vl_logic;
        RecvStartOp     : out    vl_logic;
        TranStartOp     : out    vl_logic;
        RecvSerData     : out    vl_logic;
        TranSerData     : in     vl_logic
    );
end BusInt;
