library verilog;
use verilog.vl_types.all;
entity my_mod1 is
    port(
        data_out        : out    vl_logic_vector(3 downto 0);
        data_in         : in     vl_logic_vector(3 downto 0);
        load            : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end my_mod1;
