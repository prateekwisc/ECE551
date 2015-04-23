library verilog;
use verilog.vl_types.all;
entity mux is
    port(
        \out\           : out    vl_logic;
        in1             : in     vl_logic;
        in2             : in     vl_logic;
        sel             : in     vl_logic
    );
end mux;
