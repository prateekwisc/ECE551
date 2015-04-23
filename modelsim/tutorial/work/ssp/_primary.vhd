library verilog;
use verilog.vl_types.all;
entity ssp is
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        SerData         : inout  vl_logic;
        StartOp         : in     vl_logic;
        Recv_nTran      : in     vl_logic;
        RecvData        : out    vl_logic_vector(7 downto 0);
        TranData        : in     vl_logic_vector(7 downto 0);
        RecvDataValid   : out    vl_logic
    );
end ssp;
