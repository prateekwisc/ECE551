library verilog;
use verilog.vl_types.all;
entity booth is
    generic(
        WidthMultiplicand: integer := 16;
        WidthMultiplier : integer := 16;
        WidthCount      : integer := 5;
        Comp_add        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        Add             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        load            : in     vl_logic;
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        done            : out    vl_logic;
        result          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WidthMultiplicand : constant is 1;
    attribute mti_svvh_generic_type of WidthMultiplier : constant is 1;
    attribute mti_svvh_generic_type of WidthCount : constant is 1;
    attribute mti_svvh_generic_type of Comp_add : constant is 1;
    attribute mti_svvh_generic_type of Add : constant is 1;
end booth;
