library verilog;
use verilog.vl_types.all;
entity FAGP_1bit is
    port(
        C_out           : out    vl_logic;
        S               : out    vl_logic;
        G               : out    vl_logic;
        P               : out    vl_logic;
        InA             : in     vl_logic;
        InB             : in     vl_logic;
        C_In            : in     vl_logic
    );
end FAGP_1bit;
