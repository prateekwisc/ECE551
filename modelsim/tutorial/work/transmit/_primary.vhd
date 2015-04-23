library verilog;
use verilog.vl_types.all;
entity transmit is
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        SerData         : out    vl_logic;
        StartOp         : in     vl_logic;
        DataIn          : in     vl_logic_vector(7 downto 0)
    );
end transmit;
