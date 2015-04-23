library verilog;
use verilog.vl_types.all;
entity Receive is
    generic(
        IDLE            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        START_BIT       : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        BIT_0           : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        BIT_1           : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        BIT_2           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        BIT_3           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        BIT_4           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        BIT_5           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        BIT_6           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0);
        BIT_7           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi1);
        STOP_BIT        : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi1, Hi0)
    );
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        StartOp         : in     vl_logic;
        SerData         : in     vl_logic;
        DataValid       : out    vl_logic;
        DataOut         : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of START_BIT : constant is 1;
    attribute mti_svvh_generic_type of BIT_0 : constant is 1;
    attribute mti_svvh_generic_type of BIT_1 : constant is 1;
    attribute mti_svvh_generic_type of BIT_2 : constant is 1;
    attribute mti_svvh_generic_type of BIT_3 : constant is 1;
    attribute mti_svvh_generic_type of BIT_4 : constant is 1;
    attribute mti_svvh_generic_type of BIT_5 : constant is 1;
    attribute mti_svvh_generic_type of BIT_6 : constant is 1;
    attribute mti_svvh_generic_type of BIT_7 : constant is 1;
    attribute mti_svvh_generic_type of STOP_BIT : constant is 1;
end Receive;
