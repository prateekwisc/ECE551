library verilog;
use verilog.vl_types.all;
entity PIIR is
    port(
        AD              : inout  vl_logic_vector(15 downto 0);
        ALE             : out    vl_logic;
        RD              : out    vl_logic;
        WR              : out    vl_logic;
        CE              : in     vl_logic;
        PU              : in     vl_logic;
        Clk1            : in     vl_logic;
        Clk2            : in     vl_logic;
        Const           : in     vl_logic_vector(3 downto 0);
        CFG             : in     vl_logic
    );
end PIIR;
