library verilog;
use verilog.vl_types.all;
entity mux_4_to_1 is
    port(
        I0              : in     vl_logic;
        I1              : in     vl_logic;
        I2              : in     vl_logic;
        I3              : in     vl_logic;
        C0              : in     vl_logic;
        C1              : in     vl_logic;
        Y               : out    vl_logic
    );
end mux_4_to_1;
