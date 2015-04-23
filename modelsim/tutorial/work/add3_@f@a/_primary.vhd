library verilog;
use verilog.vl_types.all;
entity add3_FA is
    port(
        y               : out    vl_logic;
        cout            : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic
    );
end add3_FA;
